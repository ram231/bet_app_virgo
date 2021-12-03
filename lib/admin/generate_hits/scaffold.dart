import 'package:bet_app_virgo/utils/escape_keyboard.dart';
import 'package:flutter/material.dart';

class BetGenerateHitScaffold extends StatelessWidget {
  static const path = "/gen-hits";
  const BetGenerateHitScaffold({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EscapeKeyboard(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Generate Hits",
          ),
          elevation: 0,
        ),
        body: Column(
          children: [
            Flexible(
              child: Flex(
                direction: Axis.horizontal,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    child: Text("GENERATE"),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextFormField(),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: null,
                    child: Text("SAVED HITS"),
                  ),
                  IconButton(
                    icon: Icon(Icons.date_range),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 11,
              child: _GeneralHitBody(),
            ),
          ],
        ),
      ),
    );
  }
}

class _GeneralHitBody extends StatefulWidget {
  const _GeneralHitBody({Key? key}) : super(key: key);

  @override
  State<_GeneralHitBody> createState() => _GeneralHitBodyState();
}

class _GeneralHitBodyState extends State<_GeneralHitBody> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columnSpacing: 30,
          headingRowHeight: 40,
          columns: [
            DataColumn(label: Text("Draw")),
            DataColumn(label: Text("Comb")),
            DataColumn(label: Text("Bet Amt")),
            DataColumn(label: Text("Doc No.")),
            DataColumn(label: Text("Win Amt")),
          ],
          rows: List.generate(
            50,
            (index) => DataRow(
              cells: [
                DataCell(Text("4PMS3")),
                DataCell(Text("960")),
                DataCell(Text("5.0")),
                DataCell(Text("863-322534")),
                DataCell(Text("2750.0")),
              ],
            ),
          ).toList(),
        ),
      ),
    );
  }
}
