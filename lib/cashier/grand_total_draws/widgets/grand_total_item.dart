import 'package:bet_app_virgo/cashier/grand_total_draws/cubit/grand_total_item_cubit.dart';
import 'package:bet_app_virgo/utils/nil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GrandTotalDrawItemScaffold extends StatelessWidget {
  const GrandTotalDrawItemScaffold({Key? key}) : super(key: key);
  static const path = 'grand-total/item/:id';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Receipts"),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: _BetTable(),
          ),
          _ErrorText(),
        ],
      ),
    );
  }
}

class _BetTable extends StatelessWidget {
  const _BetTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<GrandTotalItemCubit>().state;
    if (state.isLoading) {
      return Center(child: CircularProgressIndicator.adaptive());
    }

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(
              label: Text("Receipt No."),
            ),
            DataColumn(
              label: Text("Draw Name"),
            ),
            DataColumn(
              label: Text("Bet ID"),
            ),
            DataColumn(
              label: Text("Bet Number"),
            ),
            DataColumn(
              label: Text("Bet Amount"),
            ),
            DataColumn(
              label: Text("Winning Amount"),
            ),
            DataColumn(
              label: Text("Prize"),
            ),
          ],
          rows: state.items
              .map(
                (e) => DataRow(
                  cells: [
                    DataCell(Text("${e.receipt?.receiptNo ?? 'N/A'}")),
                    DataCell(Text("${e.draw?.drawType?.name}")),
                    DataCell(Text("${e.id}")),
                    DataCell(Text("${e.betNumber}")),
                    DataCell(Text("${e.readableBetAmount}")),
                    DataCell(Text("${e.draw?.readableWinningAmount}")),
                    DataCell(Text("${e.prize}")),
                  ],
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class _ErrorText extends StatelessWidget {
  const _ErrorText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<GrandTotalItemCubit>().state;
    if (state.hasError) {
      return Text(
        "${state.error}",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.red,
        ),
      );
    }
    return notNil;
  }
}
