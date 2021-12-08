import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../login/bloc/login_bloc.dart';
import '../../login/widgets/scaffold.dart';
import '../combinations/scaffold.dart';
import '../draws/widgets/scaffold.dart';
import '../generate_hits/scaffold.dart';
import '../sold_out/scaffold.dart';
import '../win_category/scaffold.dart';
import 'logs_scaffold.dart';

class BetDashboardScaffold extends StatelessWidget {
  static const String path = "/dashboard";
  const BetDashboardScaffold({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return _BetDashboardWillPopScope(
      child: Scaffold(
        drawer: Drawer(
          child: ListView(
            children: [
              UserAccountsDrawerHeader(
                accountName: Text("BET APPLICATION"),
                accountEmail: Text("DASHBOARD v1.06"),
              ),
              ListTile(
                title: Text("Top 10 Combinations"),
                onTap: () =>
                    Navigator.pushNamed(context, BetCombinationScaffold.path),
              ),
              ListTile(
                title: Text("Low Win Summary"),
                onTap: () =>
                    Navigator.pushNamed(context, BetCategoryScaffold.path),
              ),
              ListTile(
                title: Text("General Hits"),
                onTap: () =>
                    Navigator.pushNamed(context, BetGenerateHitScaffold.path),
              ),
              ListTile(
                title: Text("Sold Out / Low Win"),
                onTap: () =>
                    Navigator.pushNamed(context, BetSoldOutScaffold.path),
              ),
              ListTile(
                  title: Text("Draws"),
                  onTap: () =>
                      Navigator.pushNamed(context, AdminDrawScaffold.path)),
              ListTile(
                title: Text("Bet Cancellation"),
              ),
              ListTile(
                title: Text("LOGOUT"),
                onTap: () {
                  context.read<LoginBloc>().add(LogoutEvent());
                  Navigator.pushReplacementNamed(
                      context, BetLoginScaffold.path);
                },
              ),
            ],
          ),
        ),
        appBar: AppBar(
            elevation: 0,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("THIS MONTH"),
                Text("P 25,000", style: textTheme.caption),
              ],
            )),
        body: BetDashboardBody(),
      ),
    );
  }
}

class _BetDashboardWillPopScope extends StatelessWidget {
  const _BetDashboardWillPopScope({
    Key? key,
    required this.child,
  }) : super(key: key);
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return AlertDialog(
                title: Text("Logout"),
                content: Text("Do you want to logout?"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("CANCEL"),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        context.read<LoginBloc>().add(LogoutEvent());
                      },
                      child: Text("LOGOUT")),
                ],
              );
            });
        return false;
      },
      child: child,
    );
  }
}

class BetDashboardBody extends StatelessWidget {
  const BetDashboardBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _BetDateToggleButtons(),
          ),
          _BetCardLogs(
            backgroundColor: Colors.yellow,
            title: "THIS MONTH",
            onTap: () {
              Navigator.of(context).pushNamed(BetLogsScaffold.path);
            },
            betLogs: [
              _BetSection(
                name: "BET",
                price: "341,412",
              ),
              _BetSection(
                name: "HITS",
                price: "74,00",
              ),
              _BetSection(
                name: "KABIG/TAPAL",
                price: "252,760",
              ),
            ],
          ),
          _BetCardLogs(
            title: "TODAY'S TOTAL",
            betLogs: [
              _BetSection(name: "BET", price: "24,570"),
              _BetSection(name: "HITS", price: "5,500"),
              _BetSection(name: "HITS", price: "19,070"),
            ],
            backgroundColor: Color(0xFF13BB95),
          ),
          _BetCardLogs(
            title: "11S3",
            betLogs: [
              _BetSection(name: "BET", price: "24,570"),
              _BetSection(name: "HITS", price: "5,500"),
              _BetSection(name: "HITS", price: "19,070"),
            ],
            backgroundColor: Colors.white,
          ),
          _BetCardLogs(
            title: "4S3",
            betLogs: [
              _BetSection(name: "BET", price: "24,570"),
              _BetSection(name: "HITS", price: "5,500"),
              _BetSection(name: "HITS", price: "19,070"),
            ],
            backgroundColor: Colors.white,
          ),
        ],
      ),
    );
  }
}

class _BetCardLogs extends StatelessWidget {
  const _BetCardLogs({
    Key? key,
    required this.title,
    required this.betLogs,
    this.onTap,
    this.backgroundColor = Colors.white,
  }) : super(key: key);
  final String title;
  final List<_BetSection> betLogs;
  final Color backgroundColor;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 120,
        width: double.infinity,
        child: Card(
          color: backgroundColor,
          elevation: 0.5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  title,
                  style: textTheme.headline5?.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: betLogs,
              ),
              // Wrap(
              //   crossAxisAlignment: WrapCrossAlignment.center,
              //   runAlignment: WrapAlignment.spaceBetween,
              //   alignment: WrapAlignment.spaceBetween,
              //   children: betLogs,
              // )
            ],
          ),
        ),
      ),
    );
  }
}

class _BetSection extends StatelessWidget {
  const _BetSection({
    required this.name,
    required this.price,
    Key? key,
  }) : super(key: key);
  final String name;
  final String price;
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            name,
            style: textTheme.caption,
          ),
          Text(
            price,
            style: textTheme.headline6?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _BetDateToggleButtons extends StatefulWidget {
  const _BetDateToggleButtons({Key? key}) : super(key: key);

  @override
  __BetDateToggleButtonsState createState() => __BetDateToggleButtonsState();
}

class __BetDateToggleButtonsState extends State<_BetDateToggleButtons> {
  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      selectedBorderColor: Colors.yellow[700],
      selectedColor: Colors.yellow[700],
      borderRadius: BorderRadius.circular(4),
      borderWidth: 1,
      onPressed: (index) {},
      isSelected: [
        true,
        false,
        false,
        false,
      ],
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text("Today"),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text("Yesterday"),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text("Last 7 days"),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Icon(
            Icons.date_range_outlined,
          ),
        )
      ],
    );
  }
}
