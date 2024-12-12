import 'package:equatable/equatable.dart';

class AppAuthEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class InitAppAuthLogin extends AppAuthEvent {}
class AppAuthLogin extends AppAuthEvent {}
class AppAuthLogout extends AppAuthEvent {}