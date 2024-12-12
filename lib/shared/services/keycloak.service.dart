import 'dart:convert';
import 'dart:io';

import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_wormhole/shared/models/keycloak_user.model.dart';
import 'package:http_interceptor/http/intercepted_http.dart';

import '../interceptors/keycloak.interceptor.dart';

class KeycloakService {
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  final FlutterAppAuth appAuth = const FlutterAppAuth();
  final http = InterceptedHttp.build(interceptors: [
    KeycloakInterceptor(),
  ]);

  void _setTokens(String? idToken, String? refreshToken, String? accessToken,
      DateTime? accessTokenExpirationDateTime) async {
    await storage.write(key: 'idToken', value: idToken);
    await storage.write(key: 'refreshToken', value: refreshToken);
    await storage.write(key: 'accessToken', value: accessToken);
    await storage.write(
        key: 'expiration', value: accessTokenExpirationDateTime.toString());
  }

  Future<void> _deleteTokens() async {
    await storage.delete(key: 'idToken');
    await storage.delete(key: 'refreshToken');
    await storage.delete(key: 'accessToken');
    await storage.delete(key: 'expiration');
  }

  Future<KeycloakUser> userInfo() async {
    String? token = await storage.read(key: 'accessToken');
    var r = await http.get(
        Uri.http('10.0.2.2:8080',
            '/auth/realms/geico-app/protocol/openid-connect/userinfo'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
        });
    if (r.statusCode == 200) {
      return KeycloakUser.fromJson(jsonDecode(r.body));
    } else {
      throw Exception('Fail get userInfo');
    }
  }

  Future<KeycloakUser?> login() async {
    AuthorizationTokenResponse? r = await appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
            'wormole-android', 'com.example.flutterwormhole:/oauthredirect',
            issuer: 'http://10.0.2.2:8080/auth/realms/geico-app',
            discoveryUrl:
                'http://10.0.2.2:8080/auth/realms/geico-app/.well-known/openid-configuration',
            scopes: ["openid", "offline_access", "profile", "roles", "email"],
            allowInsecureConnections: true));
    if (r != null) {
      await storage.write(key: 'idToken', value: r.idToken);
      await storage.write(key: 'refreshToken', value: r.refreshToken);
      await storage.write(key: 'accessToken', value: r.accessToken);
      await storage.write(
          key: 'expiration', value: r.accessTokenExpirationDateTime.toString());
      final KeycloakUser ui = await KeycloakService().userInfo();
      return ui;
    }
    return null;
  }

  Future<KeycloakUser?> checkLogin() async {
    String? expirationDate = await storage.read(key: 'expiration');
    if (expirationDate != null &&
        DateTime.now().isBefore(DateTime.parse(expirationDate))) {
      final KeycloakUser ui = await KeycloakService().userInfo();
      return ui;
    }
    return null;
  }

  Future<TokenResponse?> refresh() async {
    String? expirationDate = await storage.read(key: 'expiration');
    if (expirationDate!.isNotEmpty &&
        DateTime.parse(expirationDate).isBefore(DateTime.now())) {
      String? token = await storage.read(key: 'refreshToken');
      TokenResponse? r = await appAuth.token(TokenRequest(
          'wormole-android', 'com.example.flutterwormhole:/oauthredirect',
          issuer: 'http://10.0.2.2:8080/auth/realms/geico-app',
          discoveryUrl:
              'http://10.0.2.2:8080/auth/realms/geico-app/.well-known/openid-configuration',
          scopes: ["openid", "offline_access", "profile", "roles", "email"],
          refreshToken: token,
          allowInsecureConnections: true));
      if (r != null) {
        _setTokens(r.idToken, r.refreshToken, r.accessToken,
            r.accessTokenExpirationDateTime);
        return r;
      }
      return null;
    }
    return null;
  }

  Future<EndSessionResponse?> logout() async {
    String? token = await storage.read(key: 'idToken');
    EndSessionResponse? r = await appAuth.endSession(EndSessionRequest(
        idTokenHint: token,
        postLogoutRedirectUrl: 'com.example.flutterwormhole:/oauthredirect',
        serviceConfiguration: const AuthorizationServiceConfiguration(
          authorizationEndpoint:
              'http://10.0.2.2:8080/auth/realms/geico-app/protocol/openid-connect/auth',
          tokenEndpoint:
              'http://10.0.2.2:8080/auth/realms/geico-app/protocol/openid-connect/token',
          endSessionEndpoint:
              'http://10.0.2.2:8080/auth/realms/geico-app/protocol/openid-connect/logout',
        )));
    if (r != null) {
      _deleteTokens();
    }
    return r;
  }
}
