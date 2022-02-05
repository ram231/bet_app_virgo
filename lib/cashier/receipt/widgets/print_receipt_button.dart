import 'package:bet_app_virgo/models/models.dart';
import 'package:bet_app_virgo/utils/http_client.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utils/loading_dialog.dart';

class PrintReceiptButton extends StatefulWidget {
  const PrintReceiptButton({
    required this.receipt,
    required this.cashier,
    Key? key,
  }) : super(key: key);
  final UserAccount cashier;
  final BetReceipt receipt;

  @override
  State<PrintReceiptButton> createState() => _PrintReceiptButtonState();
}

class _PrintReceiptButtonState extends State<PrintReceiptButton> {
  bool _isPrinting = false;

  void changePrintState() {
    setState(() {
      _isPrinting = !_isPrinting;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: _isPrinting ? null : onPrintReceipt,
      icon: Icon(Icons.print),
      label: Text("Print"),
    );
  }

  Future<void> onPrintReceipt() async {
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
      changePrintState();
      final fetchReceipt = context.read<STLHttpClient>().get(
        '$adminEndpoint/receipts/${widget.receipt.id}',
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
    } finally {
      changePrintState();
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
