import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../bloc/hits_report_bloc.dart';
import 'builder.dart';

class HitReportsProvider extends StatelessWidget {
  const HitReportsProvider({
    Key? key,
    required this.child,
  }) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HitsReportBloc(),
      child: child,
    );
  }
}

class CashierHitScaffold extends StatelessWidget {
  static const path = "/cashier/hits";
  const CashierHitScaffold({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HitReportsProvider(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Hits Report"),
        ),
        body: _HitsBody(),
      ),
    );
  }
}

class _HitsBody extends StatefulWidget {
  const _HitsBody({Key? key}) : super(key: key);

  @override
  State<_HitsBody> createState() => _HitsBodyState();
}

class _HitsBodyState extends State<_HitsBody> {
  @override
  void initState() {
    context.read<HitsReportBloc>().add(FetchHitReportsEvent(
          dateTime: DateTime.now(),
        ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateFormat.yMd().format(now);
    return Column(
      children: [
        Flexible(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text("Draw date: $today"),
                Spacer(),
                ElevatedButton(
                  onPressed: () {},
                  child: Text("CHANGE DATE"),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: _HitsTable(),
        ),
      ],
    );
  }
}

class _HitsTable extends StatelessWidget {
  const _HitsTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HitsReportBuilder(
        onLoading: Center(child: CircularProgressIndicator.adaptive()),
        builder: (state) {
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                rows: state.draws.map((draw) => DataRow(cells: [
                  DataCell(Text("${draw.drawType?.name}")),
                  DataCell(Text("# ${draw.drawType?.id}")),
                  DataCell(Text("${draw.id}")),
                  DataCell(Text("${draw.id}")),
                  DataCell(Text("${draw.readableWinningAmount}"))
                ])).toList(),
                columns: [
                  DataColumn(label: Text("Draw")),
                  DataColumn(label: Text("Bet key")),
                  DataColumn(label: Text("Bet amount")),
                  DataColumn(label: Text("Doc No.")),
                  DataColumn(label: Text("Win Amt")),
                ],
              ),
            ),
          );
        });
  }
}
