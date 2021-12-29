import 'package:bet_app_virgo/bluetooth/cubit/bluetooth_cubit.dart';
import 'package:bet_app_virgo/cashier/printer/cubit/blue_thermal_cubit.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart' as printer;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'builder.dart';

const loading = CircularProgressIndicator.adaptive();

class CashierPrinterScaffold extends StatelessWidget {
  static const path = "/cashier/printer";
  const CashierPrinterScaffold({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Printer list"),
        elevation: 0,
      ),
      body: _PrinterBody(),
    );
  }
}

class _PrinterBody extends StatefulWidget {
  const _PrinterBody({Key? key}) : super(key: key);

  @override
  State<_PrinterBody> createState() => _PrinterBodyState();
}

class _PrinterBodyState extends State<_PrinterBody> {
  bool _led = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            child: Text("Start scan"),
            onPressed: () {
              context.read<BlueThermalCubit>().scan();
            },
          ),
        ),
        _TestPrintButton(),

        Flexible(child: BlueThermalBuilder(
          builder: (state) {
            if (!state.isConnected) {
              return Text("Bluetooth disabled");
            }
            if (!state.isEmpty) {
              final data = state.devices;
              return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final device = data[index];
                    final button = !device.connected
                        ? ElevatedButton(
                            onPressed: () {
                              context.read<BlueThermalCubit>().connect(device);
                            },
                            child: Text("CONNECT "),
                          )
                        : ElevatedButton(
                            onPressed: () {
                              context.read<BlueThermalCubit>().disconnect();
                            },
                            child: Text("DISCONNECT"),
                          );

                    return ListTile(
                      title: Text("${device.name}"),
                      subtitle: Text("${device.address}"),
                      trailing: button,
                    );
                  });
            }
            return Text("No Device Found");
          },
        ))
        // Flexible(
        //   child: BluetoothScanResultBuilder(
        //     builder: (devices) {
        //       return ListView.builder(
        //         itemCount: devices.length,
        //         itemBuilder: (context, index) {
        //           final device = devices[index].device;

        //           return StreamBluetoothDeviceState(
        //               device: device,
        //               builder: (state) {
        //                 return ListTile(
        //                   title: Text("${device.name}"),
        //                   subtitle: Text("${device.id}"),
        //                   trailing: _StatusIcon(
        //                     state: state,
        //                     onDisconnect: () async {
        //                       await printer.BlueThermalPrinter.instance
        //                           .disconnect();
        //                       context.read<BluetoothCubit>().disconnectDevice();
        //                     },
        //                     onConnect: () async {
        //                       context.read<BluetoothCubit>().disconnectDevice();
        //                       context.read<BluetoothCubit>().connectDevice(
        //                             BetBluetoothDevice(
        //                               name: device.name,
        //                               address: device.id.id,
        //                             ),
        //                           );
        //                       await printer.BlueThermalPrinter.instance.connect(
        //                         printer.BluetoothDevice(
        //                           device.name,
        //                           device.id.id,
        //                         ),
        //                       );

        //                       await ScaffoldMessenger.of(context).showSnackBar(
        //                           SnackBar(
        //                               content:
        //                                   Text("Connected to ${device.name}")));
        //                     },
        //                   ),
        //                 );
        //               });
        //         },
        //       );
        //     },
        //   ),
        // )
      ],
    );
  }
}

class _TestPrintButton extends StatefulWidget {
  const _TestPrintButton({Key? key}) : super(key: key);

  @override
  State<_TestPrintButton> createState() => _TestPrintButtonState();
}

class _TestPrintButtonState extends State<_TestPrintButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: printResult,
        child: Text("Test Print"),
      ),
    );
  }

  Future<void> printResult() async {
    try {
      final state = context.read<BluetoothCubit>().state;
      final blueConnected =
          await printer.BlueThermalPrinter.instance.isConnected;
      if (state is BluetoothLoaded) {
        await printer.BlueThermalPrinter.instance.printCustom(
            "Receipt Date: ${DateFormat.yMd().add_jm().format(DateTime.now())}",
            1,
            0);
        await printer.BlueThermalPrinter.instance
            .printCustom("-------------------------", 1, 1);

        await printer.BlueThermalPrinter.instance
            .printCustom("PRINT SUCCESSFULLY", 1, 1);
        await printer.BlueThermalPrinter.instance
            .printCustom("-------------------------", 1, 1);
        await printer.BlueThermalPrinter.instance.printNewLine();
        await printer.BlueThermalPrinter.instance
            .printQRcode("TEST QR CODE", 192, 192, 1);
        await printer.BlueThermalPrinter.instance.printNewLine();
        await printer.BlueThermalPrinter.instance
            .printCustom("-------------------------", 1, 1);
        await printer.BlueThermalPrinter.instance.printNewLine();
        await printer.BlueThermalPrinter.instance.paperCut();
      }
    } catch (e) {
      debugPrint("$e");
    }
  }
}
