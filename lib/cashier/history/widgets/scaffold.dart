import 'package:bet_app_virgo/cashier/history/widgets/print_button.dart';
import 'package:bet_app_virgo/cashier/printer/widgets/builder.dart';
import 'package:bet_app_virgo/utils/nil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../login/bloc/login_bloc.dart';
import '../../../login/widgets/builder.dart';
import '../../../models/models.dart';
import '../../../utils/date_format.dart';
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
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("History"),
          elevation: 0,
          actions: const [
            BetHistoryPrintButton(),
          ],
        ),
        body: Column(
          children: [
            Flexible(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: const [
                    _BetHistoryDrawDateText(),
                    Spacer(),
                    _BetHistoryChangeDateButton(),
                  ],
                ),
              ),
            ),
            Flexible(child: _SearchReceiptTextField()),
            _ErrorMessage(),
            Expanded(
              flex: 8,
              child: _BetHistoryBody(),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorMessage extends StatelessWidget {
  const _ErrorMessage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final historyState = context.watch<BetHistoryBloc>().state;
    if (historyState.hasError) {
      return Center(
        child: Text(
          "${historyState.error}",
          style: TextStyle(
            fontSize: 16,
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      );
    }
    return notNil;
  }
}

class _SearchReceiptTextField extends StatefulWidget {
  const _SearchReceiptTextField({Key? key}) : super(key: key);

  @override
  State<_SearchReceiptTextField> createState() =>
      _SearchReceiptTextFieldState();
}

class _SearchReceiptTextFieldState extends State<_SearchReceiptTextField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: "Search Receipt",
          suffixIcon: IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              context.read<BetHistoryBloc>().searchReceipt("");
              _controller.clear();
            },
          ),
        ),
        onChanged: (val) {
          if (val.isEmpty) {
            context.read<BetHistoryBloc>().searchReceipt(val);
          }
        },
        onSubmitted: (val) {
          context.read<BetHistoryBloc>().searchReceipt(val);
        },
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
    final receipts = historyState.searchResult.isNotEmpty
        ? historyState.searchResult
        : historyState.bets;
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
            IgnorePointer(
              ignoring: historyState.isPrinting,
              child: AnimatedOpacity(
                opacity: historyState.isPrinting ? 0.6 : 1.0,
                duration: Duration.zero,
                child: _CancelReceiptButton(receipt: receipt),
              ),
            ),
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
                foregroundColor: Colors.white,
                elevation: 0,
                backgroundColor: Colors.red,
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
        if (receipt.bets.isNotEmpty) _ReprintReceipt(receipt: receipt),
      ],
    );
  }
}

class _ReprintReceipt extends StatelessWidget {
  const _ReprintReceipt({
    Key? key,
    required this.receipt,
  }) : super(key: key);

  final BetReceipt receipt;

  @override
  Widget build(BuildContext context) {
    return BlueThermalBuilder(
      builder: (state) {
        if (state.isConnected) {
          return ElevatedButton.icon(
            onPressed: () {
              context.read<BetHistoryBloc>().rePrintReceipt(receipt);
            },
            icon: Icon(Icons.print),
            label: Text("Print"),
          );
        }
        return notNil;
      },
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
