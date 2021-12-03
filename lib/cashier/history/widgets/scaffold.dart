import 'package:flutter/material.dart';

class CashierBetHistoryScaffold extends StatelessWidget {
  static const path = "/cashier/history";
  const CashierBetHistoryScaffold({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("History"),
        elevation: 0,
      ),
      body: _BetHistoryBody(),
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
        child: DataTable(
          rows: [
            DataRow(
              cells: [
                DataCell(Text("")),
                DataCell(Text("")),
                DataCell(Text("")),
                DataCell(Text("")),
              ],
            ),
          ],
          columns: [
            DataColumn(label: Text("ID")),
            DataColumn(label: Text("Bet Date")),
            DataColumn(label: Text("Time")),
            DataColumn(label: Text("Doc No.")),
          ],
        ),
      ),
    );
  }
}
