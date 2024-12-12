import 'package:equatable/equatable.dart';

enum Auth0Status { initial, login, logout }

class Auth0State extends Equatable {
  const Auth0State(
      {this.status = Auth0Status.initial,
        this.isAuthenticated = false,
        this.user});

  final Auth0Status status;
  final bool isAuthenticated;
  final String? user;

  Auth0State reducer({Auth0Status? s, bool? i, String? u}) {
    return Auth0State(
        status: s ?? status,
        isAuthenticated: i ?? isAuthenticated,
        user: u ?? user);
  }

  @override
  String toString() {
    return 'Auth0State { status: $status, isAuthenticated: $isAuthenticated, user: $user }';
  }

  @override
  List<Object> get props => [status, isAuthenticated];
}