import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utils/nil.dart';
import '../cubit/create_new_bet_cubit.dart';
import 'scaffold.dart';

class BetResultScaffold extends StatelessWidget {
  const BetResultScaffold({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _BetResultBody(),
    );
  }
}

class _BetResultBody extends StatelessWidget {
  const _BetResultBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(child: Container(child: Text(""))),
        Flexible(child: BetResultTable()),
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
        )
      ],
    );
  }
}

class BetResultTable extends StatelessWidget {
  const BetResultTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final betResult = context.watch<CreateNewBetCubit>().state;
    if (betResult is CreateNewBetLoading) {
      return Center(child: CircularProgressIndicator.adaptive());
    } else if (betResult is CreateNewBetLoaded) {
      final result = betResult.result;
      return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            rows: result.betNumber
                .map((e) => DataRow(cells: [
                      DataCell(Text("$e")),
                      DataCell(Text("${result.readableBetAmount}")),
                      DataCell(Text(
                          "${result.isWinner == true ? result.draw?.winningAmount : 0}")),
                      DataCell(Text("${result.draw?.drawTypeId}")),
                    ]))
                .toList(),
            columns: [
              DataColumn(label: Text("Bet Comb")),
              DataColumn(label: Text("Bet Amt")),
              DataColumn(label: Text("Win Amt")),
              DataColumn(label: Text("Sched")),
            ],
          ),
        ),
      );
    }
    return nil;
  }
}
