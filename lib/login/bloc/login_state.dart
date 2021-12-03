part of 'login_bloc.dart';

@immutable
abstract class LoginState extends Equatable {
  const LoginState();
  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoginSuccess extends LoginState {
  final UserAccount user;
  const LoginSuccess({
    required this.user,
  });

  @override
  List<Object> get props => [user];
}

class LoginLoading extends LoginState {}

class LoginFailed extends LoginState {
  final String error;
  const LoginFailed({
    required this.error,
  });

  @override
  List<Object> get props => [error];
}

class LogoutState extends LoginState {}
