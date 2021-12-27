import 'package:bet_app_virgo/bluetooth/cubit/bluetooth_cubit.dart';
import 'package:bet_app_virgo/models/bluetooth_device.dart';
import 'package:bet_app_virgo/utils/nil.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart' as printer;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:intl/intl.dart';

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
        Container(
          padding: const EdgeInsets.all(8),
          width: double.infinity,
          child: const StreamBluetoothState(),
        ),
        _TestPrintButton(),
        BluetoothScanBuilder(builder: (scanning) {
          if (scanning) {
            return Container(
              padding: const EdgeInsets.all(8),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await FlutterBlue.instance.stopScan();
                  await printer.BlueThermalPrinter.instance.disconnect();
                },
                child: Text("STOP"),
              ),
            );
          }
          return Container(
            padding: const EdgeInsets.all(8),
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                FlutterBlue.instance
                    .startScan(timeout: const Duration(seconds: 4));
              },
              child: Text("DISCOVER NEW DEVICES"),
            ),
          );
        }),
        Flexible(
          child: BluetoothScanResultBuilder(
            builder: (devices) {
              return ListView.builder(
                itemCount: devices.length,
                itemBuilder: (context, index) {
                  final device = devices[index].device;

                  return StreamBluetoothDeviceState(
                      device: device,
                      builder: (state) {
                        return ListTile(
                          title: Text("${device.name}"),
                          subtitle: Text("${device.id}"),
                          trailing: _StatusIcon(
                            state: state,
                            onDisconnect: () async {
                              await printer.BlueThermalPrinter.instance
                                  .disconnect();
                              context.read<BluetoothCubit>().disconnectDevice();
                            },
                            onConnect: () async {
                              context.read<BluetoothCubit>().disconnectDevice();
                              context.read<BluetoothCubit>().connectDevice(
                                    BetBluetoothDevice(
                                      name: device.name,
                                      address: device.id.id,
                                    ),
                                  );
                              await printer.BlueThermalPrinter.instance.connect(
                                printer.BluetoothDevice(
                                  device.name,
                                  device.id.id,
                                ),
                              );

                              await ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text("Connected to ${device.name}")));
                            },
                          ),
                        );
                      });
                },
              );
            },
          ),
        )
      ],
    );
  }
}

class StreamBluetoothState extends StatelessWidget {
  const StreamBluetoothState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BluetoothState>(
      stream: FlutterBlue.instance.state,
      initialData: BluetoothState.off,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return loading;
        }
        if (snapshot.hasData) {
          final status = snapshot.data;
          switch (status) {
            case BluetoothState.on:
              return ElevatedButton(
                onPressed: () async {
                  await FlutterBlue.instance.stopScan();
                  final result = await FlutterBlue.instance.turnOff();
                  await printer.BlueThermalPrinter.instance.disconnect();
                  debugPrint("Turning off: $result");
                },
                child: Text("TURN OFF BLUETOOTH"),
              );
            case BluetoothState.turningOn:
            case BluetoothState.turningOff:
              return Center(child: loading);
            case BluetoothState.unauthorized:
            case BluetoothState.unavailable:
              return Text("Bluetooth not available on this device");
            default:
              return ElevatedButton(
                onPressed: () async {
                  await FlutterBlue.instance.turnOn();
                },
                child: Text("TURN ON BLUETOOTH"),
              );
          }
        }
        return notNil;
      },
    );
  }
}

class BluetoothScanResultBuilder extends StatelessWidget {
  const BluetoothScanResultBuilder({
    this.onLoading,
    required this.builder,
    Key? key,
  }) : super(key: key);
  final Widget? onLoading;
  final Widget Function(List<ScanResult> devices) builder;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ScanResult>>(
      stream: FlutterBlue.instance.scanResults,
      initialData: [],
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: onLoading ?? loading);
        }
        if (snapshot.hasData) {
          final data = snapshot.data ?? [];
          if (data.isEmpty) {
            return Text("No devices found");
          }
          return builder(data.where((e) => e.device.name.isNotEmpty).toList());
        }
        return notNil;
      },
    );
  }
}

class BluetoothScanBuilder extends StatelessWidget {
  const BluetoothScanBuilder({
    required this.builder,
    this.onLoading,
    Key? key,
  }) : super(key: key);
  final Widget Function(bool state) builder;
  final Widget? onLoading;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: FlutterBlue.instance.isScanning,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return onLoading ?? loading;
        }
        if (snapshot.hasData) {
          final data = snapshot.data ?? false;
          return builder(data);
        }

        return notNil;
      },
    );
  }
}

class StreamBluetoothDeviceState extends StatelessWidget {
  const StreamBluetoothDeviceState({
    required this.device,
    required this.builder,
    this.onLoading,
    Key? key,
  }) : super(key: key);
  final BluetoothDevice device;
  final Widget Function(BluetoothDeviceState state) builder;
  final Widget? onLoading;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BluetoothDeviceState>(
        stream: device.state,
        initialData: BluetoothDeviceState.connecting,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: onLoading ?? loading);
          }
          if (snapshot.hasData) {
            final data = snapshot.data;
            return builder(data!);
          }
          return notNil;
        });
  }
}

class _StatusIcon extends StatelessWidget {
  const _StatusIcon({
    required this.state,
    this.onConnect,
    this.onDisconnect,
    Key? key,
  }) : super(key: key);
  final VoidCallback? onConnect;
  final VoidCallback? onDisconnect;
  final BluetoothDeviceState state;
  @override
  Widget build(BuildContext context) {
    switch (state) {
      case BluetoothDeviceState.connected:
        return ElevatedButton(
            onPressed: onDisconnect,
            child: Text("Disconnect"),
            style: ElevatedButton.styleFrom(
                primary: Colors.red,
                textStyle: TextStyle(
                  color: Colors.white,
                )));
      case BluetoothDeviceState.connecting:
      case BluetoothDeviceState.disconnecting:
        return Icon(Icons.pending, color: Colors.yellow);
      default:
        return ElevatedButton(
          onPressed: onConnect,
          child: Text("Connect"),
        );
    }
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
