import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

import '../../../../models/draw.dart';
import '../data/draw_data.dart';

class CreateDrawProvider extends StatelessWidget {
  const CreateDrawProvider({required this.child, required this.draw, Key? key})
      : super(key: key);
  final Widget child;
  final DrawBet draw;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (c) => DrawData(data: draw),
      child: child,
    );
  }
}

class CreateDrawScaffold extends StatelessWidget {
  const CreateDrawScaffold({Key? key}) : super(key: key);
  static const path = '/draw/create';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Draw"),
        elevation: 0,
      ),
      body: _CreateDrawBody(),
    );
  }
}

class _CreateDrawBody extends StatefulWidget {
  const _CreateDrawBody({Key? key}) : super(key: key);

  @override
  State<_CreateDrawBody> createState() => _CreateDrawBodyState();
}

class _CreateDrawBodyState extends State<_CreateDrawBody> {
  DrawTypeBet? _drawTypeBet;
  @override
  Widget build(BuildContext context) {
    return Form(
      child: SingleChildScrollView(
        child: Column(
          children: [
            /// Draw Type new Route
            SizedBox(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: "Draw Type",
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                      onPressed: () {}, icon: Icon(Icons.arrow_drop_down)),
                ),
                readOnly: true,
              ),
            )),

            /// Winning Amount
            SizedBox(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: "Winning Amount",
                  border: OutlineInputBorder(),
                ),
              ),
            )),
            if (_drawTypeBet != null)
              SizedBox(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: "Winning Numbers",
                      border: OutlineInputBorder(),
                      hintText:
                          "${List.generate(_drawTypeBet?.digits.toInt() ?? 0, (index) => 0).join("")}",
                    ),
                    inputFormatters: [
                      // FilteringTextInputFormatter.allow(RegExp(r"^[\d,\s]+$")),
                      MaskedInputFormatter(
                        '${List.generate(_drawTypeBet?.digits.toInt() ?? 0, (index) => 0).join("")},',
                        allowedCharMatcher: RegExp(r"^[\d,\s]+$"),
                      )
                    ],
                    keyboardType: TextInputType.numberWithOptions(),
                  ),
                ),
              ),

            /// Winning Amount
            SizedBox(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: "Draw Date",
                  border: OutlineInputBorder(),
                ),
              ),
            )),

            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  child: Text("SUBMIT"),
                  onPressed: _drawTypeBet != null ? () {} : null,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
