import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    return Column(
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
            // _PrintResult(),
          ],
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
    final result = betResult;
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
}
