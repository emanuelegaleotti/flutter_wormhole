import 'package:equatable/equatable.dart';

class Auth0Event extends Equatable {
  @override
  List<Object> get props => [];
}

class InitAuth0Login extends Auth0Event {}
class Auth0Login extends Auth0Event {}
class Auth0Logout extends Auth0Event {}