import 'package:bet_app_virgo/cashier/grand_total_draws/grand_total_draws.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../login/bloc/login_bloc.dart';
import '../../../login/widgets/scaffold.dart';
import '../../../utils/nil.dart';
import '../../cashier.dart';
import '../../claim/widgets/scaffold.dart';
import '../cubit/grand_total_cubit.dart';
import 'grand_total_builder.dart';

class GrandTotalProvider extends StatelessWidget {
  const GrandTotalProvider({
    required this.child,
    Key? key,
  }) : super(key: key);
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GrandTotalCubit()..refetch(),
      child: child,
    );
  }
}

class CashierDashboardScaffold extends StatefulWidget {
  static const path = '/cashier/dashboard';
  const CashierDashboardScaffold({Key? key}) : super(key: key);

  @override
  State<CashierDashboardScaffold> createState() =>
      _CashierDashboardScaffoldState();
}

class _CashierDashboardScaffoldState extends State<CashierDashboardScaffold> {
  int _index = 0;
  PageController _controller = PageController();
  void _changeTab(int index) {
    setState(() {
      _index = index;
      _controller.jumpToPage(
        _index,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return GrandTotalProvider(
      child: WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0,
            title: Text("Main Menu"),
            actions: [
              _RefreshGrandTotalIcon(),
            ],
          ),
          body: PageView(
            onPageChanged: _changeTab,
            controller: _controller,
            physics: const BouncingScrollPhysics(),
            children: const [
              _CashierBody(),
              ClaimQRScaffold(),
              _CashierSettingsBody(),
            ],
          ),
          floatingActionButton: _index == 0
              ? FloatingActionButton.extended(
                  onPressed: () {
                    Navigator.pushNamed(context, CashierNewBetScaffold.path);
                  },
                  label: Text("New Bet"),
                  icon: Icon(Icons.add),
                )
              : null,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _index,
            onTap: _changeTab,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.attach_money_rounded),
                label: "Claim",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: "Settings",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RefreshGrandTotalIcon extends StatelessWidget {
  const _RefreshGrandTotalIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          context.read<GrandTotalCubit>().refetch();
        },
        icon: Icon(Icons.refresh));
  }
}

class _CashierBody extends StatelessWidget {
  const _CashierBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return RefreshIndicator(
      onRefresh: () async {
        context.read<GrandTotalCubit>().refetch();
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            margin: const EdgeInsets.all(8.0),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: _CashierSalesDateToggle()),
                Center(
                  child: Text(
                    "Today P 0 - Ground Zero",
                    style: textTheme.headline6?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 24),
                GrandTotalContainer(),
                GrandTotalLoadingIndicator(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CashierSalesDateToggle extends StatefulWidget {
  const _CashierSalesDateToggle({Key? key}) : super(key: key);

  @override
  __CashierSalesDateToggleState createState() =>
      __CashierSalesDateToggleState();
}

class __CashierSalesDateToggleState extends State<_CashierSalesDateToggle> {
  List<bool> tabs = [
    true,
    false,
    false,
    false,
  ];
  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      selectedBorderColor: Colors.yellow[700],
      selectedColor: Colors.yellow[700],
      borderRadius: BorderRadius.circular(4),
      borderWidth: 1,
      onPressed: (index) async {
        switch (index) {

          /// TODAY
          case 0:
            context.read<GrandTotalCubit>().fetch();
            break;

          /// YESTERDAY
          case 1:
            final yesterday = DateTime.now().subtract(const Duration(days: 1));

            context.read<GrandTotalCubit>().fetch(
                  fromDate: yesterday,
                  toDate: yesterday,
                );
            break;

          /// LAST 7 DAYS
          case 2:
            final lastWeek = DateTime.now().subtract(const Duration(days: 7));

            context.read<GrandTotalCubit>().fetch(
                  fromDate: lastWeek,
                  toDate: lastWeek,
                );
            break;
          case 3:
            final result = await showDateRangePicker(
              context: context,
              firstDate: DateTime(2022),
              lastDate: DateTime.now(),
              initialEntryMode: DatePickerEntryMode.calendarOnly,
            );
            if (result != null) {
              context.read<GrandTotalCubit>().fetch(
                    fromDate: result.start,
                    toDate: result.end,
                  );
            } else {
              return;
            }
            break;
          default:
            break;
        }
        tabs = tabs.map((e) => false).toList();
        setState(() {
          tabs[index] = true;
        });
      },
      isSelected: tabs,
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

class _CashierSettingsBody extends StatelessWidget {
  const _CashierSettingsBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ListTile(
            title: Text("History"),
            leading: Icon(Icons.history),
            onTap: () {
              Navigator.pushNamed(context, CashierBetHistoryScaffold.path);
            },
          ),
          ListTile(
            title: Text("Hits"),
            leading: Icon(Icons.flip_to_back_sharp),
            onTap: () {
              Navigator.pushNamed(context, CashierHitScaffold.path);
            },
          ),
          ListTile(
            title: Text("Cancel Doc"),
            leading: Icon(Icons.cancel),
            onTap: () {
              Navigator.pushNamed(context, CashierBetCancelScaffold.path);
            },
          ),
          ListTile(
            title: Text("Setup Printer"),
            leading: Icon(Icons.print),
            onTap: () {
              Navigator.pushNamed(context, CashierPrinterScaffold.path);
            },
          ),
          ListTile(
            title: Text("Logout"),
            leading: Icon(Icons.logout),
            onTap: () {
              context.read<LoginBloc>().add(LogoutEvent());

              Navigator.pushReplacementNamed(context, BetLoginScaffold.path);
            },
          ),
        ],
      ),
    );
  }
}

class GrandTotalContainer extends StatelessWidget {
  const GrandTotalContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: () {
        final state = context.read<GrandTotalCubit>().state;
        if (state is GrandTotalLoaded) {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => BlocProvider(
                create: (context) => GrandTotalDrawsCubit()
                  ..fetch(
                    fromDate: state.fromDate,
                    toDate: state.toDate,
                  ),
                child: GrandTotalDrawsScaffold(),
              ),
            ),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.yellow,
            width: 0.5,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "GRAND TOTAL",
              style: textTheme.subtitle1?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const GrandTotalCard(),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class GrandTotalCard extends StatelessWidget {
  const GrandTotalCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            Text("BET", style: textTheme.button),
            GrandTotalBuilder(builder: (state) {
              return Text(
                "${state.readableBetAmount}",
                style: textTheme.subtitle1,
                overflow: TextOverflow.ellipsis,
              );
            })
          ],
        ),
        Column(
          children: [
            Text("HITS", style: textTheme.button),
            GrandTotalBuilder(
              builder: (state) {
                return Text(
                  "${state.readableHits}",
                  style: textTheme.subtitle1,
                  overflow: TextOverflow.ellipsis,
                );
              },
            )
          ],
        ),
        Column(
          children: [
            Text("TAPAL", style: textTheme.button),
            GrandTotalBuilder(
              builder: (state) {
                final tapal = state.betAmount - state.hits;
                final isPositive = tapal > 0;
                final color = isPositive ? Colors.green[600] : Colors.red[600];
                return Text(
                  "${tapal}",
                  style: textTheme.subtitle1?.copyWith(
                    color: color,
                  ),
                  overflow: TextOverflow.ellipsis,
                );
              },
            )
          ],
        ),
      ],
    );
  }
}

class GrandTotalLoadingIndicator extends StatelessWidget {
  const GrandTotalLoadingIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GrandTotalBuilder(
      builder: (state) => notNil,
      onLoading: Center(child: CircularProgressIndicator.adaptive()),
      onError: (err) => Text(
        "$err",
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
      ),
    );
  }
}
