import 'package:bet_app_virgo/cashier/new_bet/cubit/create_new_bet_cubit.dart';
import 'package:bet_app_virgo/cashier/new_bet/dto/append_bet_dto.dart';
import 'package:bet_app_virgo/login/bloc/login_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../models/draw.dart';
import '../../../utils/timer.dart';
import '../bloc/new_bet_bloc.dart';
import '../cubit/draw_type_cubit.dart';
import 'bet_result_scaffold.dart';
import 'draw_type_builder.dart';
import 'new_bet_builder.dart';

class _DrawTypeProvider extends StatelessWidget {
  const _DrawTypeProvider({required this.child, Key? key}) : super(key: key);
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => DrawTypeCubit(),
        ),
        BlocProvider(
          create: (context) => NewBetBloc(),
        ),
      ],
      child: child,
    );
  }
}

class CashierNewBetScaffold extends StatelessWidget {
  static const path = '/cashier/new-bet';
  const CashierNewBetScaffold({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _DrawTypeProvider(
      child: Scaffold(
        appBar: AppBar(
          title: Text("New Bet"),
          elevation: 0,
          actions: [
            _AddNewBetIcon(),
            IconButton(onPressed: () {}, icon: Icon(Icons.undo))
          ],
        ),
        body: _CashierNewBetBody(),
      ),
    );
  }
}

class _AddNewBetIcon extends StatelessWidget {
  const _AddNewBetIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          final userState = context.read<LoginBloc>().state;
          if (userState is LoginSuccess) {
            final _state = context.read<NewBetBloc>().state;
            if (_state is NewBetLoaded) {
              Navigator.pushReplacement(context,
                  CupertinoPageRoute(builder: (context) {
                return BlocProvider(
                  create: (_) => CreateNewBetCubit()
                    ..onSave(
                      userState.user,
                      _state.items,
                      _state.drawTypeBet!,
                    ),
                  child: BetResultScaffold(),
                );
              }));
            }
          }
        },
        icon: Icon(Icons.save));
  }
}

class _CashierNewBetBody extends StatefulWidget {
  const _CashierNewBetBody({Key? key}) : super(key: key);

  @override
  State<_CashierNewBetBody> createState() => _CashierNewBetBodyState();
}

class _CashierNewBetBodyState extends State<_CashierNewBetBody> {
  late final TextEditingController _betNumberController;
  late final TextEditingController _betAmountController;

  @override
  void initState() {
    _betNumberController = TextEditingController();
    _betAmountController = TextEditingController();
    context.read<DrawTypeCubit>().fetchDrawTypes();
    super.initState();
  }

  @override
  void dispose() {
    _betNumberController.dispose();
    _betAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DrawTypeCubit, DrawTypeState>(
      listener: (context, state) {
        if (state is DrawTypesLoaded) {
          context
              .read<NewBetBloc>()
              .add(InsertNewBetEvent(drawTypeBet: state.selectedDrawType));
        }
      },
      child: Column(
        children: [
          _GroundZeroLabel(),
          _DateCreatedLabel(),
          Flexible(
            child:
                _BetNumberTextField(betNumberController: _betNumberController),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _betAmountController,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: "Bet Amount",
                ),
                keyboardType: TextInputType.numberWithOptions(
                    decimal: false, signed: false),
                onChanged: (val) {
                  if (val.isNotEmpty) {
                    context.read<NewBetBloc>().add(InsertNewBetEvent(
                          betAmount: double.parse(val),
                        ));
                  }
                },
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            width: double.infinity,
            child: _BetTypeDropdown(),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                final userState = context.read<LoginBloc>().state;
                if (userState is LoginSuccess) {
                  final _state = context.read<NewBetBloc>().state;
                  if (_state is NewBetLoaded) {
                    final winAmount =
                        double.parse(_state.drawTypeBet?.winningAmount ?? "0");
                    context.read<NewBetBloc>().add(
                          AddNewBetEvent(
                            dto: AppendBetDTO(
                              betAmount: _state.betAmount!,
                              betNumber: _state.betNumber!,
                              drawTypeBet: _state.drawTypeBet,
                              winAmount: winAmount,
                              cashier: userState.user,
                            ),
                          ),
                        );
                  }
                }
              },
              child: Text("APPEND"),
            ),
          ),
          Expanded(child: _BetTable())
        ],
      ),
    );
  }
}

