import 'package:bet_app_virgo/utils/nil.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

import '../bloc/hits_report_bloc.dart';

class HitsReportBuilder extends StatelessWidget {
  const HitsReportBuilder({
    Key? key,
    required this.builder,
    this.onLoading,
  }) : super(key: key);
  final Widget Function(HitsReportLoaded state) builder;
  final Widget? onLoading;
  @override
  Widget build(BuildContext context) {
    final _state = context.watch<HitsReportBloc>().state;
    if (_state is HitsReportLoading) {
      return onLoading ?? notNil;
    }
    if (_state is HitsReportLoaded) {
      return builder(_state);
    }
    return notNil;
  }
}
