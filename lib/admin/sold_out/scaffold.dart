import 'package:bet_app_virgo/admin/sold_out/cubit/sold_out_cubit.dart';
import 'package:bet_app_virgo/utils/nil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../login/widgets/builder.dart';

class BetSoldOutScaffold extends StatelessWidget {
  static const path = "/sold-out";
  const BetSoldOutScaffold({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SoldOutProvider(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Sold out / Low win"),
          elevation: 0,
        ),
        body: _SoldOutBody(),
      ),
    );
  }
}

class _SoldOutBody extends StatefulWidget {
  const _SoldOutBody({Key? key}) : super(key: key);
  @override
  State<_SoldOutBody> createState() => _SoldOutBodyState();
}

class _SoldOutBodyState extends State<_SoldOutBody> {
  late final TextEditingController _controller;
  late final TextEditingController _amountController;
  static const _numberOnly =
      TextInputType.numberWithOptions(decimal: false, signed: false);
  @override
  void initState() {
    _controller = TextEditingController();
    _amountController = TextEditingController();
    if (mounted) {
      context.read<SoldOutCubit>().fetch();
    }
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _amountController.dispose();
    super.dispose();
  }

  static const _radioGroup = [
    "SOLD OUT",
    "LOW WIN",
  ];
  String _selectedType = _radioGroup.first;
  void onChange(String? val) {
    setState(() {
      _selectedType = val ?? "SOLD OUT";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Radio<String>(
                groupValue: _selectedType,
                onChanged: onChange,
                value: _radioGroup.first,
              ),
              Text(_radioGroup.first),
              Radio<String>(
                groupValue: _selectedType,
                onChanged: onChange,
                value: _radioGroup.last,
              ),
              Text(_radioGroup.last),
            ],
          ),
        ),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              keyboardType: _numberOnly,
              controller: _controller,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: "Combination",
              ),
            ),
          ),
        ),
        if (_selectedType == "LOW WIN")
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                keyboardType: _numberOnly,
                controller: _amountController,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: "Low Win Amount",
                ),
              ),
            ),
          ),
        Flexible(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  if (_selectedType == "SOLD OUT") {
                    context.read<SoldOutCubit>().submit(
                          number: _controller.text,
                          type: "sold-outs",
                        );
                  } else {
                    context.read<SoldOutCubit>().submit(
                          number: _controller.text,
                          type: "low-wins",
                        );
                  }
                },
                child: Text("ADD"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child:
                  ElevatedButton(onPressed: () {}, child: Text("REFRESH LIST")),
            )
          ],
        )),
        const SoldOutListView(),
      ],
    );
  }
}

class SoldOutProvider extends StatelessWidget {
  const SoldOutProvider({
    required this.child,
    Key? key,
  }) : super(key: key);
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return LoginSuccessBuilder(builder: (user) {
      return BlocProvider(
        create: (context) => SoldOutCubit(
          cashierId: "${user.id}",
        ),
        child: child,
      );
    });
  }
}

class SoldOutListView extends StatelessWidget {
  const SoldOutListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<SoldOutCubit>().state;
    if (state.hasError) {
      return notNil;
    }
    return Expanded(
      flex: 4,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: DataTable(
            columns: [
              DataColumn(label: Text("Number")),
              DataColumn(label: Text("Win Amount")),
              DataColumn(label: Text("Action")),
            ],
            rows: state.items
                .map((e) => DataRow(cells: [
                      DataCell(Text("${e.soldOutNumber}")),
                      DataCell(Text("${e.winAmount}")),
                      DataCell(ElevatedButton(
                        onPressed: () {
                          context.read<SoldOutCubit>().delete(
                                soldOut: e.winAmount == "0",
                                id: e.id,
                              );
                        },
                        child: Text("DELETE"),
                      )),
                    ]))
                .toList(),
            // rows: [

            //   DataRow(cells: [
            //     DataCell(Text("11S2")),
            //     DataCell(Text("00")),

            //   ])
            // ],
          ),
        ),
      ),
    );
  }
}
