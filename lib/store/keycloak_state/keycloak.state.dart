import 'package:equatable/equatable.dart';
import 'package:flutter_wormhole/shared/models/keycloak_user.model.dart';

enum KeycloakStatus { initial, login, refresh, logout }

class KeycloakState extends Equatable {
  const KeycloakState(
      {this.status = KeycloakStatus.initial,
        this.isAuthenticated = false,
        this.user});

  final KeycloakStatus status;
  final bool isAuthenticated;
  final KeycloakUser? user;

  KeycloakState reducer({KeycloakStatus? s, bool i = false, KeycloakUser? u}) {
    return KeycloakState(
        status: s ?? status,
        isAuthenticated: i,
        user: u
    );
  }

  @override
  String toString() {
    return 'KeycloakState { status: $status, isAuthenticated: $isAuthenticated, user: $user }';
  }

  @override
  List<Object> get props => [status, isAuthenticated];
}