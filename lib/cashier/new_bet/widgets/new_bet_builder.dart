import 'package:bet_app_virgo/cashier/new_bet/bloc/new_bet_bloc.dart';
import 'package:bet_app_virgo/utils/nil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewBetBuilder extends StatelessWidget {
  const NewBetBuilder({Key? key, required this.builder}) : super(key: key);
  final Widget Function(NewBetLoaded state) builder;
  @override
  Widget build(BuildContext context) {
    final _state = context.watch<NewBetBloc>().state;
    if (_state is NewBetLoaded) {
      return builder(_state);
    }
    return notNil;
  }
}
