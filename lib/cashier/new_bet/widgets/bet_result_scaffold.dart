import 'package:bet_app_virgo/login/bloc/login_bloc.dart';
import 'package:bet_app_virgo/models/models.dart';
import 'package:bet_app_virgo/utils/http_client.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../utils/nil.dart';
import '../../cashier.dart';
import '../cubit/create_new_bet_cubit.dart';
import 'scaffold.dart';

class BetResultScaffold extends StatelessWidget {
  const BetResultScaffold({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("BET CREATED"),
        elevation: 0,
      ),
      body: _BetResultBody(),
    );
  }
}

class _BetResultBody extends StatelessWidget {
  const _BetResultBody({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(child: Container(child: Text(""))),
        Flexible(child: BetResultTable()),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                    CupertinoPageRoute(builder: (context) {
                  return CashierNewBetScaffold();
                }));
              },
              child: Text("NEW BET"),
              style: ElevatedButton.styleFrom(
                elevation: 0,
              ),
            ),
            _PrintResult(),
          ],
        )
      ],
    );
  }
}

class BetResultTable extends StatelessWidget {
  const BetResultTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final betResult = context.watch<CreateNewBetCubit>().state;
    if (betResult is CreateNewBetError) {
      return Text("${betResult.error}");
    }
    if (betResult is CreateNewBetLoading) {
      return Center(child: CircularProgressIndicator.adaptive());
    } else if (betResult is CreateNewBetLoaded) {
      final result = betResult.result;
      return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            rows: result
                .map((e) => DataRow(cells: [
                      DataCell(Text("${e.betNumber}")),
                      DataCell(Text("${e.readableBetAmount}")),
                      DataCell(Text("${e.prize}")),
                      DataCell(Text("${e.draw?.id}")),
                    ]))
                .toList(),
            columns: [
              DataColumn(label: Text("Bet Comb")),
              DataColumn(label: Text("Bet Amt")),
              DataColumn(label: Text("Prize")),
              DataColumn(label: Text("Draw")),
            ],
          ),
        ),
      );
    }
    return nil;
  }
}

class _PrintResult extends StatefulWidget {
  const _PrintResult({Key? key}) : super(key: key);

  @override
  __PrintResultState createState() => __PrintResultState();
}

class __PrintResultState extends State<_PrintResult> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: printResult,
      child: Icon(Icons.print),
    );
  }

  Future<void> printResult() async {
    try {
      final isConnected =
          (await BlueThermalPrinter.instance.isConnected) ?? false;
      if (!isConnected) {
        await showDialog(
          context: context,
          builder: (context) => PrinterNotFoundDialog(),
        );
        return;
      }
      final isOn = (await BlueThermalPrinter.instance.isOn) ?? false;
      if (!isOn) {
        await showDialog(
          context: context,
          builder: (context) => PrinterNotFoundDialog(),
        );
        return;
      }
      final betResult = context.read<CreateNewBetCubit>().state;
      if (betResult is CreateNewBetLoaded) {
        final userState = context.read<LoginBloc>().state;
        if (userState is LoginSuccess) {
          final receipt = await context
              .read<STLHttpClient>()
              .post('$adminEndpoint/receipts',
                  body: {
                    "cashier_id": userState.user.id,
                    "bet_ids": betResult.result.map((e) => e.id).toList(),
                  },
                  onSerialize: (json) => BetReceipt.fromMap(json));

          /// DATE FORMAT:  MM/DD/yyyy H:MM A
          final datePrinted = DateFormat.yMd().add_jm().format(DateTime.now());
          await BlueThermalPrinter.instance.printCustom(
            "Receipt Date: $datePrinted",
            1,
            0,
          );
          await BlueThermalPrinter.instance.printCustom(
            "--------------------------------",
            1,
            0,
          );
          await BlueThermalPrinter.instance.print4Column(
            "Bet",
            "Amount",
            "Prize",
            "Draw",
            1,
          );
          await Future.wait(betResult.result.map((e) {
            return BlueThermalPrinter.instance.print4Column(
              '${e.betNumber}',
              "${e.betAmount?.toInt()}",
              "${e.prize}",
              "${e.draw?.id ?? 'N/A'}",
              0,
            );
          }));
          await BlueThermalPrinter.instance.printCustom(
            "--------------------------------",
            1,
            0,
          );
          final total = betResult.result.fold<double>(
            0,
            (previousValue, element) =>
                previousValue + (element.betAmount ?? 0),
          );
          await BlueThermalPrinter.instance.printNewLine();
          await BlueThermalPrinter.instance.printCustom(
            "Total:$total",
            1,
            1,
          );

          await BlueThermalPrinter.instance.printCustom(
            "Receipt: ${receipt.receiptNo ?? 'N/A'}",
            1,
            1,
          );

          await BlueThermalPrinter.instance.printCustom(
            "STRICTLY!!! No ticket no claim. ",
            1,
            1,
          );
          await BlueThermalPrinter.instance.printCustom(
            "${betResult.result.first.branch?.name ?? 'Unknown'}",
            1,
            1,
          );
          await await BlueThermalPrinter.instance.printQRcode(
            "${receipt.receiptNo}",
            200,
            200,
            1,
          );
          await BlueThermalPrinter.instance.printNewLine();
          await BlueThermalPrinter.instance.printNewLine();
          await BlueThermalPrinter.instance.printNewLine();
          await BlueThermalPrinter.instance.printNewLine();
        }
      }
    } catch (e) {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Error!"),
          content: Text("$e"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("CLOSE"),
            )
          ],
        ),
      );
    }
  }
}

class PrinterNotFoundDialog extends StatelessWidget {
  const PrinterNotFoundDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Printer not found"),
      content: Text("Printer not connected, Try connecting it."),
      actions: [
        ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, CashierPrinterScaffold.path);
            },
            child: Text("CONNECT"))
      ],
    );
  }
}
