import 'package:equatable/equatable.dart';

enum AppAuthStatus { initial, login, logout }

class AppAuthState extends Equatable {
  const AppAuthState(
      {this.status = AppAuthStatus.initial,
        this.isAuthenticated = false,
        this.user});

  final AppAuthStatus status;
  final bool isAuthenticated;
  final String? user;

  AppAuthState reducer({AppAuthStatus? s, bool? i, String? u}) {
    return AppAuthState(
        status: s ?? status,
        isAuthenticated: i ?? isAuthenticated,
        user: u ?? user);
  }

  @override
  String toString() {
    return 'AppAuthState { status: $status, isAuthenticated: $isAuthenticated, user: $user }';
  }

  @override
  List<Object> get props => [status, isAuthenticated];
}