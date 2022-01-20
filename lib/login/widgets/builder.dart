import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/login_bloc.dart';

class LoginAuthenticator extends StatefulWidget {
  const LoginAuthenticator({
    Key? key,
    required this.builder,
    required this.successListener,
    this.onLoading,
    this.onError,
  }) : super(key: key);
  final Widget Function(BuildContext context, LoginState state) builder;
  final void Function(LoginSuccess state) successListener;
  final void Function(LoginFailed state)? onError;
  final VoidCallback? onLoading;
  @override
  State<LoginAuthenticator> createState() => _LoginAuthenticatorState();
}

class _LoginAuthenticatorState extends State<LoginAuthenticator> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginLoading) {
          widget.onLoading?.call();
          return;
        }
        if (state is LoginSuccess) {
          widget.successListener(state);
          return;
        } else if (state is LoginFailed) {
          widget.onError?.call(state);
          return;
        }
      },
      builder: widget.builder,
    );
  }
}
