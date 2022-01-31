import 'package:bet_app_virgo/cashier/history/bloc/bet_history_bloc.dart';
import 'package:bet_app_virgo/utils/nil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BetHistoryBuilder extends StatelessWidget {
  const BetHistoryBuilder({
    required this.builder,
    this.onError,
    this.onLoading,
    Key? key,
  }) : super(key: key);
  final Widget Function(BetHistoryState state) builder;
  final Widget? onLoading;
  final Widget Function(String error)? onError;
  @override
  Widget build(BuildContext context) {
    final historyState = context.watch<BetHistoryBloc>().state;
    if (historyState.isLoading) {
      return onLoading ?? notNil;
    }
    if (historyState.hasError) {
      return onError?.call(historyState.error) ?? notNil;
    }

    return builder(historyState);
    ;
  }
}
