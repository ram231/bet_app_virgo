import 'package:bet_app_virgo/dashboard/logs_scaffold.dart';
import 'package:bet_app_virgo/dashboard/scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'combinations/scaffold.dart';
import 'win_category/scaffold.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      initialRoute: BetLoginScaffold.path,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case BetLoginScaffold.path:
            return CupertinoPageRoute(builder: (context) => BetLoginScaffold());
          case BetDashboardScaffold.path:
            return CupertinoPageRoute(
                builder: (context) => BetDashboardScaffold());
          case BetLogsScaffold.path:
            return CupertinoPageRoute(builder: (context) => BetLogsScaffold());
          case BetCombinationScaffold.path:
            return CupertinoPageRoute(
                builder: (context) => BetCombinationScaffold());
          case BetCategoryScaffold.path:
            return CupertinoPageRoute(
                builder: (context) => BetCategoryScaffold());
          default:
            return CupertinoPageRoute(builder: (context) => BetLoginScaffold());
        }
      },
    );
  }
}

class BetLoginScaffold extends StatelessWidget {
  static const path = "/";
  const BetLoginScaffold({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: BetLoginBody());
  }
}

class BetLoginBody extends StatefulWidget {
  const BetLoginBody({
    Key? key,
  }) : super(key: key);

  @override
  State<BetLoginBody> createState() => _BetLoginBodyState();
}

class _BetLoginBodyState extends State<BetLoginBody> {
  bool _obscure = true;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Spacer(),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "User",
              ),
            ),
          ),
        ),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Passkey",
                suffix: GestureDetector(
                  onTap: () {
                    setState(() {
                      _obscure = !_obscure;
                    });
                  },
                  child: Icon(
                    _obscure ? Icons.visibility_off : Icons.visibility,
                  ),
                ),
              ),
              obscureText: _obscure,
            ),
          ),
        ),
        Spacer(),
        SizedBox(
          width: MediaQuery.of(context).size.width - 100,
          height: 32,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.yellow[700],
            ),
            onPressed: () {
              Navigator.of(context).pushNamed(BetDashboardScaffold.path);
            },
            child: Text(
              "LOGIN",
              style: Theme.of(context).textTheme.button?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ),
      ],
    );
  }
}
