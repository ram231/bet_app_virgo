import 'package:flutter/material.dart';

class BetCombinationScaffold extends StatelessWidget {
  const BetCombinationScaffold({Key? key}) : super(key: key);
  static const path = "/combinations";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Top 10 Combinations"),
        elevation: 0,
      ),
      body: _BetCombinationBody(),
    );
  }
}

class _BetCombinationBody extends StatelessWidget {
  const _BetCombinationBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final labelTextStyle = textTheme.caption;
    final amountTextStyle = textTheme.subtitle2?.copyWith(
      fontWeight: FontWeight.bold,
    );
    return ListView.builder(itemBuilder: (context, index) {
      return Card(
        elevation: 0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "NO: $index Stall: Sharif guak $index",
              style: textTheme.headline6,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text("SCHED", style: labelTextStyle),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text("${index}S2", style: amountTextStyle),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text("COMBINATION", style: labelTextStyle),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text("${index}", style: amountTextStyle),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text("AMOUNT", style: labelTextStyle),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          "${index * 13}",
                          style: amountTextStyle,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
