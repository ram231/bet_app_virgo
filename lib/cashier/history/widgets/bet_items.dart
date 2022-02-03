import 'package:bet_app_virgo/cashier/history/data/receipt_data.dart';
import 'package:bet_app_virgo/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class BetHistoryItemProvider extends StatelessWidget {
  const BetHistoryItemProvider({
    required this.receipt,
    required this.child,
    Key? key,
  }) : super(key: key);
  final BetReceipt receipt;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (c) => BetReceiptData(receipt),
      child: child,
    );
  }
}

class BetHistoryItemScaffold extends StatelessWidget {
  const BetHistoryItemScaffold({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<BetReceiptData>().state;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Receipt #${state.receiptNo}"),
      ),
      body: _Body(),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<BetReceiptData>().state;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: DataTable(
          rows: state.bets.map((bet) {
            final createdAt = DateFormat.yMMMd()
                .add_jms()
                .format(DateTime.parse(bet.createdAt));
            return DataRow(cells: [
              DataCell(Text("${bet.id}")),
              DataCell(Text("${bet.betNumber}")),
              DataCell(Text("${bet.betAmount}")),
              DataCell(Text("${bet.winningAmount}")),
              DataCell(Text("${bet.prize}")),
              DataCell(Text("${createdAt}")),
            ]);
          }).toList(),
          columns: [
            DataColumn(label: Text("ID")),
            DataColumn(label: Text("Bet Number")),
            DataColumn(label: Text("Bet Amount")),
            DataColumn(label: Text("Winning Amount")),
            DataColumn(label: Text("Prize")),
            DataColumn(label: Text("Date")),
          ],
        ),
      ),
    );
  }
}
