import 'package:bet_app_virgo/cashier/dashboard/cubit/grand_total_cubit.dart';
import 'package:bet_app_virgo/utils/nil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GrandTotalBuilder extends StatelessWidget {
  const GrandTotalBuilder({
    required this.builder,
    this.onLoading,
    Key? key,
  }) : super(key: key);
  final Widget? onLoading;
  final Widget Function(GrandTotalLoaded state) builder;
  @override
  Widget build(BuildContext context) {
    final grandTotalState = context.watch<GrandTotalCubit>().state;
    if (grandTotalState is GrandTotalLoading) {
      return onLoading ?? notNil;
    }
    if (grandTotalState is GrandTotalLoaded) {
      return builder(grandTotalState);
    }
    return notNil;
  }
}
