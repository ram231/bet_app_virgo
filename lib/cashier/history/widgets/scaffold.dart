import 'package:bet_app_virgo/cashier/history/bloc/bet_history_bloc.dart';
import 'package:bet_app_virgo/utils/nil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class BetHistoryProvider extends StatelessWidget {
  const BetHistoryProvider({required this.child, Key? key}) : super(key: key);
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BetHistoryBloc()..add(FetchBetHistoryEvent()),
      child: child,
    );
  }
}

class CashierBetHistoryScaffold extends StatelessWidget {
  static const path = "/cashier/history";
  const CashierBetHistoryScaffold({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BetHistoryProvider(
      child: Scaffold(
        appBar: AppBar(
          title: Text("History"),
          elevation: 0,
        ),
        body: _BetHistoryBody(),
      ),
    );
  }
}

class _BetHistoryBody extends StatelessWidget {
  const _BetHistoryBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: BetHistoryTable(),
      ),
    );
  }
}

class BetHistoryTable extends StatelessWidget {
  const BetHistoryTable({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final historyState = context.watch<BetHistoryBloc>().state;
    if (historyState is BetHistoryLoading) {
      return Center(child: CircularProgressIndicator.adaptive());
    }
    if (historyState is BetHistoryLoaded) {
      final bets = historyState.bets;
      return DataTable(
        rows: bets
            .map(
              (e) => DataRow(
                cells: [
                  DataCell(Text("${e.id}")),
                  DataCell(Text("${e.betNumber}")),
                  DataCell(Text("${e.readableBetAmount}")),
                  DataCell(Text("${DateFormat.LLL().format(DateTime.now())}")),
                ],
              ),
            )
            .toList(),
        columns: [
          DataColumn(label: Text("ID")),
          DataColumn(label: Text("Bet Numbers")),
          DataColumn(label: Text("Bet Amount")),
          DataColumn(label: Text("Bet Date")),
        ],
      );
    }
    return notNil;
  }
}