class _BetNumberTextField extends StatelessWidget {
  const _BetNumberTextField({
    Key? key,
    required TextEditingController betNumberController,
  })  : _betNumberController = betNumberController,
        super(key: key);

  final TextEditingController _betNumberController;

  @override
  Widget build(BuildContext context) {
    return DrawTypeBuilder(builder: (state) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          controller: _betNumberController,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            hintText: "Bet Number",
            errorMaxLines: state.selectedDrawType?.drawType?.digits.toInt(),
          ),
          maxLength: state.selectedDrawType?.drawType?.digits.toInt(),
          keyboardType:
              TextInputType.numberWithOptions(decimal: false, signed: false),
          onChanged: (val) {
            if (val.isNotEmpty) {
              /// TODO: Listen to draw type and change it dynamically
              /// via bloc builder
              context.read<NewBetBloc>().add(InsertNewBetEvent(
                    betNumber: int.parse(val),
                  ));
            }
          },
        ),
      );
    });
  }
}

class _DateCreatedLabel extends StatefulWidget {
  const _DateCreatedLabel({Key? key}) : super(key: key);

  @override
  __DateCreatedLabelState createState() => __DateCreatedLabelState();
}

class __DateCreatedLabelState extends State<_DateCreatedLabel> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final labelStyle = textTheme.subtitle1?.copyWith(color: Colors.white);
    final now = DateTime.now();
    final today = DateFormat.LLLL().format(now);
    return Container(
      color: Colors.grey,
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text("$today", style: labelStyle),
          TimerBuilder.periodic(Duration(seconds: 1), builder: (context) {
            final now = DateTime.now();
            final time = DateFormat.Hms().format(now);
            return Text("${time}", style: labelStyle);
          }),
        ],
      ),
    );
  }
}

class _GroundZeroLabel extends StatelessWidget {
  const _GroundZeroLabel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final labelStyle = textTheme.subtitle1?.copyWith(
      color: Colors.white,
    );
    return Container(
      padding: const EdgeInsets.all(8),
      width: double.infinity,
      color: Colors.blue[700],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Ground Zero",
            style: labelStyle,
          ),
          Text(
            ":",
            style: labelStyle,
          ),
          Text(
            "Ground Zero",
            style: labelStyle,
          ),
        ],
      ),
    );
  }
}

class _BetTable extends StatelessWidget {
  const _BetTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NewBetBuilder(builder: (state) {
      return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            rows: state.items
                .map(
                  (draw) => DataRow(
                    cells: [
                      DataCell(Text("${draw.betNumber}")),
                      DataCell(Text("${draw.betAmount}")),
                      DataCell(Text("${draw.winAmount}")),
                      DataCell(Text("${draw.drawTypeBet?.id}")),
                    ],
                  ),
                )
                .toList(),
            columns: [
              DataColumn(
                label: Text("Bet number"),
              ),
              DataColumn(
                label: Text("Bet Amount"),
              ),
              DataColumn(
                label: Text("Win Amount"),
              ),
              DataColumn(
                label: Text("Draw"),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class _BetTypeDropdown extends StatefulWidget {
  const _BetTypeDropdown({Key? key}) : super(key: key);

  @override
  __BetTypeDropdownState createState() => __BetTypeDropdownState();
}

class __BetTypeDropdownState extends State<_BetTypeDropdown> {
  String _val = "CURRENT DAY OFF";
  @override
  Widget build(BuildContext context) {
    return DrawTypeBuilder(builder: (state) {
      return DropdownButtonFormField<DrawBet>(
        value: state.selectedDrawType,
        onChanged: (val) {
          if (val != null) {
            context.read<DrawTypeCubit>().changeDrawType(val);
          }
        },
        items: state.drawTypes
            .map((type) => DropdownMenuItem(
                  child: Text(type.drawType?.name ?? ""),
                  value: type,
                ))
            .toList(),
      );
    });
  }
}