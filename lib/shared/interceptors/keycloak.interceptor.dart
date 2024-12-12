import 'package:flutter_wormhole/shared/services/keycloak.service.dart';
import 'package:http/src/base_request.dart';
import 'package:http/src/base_response.dart';
import 'package:http_interceptor/models/interceptor_contract.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class KeycloakInterceptor implements InterceptorContract {
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  @override
  Future<BaseRequest> interceptRequest({required BaseRequest request}) async {
    await KeycloakService().refresh();
    String? token = await storage.read(key: 'accessToken');
    try {
      request.headers.addAll({'Authorization': 'Bearer $token'});
    } catch (e) {
      print(e);
    }
    return request;
  }
  @override
  Future<BaseResponse> interceptResponse({required BaseResponse response}) async {
    return response;

  }

  @override
  Future<bool> shouldInterceptRequest() async {
   return true;
  }

  @override
  Future<bool> shouldInterceptResponse() async {
   return false;
  }

}
