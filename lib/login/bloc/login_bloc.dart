import 'package:bet_app_virgo/models/user_account.dart';
import 'package:bet_app_virgo/utils/http_client.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:meta/meta.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends HydratedBloc<LoginEvent, LoginState> {
  late final STLHttpClient _httpClient;

  LoginBloc({STLHttpClient? httpClient}) : super(LoginInitial()) {
    _httpClient = httpClient ?? STLHttpClient();
    on<SignInEvent>(onLogin);
    on<LogoutEvent>((event, emit) {
      emit(LogoutState());
    });
  }

  void onLogin(SignInEvent event, Emitter emit) async {
    try {
      emit(LoginLoading());
      final result = await _httpClient.post<Map<String, dynamic>>(
        'api/auth/login',
        body: {
          "username": event.username,
          "password": event.password,
        },
      );
      emit(LoginSuccess(user: UserAccount.fromMap(result["user"])));
    } catch (e) {
      emit(LoginFailed(error: "$e"));
      addError("$e");
    }
  }

  @override
  LoginState? fromJson(Map<String, dynamic> json) {
    final isLoggedIn = json['isLoggedIn'] as bool? ?? false;
    if (isLoggedIn) {
      return LoginSuccess(user: UserAccount.fromMap(json['user']));
    }
    return LogoutState();
  }

  @override
  Map<String, dynamic>? toJson(LoginState state) {
    if (state is LoginSuccess) {
      return {
        'isLoggedIn': true,
        'user': state.user.toMap(),
      };
    }
    if (state is LogoutState) {
      return {
        'isLoggedIn': false,
      };
    }
  }
}
