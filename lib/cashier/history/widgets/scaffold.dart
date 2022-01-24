import 'package:bet_app_virgo/cashier/history/bloc/bet_history_bloc.dart';
import 'package:bet_app_virgo/models/models.dart';
import 'package:bet_app_virgo/utils/http_client.dart';
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
    if (historyState is BetHistoryError) {
      return Center(child: Text("${historyState.error}"));
    }
    if (historyState is BetHistoryLoaded) {
      final bets = historyState.bets;
      return DataTable(
        showBottomBorder: true,
        showCheckboxColumn: true,
        rows: bets
            .map(
              (e) => DataRow(
                color: e.isCancel
                    ? MaterialStateProperty.all(Colors.red[200])
                    : null,
                cells: [
                  DataCell(Text("${e.id}")),
                  DataCell(Text("${e.betNumber}")),
                  DataCell(Text("${e.readableBetAmount}")),
                  DataCell(
                      Text("${DateFormat.yMMMEd().format(DateTime.now())}")),
                  DataCell(e.isCancel
                      ? Text("CANCELLED")
                      : IconButton(
                          icon: Icon(
                            Icons.delete_forever,
                          ),
                          onPressed: () async {
                            final result = await showDialog<bool>(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text("Delete Bet #${e.id}?"),
                                    content: Text(
                                        "Are you sure you want to delete this bet?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context, false);
                                        },
                                        child: Text("CANCEL"),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context, true);
                                        },
                                        child: Text("CONFIRM"),
                                      )
                                    ],
                                  );
                                });
                            if (result != null && result) {
                              await ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Deleting...")));

                              try {
                                final http = STLHttpClient();
                                await http.post(
                                    "$adminEndpoint/bets/cancel/${e.id}",
                                    onSerialize: (json) =>
                                        BetResult.fromMap(json));
                                context
                                    .read<BetHistoryBloc>()
                                    .add(FetchBetHistoryEvent());
                                await ScaffoldMessenger.of(context)
                                    .showSnackBar(
                                  SnackBar(
                                    content: Text("Deleted Bet #${e.id}"),
                                  ),
                                );
                              } catch (e) {
                                await ScaffoldMessenger.of(context)
                                  ..removeCurrentSnackBar()
                                  ..showSnackBar(
                                    SnackBar(
                                      content: Text("Something went wrong..."),
                                    ),
                                  );
                              }
                            }
                          },
                          color: Colors.red,
                        ))
                ],
              ),
            )
            .toList(),
        columns: [
          DataColumn(label: Text("ID")),
          DataColumn(label: Text("Bet Numbers")),
          DataColumn(label: Text("Bet Amount")),
          DataColumn(label: Text("Bet Date")),
          DataColumn(label: Text("Actions")),
        ],
      );
    }
    return notNil;
  }
}
