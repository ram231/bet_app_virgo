import 'package:bet_app_virgo/models/models.dart';
import 'package:bet_app_virgo/utils/http_client.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utils/loading_dialog.dart';

class PrintReceiptButton extends StatefulWidget {
  const PrintReceiptButton({
    required this.bets,
    required this.cashier,
    Key? key,
  }) : super(key: key);
  final UserAccount cashier;
  final List<BetResult> bets;

  @override
  State<PrintReceiptButton> createState() => _PrintReceiptButtonState();
}

class _PrintReceiptButtonState extends State<PrintReceiptButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPrintReceipt,
      icon: Icon(Icons.print),
      label: Text("Print"),
    );
  }

  Future<void> onPrintReceipt() async {
    if (widget.bets.isEmpty) {
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Empty Bet"),
            content: Text("No bet to be printed"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("CLOSE"),
              )
            ],
          );
        },
      );
      return;
    }

    try {
      final isConnected =
          (await BlueThermalPrinter.instance.isConnected) ?? false;
      if (!isConnected) {
        await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Printer not connected"),
              content: Text("Printer not found, unable to print receipt"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("CLOSE"),
                )
              ],
            );
          },
        );
        return;
      }
      final fetchReceipt = context.read<STLHttpClient>().get(
        '$adminEndpoint/receipt',
        onSerialize: (json) {
          return BetReceipt.fromMap(json);
        },
      );
      final result = await showDialog(
        context: context,
        builder: (context) {
          return LoadingDialog(
            onLoading: () async {
              final data = await fetchReceipt;
              //TODO: print result

              Navigator.pop(context, true);
            },
          );
        },
      );
      if (result) {}
    } catch (e) {
      //TODO: create dialog that fails to print or fetch
    }
  }

  Future<bool> printBetReceipt(BetReceipt receipt) async {
    try {
      return true;
    } catch (e) {
      throw e;
    }
  }
}
