import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_wormhole/shared/models/keycloak_user.model.dart';
import 'package:flutter_wormhole/shared/services/keycloak.service.dart';
import 'keycloak.event.dart';
import 'keycloak.state.dart';

class KeycloakBloc extends Bloc<KeycloakEvent, KeycloakState> {
  final FlutterAppAuth appAuth = const FlutterAppAuth();
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  final KeycloakService ks =  KeycloakService();

  KeycloakBloc() : super(const KeycloakState()) {
    on<InitKeycloakLogin>(_initLogin);
    on<KeycloakLogin>(_userLogin);
    on<KeycloakRefresh>(_userRefresh);
    on<KeycloakLogout>(_userLogout);
  }

  _initLogin(InitKeycloakLogin event, Emitter<KeycloakState> emit) async {
    final KeycloakUser? ui = await ks.checkLogin();
    if (ui != null) {
      emit(state.reducer(s: KeycloakStatus.initial, i: true, u: ui));
    } else {
      emit(state.reducer(i: false, u: null));
    }
  }

  _userLogin(KeycloakLogin event, Emitter<KeycloakState> emit) async {
    final KeycloakUser? ui = await ks.login();
    if (ui != null) {
      emit( state.reducer(s: KeycloakStatus.login, i: true, u: ui));
    } else {
      emit(state.reducer(i: false, u: null));
    }
  }

  _userRefresh(KeycloakEvent event, Emitter<KeycloakState> emit) async {
    final TokenResponse? r = await ks.refresh();
  }

  _userLogout(KeycloakLogout event, Emitter<KeycloakState> emit) async {
    final EndSessionResponse? r = await ks.logout();
    emit(state.reducer(s: KeycloakStatus.logout, i: false, u: null));
  }
}
