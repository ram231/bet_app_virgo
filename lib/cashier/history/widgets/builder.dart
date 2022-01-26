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
  final Widget Function(BetHistoryLoaded state) builder;
  final Widget? onLoading;
  final Widget Function(BetHistoryError error)? onError;
  @override
  Widget build(BuildContext context) {
    final historyState = context.watch<BetHistoryBloc>().state;
    if (historyState is BetHistoryLoading) {
      return onLoading ?? notNil;
    }
    if (historyState is BetHistoryError) {
      return onError?.call(historyState) ?? notNil;
    }

    if (historyState is BetHistoryLoaded) {
      return builder(historyState);
    }

    return notNil;
  }
}
