import 'package:bet_app_virgo/cashier/new_bet/bloc/new_bet_bloc.dart';
import 'package:bet_app_virgo/cashier/printer/cubit/blue_thermal_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../login/bloc/login_bloc.dart';
import '../cubit/create_new_bet_cubit.dart';
import 'bet_result_scaffold.dart';

class NewBetBuilder extends StatelessWidget {
  const NewBetBuilder({
    Key? key,
    required this.builder,
  }) : super(key: key);
  final Widget Function(NewBetLoaded state) builder;
  @override
  Widget build(BuildContext context) {
    final state = context.watch<NewBetBloc>().state;
    return builder(state);
  }
}

class NewBetListener extends StatelessWidget {
  const NewBetListener({required this.child, Key? key}) : super(key: key);
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return _NewBetBluetoothListener(
      child: BlocListener<NewBetBloc, NewBetLoaded>(
        listener: (context, state) async {
          final userState = context.read<LoginBloc>().state;
          if (userState is LoginSuccess) {
            Navigator.pushReplacement(
              context,
              CupertinoPageRoute(
                builder: (context) {
                  return BlocProvider(
                    create: (_) => CreateNewBetCubit(
                      betResult: state.result,
                    ),
                    child: BetResultScaffold(),
                  );
                },
              ),
            );
          }
        },
        listenWhen: (prev, curr) => curr.status == PrintStatus.done,
        child: child,
      ),
    );
  }
}

class _NewBetBluetoothListener extends StatelessWidget {
  const _NewBetBluetoothListener({
    required this.child,
    Key? key,
  }) : super(key: key);
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return BlocListener<BlueThermalCubit, BlueThermalLoaded>(
      listener: (context, state) {
        context
            .read<NewBetBloc>()
            .add(ConnectPrinterEvent(isConnected: state.isConnected));
      },
      child: child,
    );
  }
}
