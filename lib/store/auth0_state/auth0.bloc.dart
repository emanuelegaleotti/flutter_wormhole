import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth0.event.dart';
import 'auth0.state.dart';

class Auth0Bloc extends Bloc<Auth0Event, Auth0State> {

  Auth0Bloc() : super(const Auth0State()) {
    on<InitAuth0Login>(_initLogin);
    on<Auth0Login>(_userLogin);
    on<Auth0Logout>(_userLogout);
  }

  _initLogin(InitAuth0Login event, Emitter<Auth0State> emit) async {
    final Auth0 auth0 = Auth0(
        'dev-06x745wl3prxhfno.us.auth0.com', 'rMDoB23QZoZaA8it5Hmu1w7tfCnpNl8a');
    final Credentials c = await auth0
        .webAuthentication(scheme: 'demo')
        .login();
    print(c.user.email);
    //demo://dev-06x745wl3prxhfno.us.auth0.com/android/com.example.flutter_wormhole/callback
    // emit(state.reducer());
  }

  _userLogin(Auth0Login event, Emitter<Auth0State> emit) async {
    // emit(state.reducer());
  }

  _userLogout(Auth0Logout event, Emitter<Auth0State> emit) async {
    // emit(state.reducer());
  }
}
