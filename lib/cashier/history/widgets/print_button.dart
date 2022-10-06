import 'dart:io';

import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import '../../../models/models.dart';
import '../../../utils/nil.dart';
import '../../printer/widgets/builder.dart';
import '../../printer/widgets/scaffold.dart';
import '../bloc/bet_history_bloc.dart';

class BetHistoryPrintButton extends StatelessWidget {
  const BetHistoryPrintButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final historyState = context.watch<BetHistoryBloc>().state;

    if (historyState.isLoading) {
      return notNil;
    }
    if (historyState.hasError) {
      return notNil;
    }
    final bets = historyState.bets;
    final isEmpty = bets.isEmpty;
    final isPrinting = historyState.isPrinting;
    return BlueThermalBuilder(
      builder: (state) {
        if (state.isConnected) {
          return IconButton(
            icon: Icon(Icons.print),
            onPressed: isEmpty || isPrinting
                ? null
                : () => printReceipts(bets, context),
          );
        }
        return TextButton.icon(
          style: TextButton.styleFrom(
            foregroundColor: Colors.black,
          ),
          onPressed: () {
            Navigator.pushNamed(context, CashierPrinterScaffold.path);
          },
          icon: Icon(Icons.print),
          label: Text("Connect Printer"),
        );
      },
    );
  }

  void printReceipts(
    List<BetReceipt> receipts,
    BuildContext context,
  ) async {
    try {
      context.read<BetHistoryBloc>().printAll(true);
      final bytes = await rootBundle.load("images/print_logo.jpg");
      final dir = (await getApplicationDocumentsDirectory()).path;
      final buffer = bytes.buffer;
      final file = await File("$dir/print_logo.png").writeAsBytes(
          buffer.asUint8List(bytes.offsetInBytes, buffer.lengthInBytes));
      await BlueThermalPrinter.instance.printImage(
        file.path,
      );

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
      for (final receipt in receipts) {
        final bets = receipt.bets;
        await Future.wait(bets.map((e) {
          return BlueThermalPrinter.instance.print4Column(
            '${e.betNumber}',
            "${e.betAmount}",
            "${e.prize}",
            "${e.drawId}",
            0,
          );
        }));
      }

      await BlueThermalPrinter.instance.printCustom(
        "--------------------------------",
        1,
        0,
      );

      await BlueThermalPrinter.instance.printCustom(
        "STRICTLY!!! No ticket no claim. ",
        1,
        1,
      );
      await BlueThermalPrinter.instance.printNewLine();
      await BlueThermalPrinter.instance.printNewLine();
      await BlueThermalPrinter.instance.printNewLine();
      context.read<BetHistoryBloc>().printAll(false);
    } catch (e) {
      context.read<BetHistoryBloc>().onErr(e);
    }
  }
}
