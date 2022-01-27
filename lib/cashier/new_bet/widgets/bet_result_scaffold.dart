import 'package:bet_app_virgo/cashier/new_bet/widgets/event_handler.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../login/bloc/login_bloc.dart';
import '../../../utils/nil.dart';
import '../../cashier.dart';
import '../cubit/create_new_bet_cubit.dart';

class BetResultScaffold extends StatelessWidget {
  const BetResultScaffold({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("BET CREATED"),
        elevation: 0,
      ),
      body: _BetResultBody(),
    );
  }
}

class _BetResultBody extends StatelessWidget {
  const _BetResultBody({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return PrinterListener(
      child: Column(
        children: [
          Flexible(child: Container(child: Text(""))),
          Flexible(child: BetResultTable()),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(context,
                      CupertinoPageRoute(builder: (context) {
                    return CashierNewBetScaffold();
                  }));
                },
                child: Text("NEW BET"),
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                ),
              ),
              _PrintResult(),
            ],
          )
        ],
      ),
    );
  }
}

class BetResultTable extends StatelessWidget {
  const BetResultTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final betResult = context.watch<CreateNewBetCubit>().state;
    if (betResult is CreateNewBetError) {
      return Text("${betResult.error}");
    }
    if (betResult is CreateNewBetLoading) {
      return Center(child: CircularProgressIndicator.adaptive());
    } else if (betResult is CreateNewBetLoaded) {
      final result = betResult.result;
      return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            rows: result
                .map((e) => DataRow(cells: [
                      DataCell(Text("${e.betNumber}")),
                      DataCell(Text("${e.readableBetAmount}")),
                      DataCell(Text("${e.prize}")),
                      DataCell(Text("${e.draw?.id}")),
                    ]))
                .toList(),
            columns: [
              DataColumn(label: Text("Bet Comb")),
              DataColumn(label: Text("Bet Amt")),
              DataColumn(label: Text("Prize")),
              DataColumn(label: Text("Draw")),
            ],
          ),
        ),
      );
    }
    return nil;
  }
}

class _PrintResult extends StatefulWidget {
  const _PrintResult({Key? key}) : super(key: key);

  @override
  __PrintResultState createState() => __PrintResultState();
}

class __PrintResultState extends State<_PrintResult> with PrinterMixin {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        final betResult = context.read<CreateNewBetCubit>().state;
        final userState = context.read<LoginBloc>().state;
        if (userState is LoginSuccess) {
          if (betResult is CreateNewBetLoaded) {
            final cashierId = userState.user.id;
            final result = betResult.result;

            printResult(cashierId, result);
          }
        }
      },
      child: Icon(Icons.print),
    );
  }
}

class PrinterListener extends StatefulWidget {
  const PrinterListener({
    required this.child,
    Key? key,
  }) : super(key: key);
  final Widget child;

  @override
  State<PrinterListener> createState() => _PrinterListenerState();
}

class _PrinterListenerState extends State<PrinterListener> with PrinterMixin {
  @override
  Widget build(BuildContext context) {
    final userState = context.watch<LoginBloc>().state;

    if (userState is LoginSuccess) {
      return BlocListener<CreateNewBetCubit, CreateNewBetState>(
        listener: (context, state) async {
          if (state is CreateNewBetLoaded) {
            final cashierId = userState.user.id;
            final result = state.result;
            await printResult(cashierId, result);
          }
        },
        listenWhen: (prev, curr) =>
            prev is CreateNewBetLoading && curr is CreateNewBetLoaded,
        child: widget.child,
      );
    }
    return widget.child;
  }
}
