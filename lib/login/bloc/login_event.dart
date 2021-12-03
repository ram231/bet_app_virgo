part of 'login_bloc.dart';

@immutable
abstract class LoginEvent extends Equatable {
  const LoginEvent();
  @override
  List<Object?> get props => [];
}

class SignInEvent extends LoginEvent {
  final String username;
  final String password;
  SignInEvent({
    required this.username,
    required this.password,
  });

  @override
  List<Object?> get props => [username, password];

  SignInEvent copyWith({
    String? username,
    String? password,
  }) {
    return SignInEvent(
      username: username ?? this.username,
      password: password ?? this.password,
    );
  }
}

class LogoutEvent extends LoginEvent {
  const LogoutEvent();
}
