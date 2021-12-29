import 'package:bet_app_virgo/cashier/printer/cubit/blue_thermal_cubit.dart';
import 'package:bet_app_virgo/utils/nil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlueThermalBuilder extends StatelessWidget {
  const BlueThermalBuilder({required this.builder, this.onLoading, Key? key})
      : super(key: key);
  final Widget? onLoading;
  final Widget Function(BlueThermalLoaded state) builder;
  @override
  Widget build(BuildContext context) {
    final state = context.watch<BlueThermalCubit>().state;
    if (state is BlueThermalLoading) {
      return onLoading ?? notNil;
    }
    if (state is BlueThermalLoaded) {
      return builder(state);
    }
    return notNil;
  }
}
