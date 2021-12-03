import 'package:flutter/material.dart';

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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Checkbox(
                value: _led,
                onChanged: (val) {
                  setState(() {
                    if (val != null) {
                      _led = val;
                    }
                  });
                }),
            Text("Toggle LED"),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(8),
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {},
            child: Text("BLUETOOTH ON"),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {},
            child: Text("BLUETOOTH OFF"),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {},
            child: Text("SHOW PAIRED DEVICES"),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {},
            child: Text("DISCOVER NEW DEVICES"),
          ),
        ),
      ],
    );
  }
}
