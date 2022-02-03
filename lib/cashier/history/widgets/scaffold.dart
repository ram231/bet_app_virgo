import 'package:bet_app_virgo/cashier/history/bloc/bet_history_bloc.dart';
import 'package:bet_app_virgo/utils/date_format.dart';
import 'package:bet_app_virgo/utils/nil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'builder.dart';

class BetHistoryProvider extends StatelessWidget {
  const BetHistoryProvider({required this.child, Key? key}) : super(key: key);
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BetHistoryBloc()..fetch(),
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
        body: Column(
          children: [
            Flexible(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: const [
                  _BetHistoryDrawDateText(),
                  Spacer(),
                  _BetHistoryChangeDateButton(),
                ],
              ),
            )),
            Flexible(child: _BetHistoryBody()),
          ],
        ),
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
    if (historyState.isLoading) {
      return Center(child: CircularProgressIndicator.adaptive());
    }
    if (historyState.hasError) {
      return Center(child: Text("${historyState.error}"));
    }
    final bets = historyState.bets;
    if (bets.isNotEmpty) {
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
                  DataCell(Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (e.receipt?.status != 'I')
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              primary: Colors.red,
                              onPrimary: Colors.white,
                            ),
                            onPressed: () async {
                              final result = await showDialog<bool>(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text(
                                              "Cancel Receipt #${e.receipt?.receiptNo}?"),
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
                                      }) ??
                                  false;
                              if (result) {
                                final receipt = e.receipt?.receiptNo;
                                if (receipt != null) {
                                  await context
                                      .read<BetHistoryBloc>()
                                      .cancelReceipt(int.parse(receipt));
                                  await ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                    SnackBar(
                                      content:
                                          Text("Cancelled Bet No. #${receipt}"),
                                    ),
                                  );
                                }
                              }
                            },
                            label: Text("CANCEL BET"),
                            icon: Icon(Icons.bookmark_remove),
                          ),
                        ),
                      if (!e.isCancel)
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            primary: Colors.red,
                            onPrimary: Colors.white,
                          ),
                          icon: Icon(
                            Icons.delete_forever,
                          ),
                          label: Text("DELETE BET"),
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
                                await context
                                    .read<BetHistoryBloc>()
                                    .delete(e.id!);
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
                        ),
                    ],
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

class _BetHistoryChangeDateButton extends StatelessWidget {
  const _BetHistoryChangeDateButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final state = context.read<BetHistoryBloc>().state;
        final startDate = state.date;

        final result = await showDatePicker(
          context: context,
          initialDate: startDate,
          firstDate: DateTime(2022),
          lastDate: DateTime.now(),
        );
        if (result != null) {
          context.read<BetHistoryBloc>().fetch(fromDate: result);
        }
      },
      child: Text("CHANGE DATE"),
    );
  }
}

class _BetHistoryDrawDateText extends StatelessWidget {
  const _BetHistoryDrawDateText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return BetHistoryBuilder(
      builder: (state) {
        return Text("Draw date: ${YEAR_MONTH_DATE.format(state.date)}",
            style: textTheme.subtitle2);
      },
    );
  }
}
