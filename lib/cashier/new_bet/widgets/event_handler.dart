import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/src/provider.dart';

import '../../../models/models.dart';
import '../../../utils/utils.dart';
import '../../printer/widgets/scaffold.dart';

mixin PrinterMixin<T extends StatefulWidget> on State<T> {
  Future<void> printResult(
    int cashierId,
    List<BetResult> result,
  ) async {
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

      final receipt =
          await context.read<STLHttpClient>().post('$adminEndpoint/receipts',
              body: {
                "cashier_id": cashierId,
                "bet_ids": result.map((e) => e.id).toList(),
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
      await Future.wait(result.map((e) {
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
      final total = result.fold<double>(
        0,
        (previousValue, element) => previousValue + (element.betAmount ?? 0),
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
        "${result.first.branch?.name ?? 'Unknown'}",
        1,
        1,
      );
      final data = "${receipt.receiptNo}_${receipt.id}";
      await await BlueThermalPrinter.instance.printQRcode(
        "$data",
        200,
        200,
        1,
      );
      await BlueThermalPrinter.instance.printNewLine();
      await BlueThermalPrinter.instance.printNewLine();
      await BlueThermalPrinter.instance.printNewLine();
      await BlueThermalPrinter.instance.printNewLine();
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
