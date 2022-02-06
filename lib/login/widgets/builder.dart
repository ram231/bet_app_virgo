import 'dart:async';

import 'package:bet_app_virgo/models/models.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utils/utils.dart';
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

class LoginSuccessBuilder extends StatelessWidget {
  const LoginSuccessBuilder({
    required this.builder,
    Key? key,
  }) : super(key: key);
  final Widget Function(UserAccount cashier) builder;
  @override
  Widget build(BuildContext context) {
    final userState = context.watch<LoginBloc>().state;
    if (userState is LoginSuccess) {
      return builder(userState.user);
    }
    return notNil;
  }
}

class BluetoothStatusBuilder extends StatefulWidget {
  const BluetoothStatusBuilder({
    required this.builder,
    Key? key,
  }) : super(key: key);
  final Widget Function(int state) builder;

  @override
  State<BluetoothStatusBuilder> createState() => _BluetoothStatusBuilderState();
}

class _BluetoothStatusBuilderState extends State<BluetoothStatusBuilder> {
  late final StreamSubscription<int?> _streamSubscription;
  int val = 0;
  @override
  void initState() {
    _streamSubscription =
        BlueThermalPrinter.instance.onStateChanged().listen((event) {
      debugPrint("$event");
      setState(() {
        val = event ?? 0;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(val);
  }
}
