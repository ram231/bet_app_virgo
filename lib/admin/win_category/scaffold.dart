import 'package:flutter/material.dart';

class BetCategoryScaffold extends StatelessWidget {
  static const path = '/win-category';
  const BetCategoryScaffold({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bet Win Amount Category"),
        elevation: 0,
      ),
      body: _BetCategoryBody(),
    );
  }
}

class _BetCategoryBody extends StatelessWidget {
  const _BetCategoryBody({Key? key}) : super(key: key);

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
              "Category $index",
              style: textTheme.headline6,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
