import 'package:bet_app_virgo/utils/date_format.dart';
import 'package:flutter/material.dart';

class CashierBetCancelScaffold extends StatelessWidget {
  static const path = "/cashier/cancel-bet";
  const CashierBetCancelScaffold({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bet Cancel"),
        elevation: 0,
      ),
      body: Column(
        children: [
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: _BetCancelTextSearch(),
            ),
          ),
          Expanded(child: _BetCancelTable()),
        ],
      ),
    );
  }
}

class _BetCancelTextSearch extends StatefulWidget {
  const _BetCancelTextSearch({Key? key}) : super(key: key);

  @override
  __BetCancelTextSearchState createState() => __BetCancelTextSearchState();
}

class __BetCancelTextSearchState extends State<_BetCancelTextSearch> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: "Search Receipt",
      ),
    );
  }
}

class _BetCancelTable extends StatelessWidget {
  const _BetCancelTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = YEAR_MONTH_DATE.format(now);
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: MaterialStateProperty.all(Colors.yellow),
          rows: List.generate(
            5,
            (index) => DataRow(
              cells: [
                DataCell(Text("#$index")),
                DataCell(Text("#$index")),
                DataCell(Text("#$today")),
                DataCell(Text("#$index")),
                DataCell(Text("#$index")),
              ],
            ),
          ).toList(),
          columns: [
            DataColumn(label: Text("Doc No.")),
            DataColumn(label: Text("Draw")),
            DataColumn(label: Text("Time")),
            DataColumn(label: Text("Stat")),
            DataColumn(label: Text("Req")),
          ],
        ),
      ),
    );
  }
}
