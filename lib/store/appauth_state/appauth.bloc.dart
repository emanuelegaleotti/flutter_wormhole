import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'appauth.event.dart';
import 'appauth.state.dart';

class AppAuthBloc extends Bloc<AppAuthEvent, AppAuthState> {
  FlutterAppAuth appAuth = const FlutterAppAuth();

  AppAuthBloc() : super(const AppAuthState()) {
    on<InitAppAuthLogin>(_initLogin);
    on<AppAuthLogin>(_userLogin);
    on<AppAuthLogout>(_userLogout);
  }

  _initLogin(InitAppAuthLogin event, Emitter<AppAuthState> emit) async {
    final AuthorizationTokenResponse? r =
        await appAuth.authorizeAndExchangeCode(AuthorizationTokenRequest(
            'rMDoB23QZoZaA8it5Hmu1w7tfCnpNl8a',
            'com.example.flutterwormhole:/oauthredirect',
            issuer: 'https://dev-06x745wl3prxhfno.us.auth0.com',
            discoveryUrl:
                'https://dev-06x745wl3prxhfno.us.auth0.com/.well-known/openid-configuration',
            scopes: ["openid", "offline_access", "profile", "roles", "email"],
            allowInsecureConnections: true));
    print(r?.idToken);
  }

  _userLogin(AppAuthLogin event, Emitter<AppAuthState> emit) async {
    // emit(state.reducer());
  }

  _userLogout(AppAuthLogout event, Emitter<AppAuthState> emit) async {
    // emit(state.reducer());
  }
}
