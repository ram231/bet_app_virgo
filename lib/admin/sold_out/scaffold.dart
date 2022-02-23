import 'package:bet_app_virgo/admin/sold_out/cubit/sold_out_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../login/widgets/builder.dart';

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
          user: user,
        ),
        child: child,
      );
    });
  }
}

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
  late final TextEditingController _twoDigitController;
  late final TextEditingController _threeDigitController;
  static const _numberOnly =
      TextInputType.numberWithOptions(decimal: false, signed: false);
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    _controller = TextEditingController();
    _twoDigitController = TextEditingController();
    _threeDigitController = TextEditingController();
    if (mounted) {
      context.read<SoldOutCubit>().fetch();
    }
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _twoDigitController.dispose();
    _threeDigitController.dispose();
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
      final type = _selectedType == 'SOLD OUT' ? 'sold-outs' : 'low-wins';
      _formKey.currentState?.reset();
      _controller.clear();
      _twoDigitController.clear();
      context.read<SoldOutCubit>().fetch(
            endPoint: type,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
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
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                maxLength: 2,
                onChanged: (val) {
                  if (val.isEmpty) {
                    return;
                  }
                },
                validator: (val) {
                  if (val != null && val.isNotEmpty) {
                    return null;
                  }
                  return "Required";
                },
              ),
            ),
          ),
          if (_selectedType == "LOW WIN")
            Flexible(
              child: Row(
                children: [
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        keyboardType: _numberOnly,
                        controller: _twoDigitController,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          hintText: "2 Digit amount",
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        keyboardType: _numberOnly,
                        controller: _threeDigitController,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          hintText: "3 Digit amount",
                        ),
                      ),
                    ),
                  ),
                ],
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
                          );
                    } else {
                      context.read<SoldOutCubit>().submit(
                            number: _controller.text,
                            twoDigitAmount: _twoDigitController.text,
                            threeDigitAmount: _threeDigitController.text,
                          );
                    }
                  },
                  child: Text("ADD"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                    onPressed: () {}, child: Text("REFRESH LIST")),
              )
            ],
          )),
          const SoldOutListView(),
        ],
      ),
    );
  }
}

class SoldOutListView extends StatelessWidget {
  const SoldOutListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<SoldOutCubit>().state;
    if (state.isLoading) {
      return Center(child: CircularProgressIndicator.adaptive());
    }
    return Expanded(
      flex: 4,
      child: Column(
        children: [
          if (state.hasError)
            Text(
              "${state.error}",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
            ),
          Flexible(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: DataTable(
                  columns: [
                    DataColumn(label: Text("Number")),
                    if (state.type == 'low-wins') ...[
                      DataColumn(label: Text("2 Digit Win Amount")),
                      DataColumn(label: Text("3 Digit Win Amount")),
                    ],
                    DataColumn(label: Text("Action")),
                  ],
                  rows: state.items
                      .map((e) => DataRow(cells: [
                            DataCell(Text("${e.soldOutNumber}")),
                            if (state.type == 'low-wins') ...[
                              DataCell(Text("${e.readableWinAmount}")),
                              DataCell(
                                  Text("${e.readableThreeDigitWinningAmount}"))
                            ],
                            DataCell(ElevatedButton(
                              onPressed: () {
                                context.read<SoldOutCubit>().delete(
                                      id: e.id,
                                    );
                              },
                              child: Text("DELETE"),
                            )),
                          ]))
                      .toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
