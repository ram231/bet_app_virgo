import 'package:bet_app_virgo/login/widgets/builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/models.dart';
import '../../../utils/nil.dart';
import '../cubit/grand_total_draws_cubit.dart';

class GrandTotalDrawProvider extends StatelessWidget {
  const GrandTotalDrawProvider({
    Key? key,
    required this.child,
  }) : super(key: key);
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return LoginSuccessBuilder(builder: (user) {
      return BlocProvider(
        create: (context) => GrandTotalDrawsCubit(user: user)..fetch(),
        child: child,
      );
    });
  }
}

class GrandTotalDrawBuilder extends StatelessWidget {
  const GrandTotalDrawBuilder({
    Key? key,
    this.onLoading,
    this.onError,
    required this.builder,
  }) : super(key: key);
  final Widget? onLoading;
  final Widget Function(String err)? onError;
  final Widget Function(List<WinningHitsResult> draws) builder;
  @override
  Widget build(BuildContext context) {
    final state = context.watch<GrandTotalDrawsCubit>().state;
    if (state.isLoading) {
      return onLoading ?? notNil;
    }
    if (state.hasErrors) {
      return onError?.call(state.error) ?? notNil;
    }
    return builder(state.draws);
  }
}
