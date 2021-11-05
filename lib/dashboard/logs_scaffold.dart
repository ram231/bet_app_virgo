import 'package:flutter/material.dart';

class BetLogsScaffold extends StatelessWidget {
  static const path = "/logs/:id";
  const BetLogsScaffold({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: SizedBox(
        width: double.infinity,
        child: _BetLogsBody(),
      ),
    );
  }
}

class _BetLogsBody extends StatefulWidget {
  const _BetLogsBody({Key? key}) : super(key: key);

  @override
  State<_BetLogsBody> createState() => _BetLogsBodyState();
}

class _BetLogsBodyState extends State<_BetLogsBody> {
  void _onItemShow() {}
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columnSpacing: 30,
          headingRowHeight: 40,
          columns: [
            DataColumn(label: Text("")),
            DataColumn(
              label: Text("AreaName"),
            ),
            DataColumn(
              label: Text("Bet"),
            ),
            DataColumn(
              label: Text("Hits"),
            ),
            DataColumn(
              label: Text("Kabig/\nTapal"),
            ),
          ],
          rows: [
            DataRow(
              cells: [
                DataCell(
                  Icon(Icons.keyboard_arrow_down),
                  onTap: () {
                    _onItemShow();
                  },
                ),
                DataCell(
                  Text("Zero Acsan"),
                  onTap: () {
                    _onItemShow();
                  },
                ),
                DataCell(
                  Text("15,525"),
                  onTap: () {
                    _onItemShow();
                  },
                ),
                DataCell(
                  Text("5,500"),
                  onTap: () {
                    _onItemShow();
                  },
                ),
                DataCell(
                  Text("10,025"),
                  onTap: () {
                    _onItemShow();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
