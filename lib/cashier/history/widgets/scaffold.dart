import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../login/bloc/login_bloc.dart';
import '../../../login/widgets/builder.dart';
import '../../../models/models.dart';
import '../../../utils/date_format.dart';
import '../../../utils/nil.dart';
import '../bloc/bet_history_bloc.dart';
import 'bet_items.dart';
import 'builder.dart';

class BetHistoryProvider extends StatelessWidget {
  const BetHistoryProvider({required this.child, Key? key}) : super(key: key);
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return LoginSuccessBuilder(builder: (user) {
      return BlocProvider(
        create: (context) => BetHistoryBloc(user: user)..fetch(),
        child: child,
      );
    });
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
  void onPress(BuildContext context, BetReceipt receipt) async {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (c) => BetHistoryItemProvider(
          child: BetHistoryItemScaffold(),
          receipt: receipt,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final historyState = context.watch<BetHistoryBloc>().state;
    if (historyState.isLoading) {
      return Center(child: CircularProgressIndicator.adaptive());
    }
    if (historyState.hasError) {
      return Center(
          child: Text("${historyState.error}",
              style: TextStyle(
                fontSize: 16,
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis));
    }
    final receipts = historyState.bets;
    if (receipts.isNotEmpty) {
      return DataTable(
        showBottomBorder: true,
        showCheckboxColumn: true,
        rows: receipts.map((receipt) {
          return DataRow(
            color: receipt.status == 'I'
                ? MaterialStateProperty.all(Colors.red[200])
                : null,
            cells: <Widget>[
              Text("${receipt.receiptNo}"),
              Text("${receipt.createdAt}"),
              _CancelReceiptButton(receipt: receipt),
            ]
                .map(
                  (data) => DataCell(
                    data,
                    onTap: () => onPress(context, receipt),
                  ),
                )
                .toList(),
          );
        }).toList(),
        columns: [
          DataColumn(label: Text("Receipt No.")),
          DataColumn(label: Text("Bet Date")),
          DataColumn(label: Text("Actions")),
        ],
      );
    }
    return notNil;
  }
}

class _CancelReceiptButton extends StatelessWidget {
  const _CancelReceiptButton({
    Key? key,
    required this.receipt,
  }) : super(key: key);
  final BetReceipt receipt;
  @override
  Widget build(BuildContext context) {
    final userState = context.watch<LoginBloc>().state;
    final cashierId = userState is LoginSuccess ? userState.user.id : null;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (receipt.status != 'I')
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
                            title:
                                Text("Cancel Receipt #${receipt.receiptNo}?"),
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
                  final id = receipt.id;
                  if (id != null) {
                    await context.read<BetHistoryBloc>().cancelReceipt(
                          receiptNo: receipt.receiptNo!,
                          cashierId: cashierId!,
                        );
                    await ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text("Cancelled Bet No. #${receipt.receiptNo}"),
                      ),
                    );
                  }
                }
              },
              label: Text("CANCEL BET"),
              icon: Icon(Icons.bookmark_remove),
            ),
          ),
      ],
    );
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
        return Text("Draw date: ${YEAR_MONTH_DAY.format(state.date)}",
            style: textTheme.subtitle2);
      },
    );
  }
}
