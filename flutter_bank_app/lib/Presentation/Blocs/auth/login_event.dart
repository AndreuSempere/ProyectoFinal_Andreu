import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginButtonPressed extends LoginEvent {
  final String email;
  final String password;

  LoginButtonPressed({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class LogoutButtonPressed extends LoginEvent {}

class RegisterButtonPressed extends LoginEvent {
  final String email;
  final String password;

  RegisterButtonPressed({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class CheckAuthentication extends LoginEvent {}

class ResetPasswordEvent extends LoginEvent {
  final String email;

  ResetPasswordEvent({required this.email});

  @override
  List<Object?> get props => [email];
}

class NewUserEvent extends LoginEvent {
  final String name;
  final String surname;
  final String email;
  final String password;
  final String dni;
  final String age;

  NewUserEvent(
      this.name, this.surname, this.email, this.password, this.dni, this.age);
}

class FetchUserDataEvent extends LoginEvent {
  final String email;

  FetchUserDataEvent({required this.email});
}
