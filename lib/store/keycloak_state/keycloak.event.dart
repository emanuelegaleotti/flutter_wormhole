import 'package:equatable/equatable.dart';

class KeycloakEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class InitKeycloakLogin extends KeycloakEvent {}
class KeycloakLogin extends KeycloakEvent {}
class KeycloakRefresh extends KeycloakEvent {}
class KeycloakLogout extends KeycloakEvent {}