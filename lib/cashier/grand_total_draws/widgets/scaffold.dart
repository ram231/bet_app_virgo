import 'package:bet_app_virgo/models/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/grand_total_item_cubit.dart';
import '../data/draw_type_data.dart';
import '../grand_total_draws.dart';
import 'grand_total_item.dart';

class GrandTotalDrawsScaffold extends StatelessWidget {
  const GrandTotalDrawsScaffold({Key? key}) : super(key: key);
  static const path = '/grand-total-draws';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("All Bets"),
      ),
      body: GrandTotalDrawBody(),
    );
  }
}

class GrandTotalDrawBody extends StatefulWidget {
  const GrandTotalDrawBody({Key? key}) : super(key: key);

  @override
  State<GrandTotalDrawBody> createState() => _GrandTotalDrawBodyState();
}

class _GrandTotalDrawBodyState extends State<GrandTotalDrawBody> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = context
        .select<GrandTotalDrawsCubit, UserAccount>((cubit) => cubit.user);
    return GrandTotalDrawBuilder(
      onLoading: Center(child: CircularProgressIndicator.adaptive()),
      onError: (err) => Text("${err}"),
      builder: (state) {
        return ListView.builder(
          itemCount: state.length,
          itemBuilder: (context, index) {
            final item = state[index];
            final textTheme = Theme.of(context).textTheme;
            return BlocProvider(
              create: (context) => DrawTypeData(item),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => BlocProvider(
                        create: (context) => GrandTotalItemCubit(
                          user: user,
                        )..fetchByDrawId(item.draw!.id),
                        child: GrandTotalDrawItemScaffold(),
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.yellow,
                      width: 0.5,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "${item.draw?.drawType?.name}",
                        style: textTheme.headline6?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      _GrandTotalCard(),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _GrandTotalCard extends StatelessWidget {
  const _GrandTotalCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<DrawTypeData>().state;
    final textTheme = Theme.of(context).textTheme;
    final tapal = state.tapalKabig ?? 0;
    final isPositive = tapal > 0;
    final color = isPositive ? Colors.green[600] : Colors.red[600];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            Text("BET", style: textTheme.button),
            Text(
              "${state.readableTotalBetAmount}",
              style: textTheme.subtitle1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        Column(
          children: [
            Text("HITS", style: textTheme.button),
            Text(
              "${state.readablePrize}",
              style: textTheme.subtitle1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        Column(
          children: [
            Text("TAPAL/KABIG", style: textTheme.button),
            Text(
              "${state.readableTapalKabig}",
              style: textTheme.subtitle1?.copyWith(
                color: color,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ],
    );
  }
}
