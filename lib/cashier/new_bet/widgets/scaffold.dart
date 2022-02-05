import 'package:bet_app_virgo/cashier/new_bet/cubit/create_new_bet_cubit.dart';
import 'package:bet_app_virgo/cashier/new_bet/dto/append_bet_dto.dart';
import 'package:bet_app_virgo/login/bloc/login_bloc.dart';
import 'package:bet_app_virgo/login/widgets/builder.dart';
import 'package:bet_app_virgo/utils/nil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    return LoginSuccessBuilder(builder: (state) {
      return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => DrawTypeCubit(
              cashierId: "${state.id}",
            ),
          ),
          BlocProvider(
            create: (context) => NewBetBloc(
              cashierId: "${state.id}",
            ),
          ),
        ],
        child: child,
      );
    });
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
          actions: [_AddNewBetIcon(), _UndoBetIconButton()],
        ),
        body: _CashierNewBetBody(),
      ),
    );
  }
}

class _UndoBetIconButton extends StatelessWidget {
  const _UndoBetIconButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          context.read<NewBetBloc>().add(ResetBetEvent());
        },
        icon: Icon(Icons.undo));
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
            Navigator.pushReplacement(context,
                CupertinoPageRoute(builder: (context) {
              return BlocProvider(
                create: (_) => CreateNewBetCubit(
                  cashierId: "${userState.user.id}",
                )..onSave(
                    userState.user,
                    _state.items,
                    _state.drawTypeBet!,
                  ),
                child: BetResultScaffold(),
              );
            }));
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
  late final FocusNode _betNumberFocusNode;
  final GlobalKey<FormState> formKey = GlobalKey();
  @override
  void initState() {
    _betNumberController = TextEditingController();
    _betAmountController = TextEditingController();
    _betNumberFocusNode = FocusNode();
    context.read<DrawTypeCubit>().fetchDrawTypes();
    super.initState();
  }

  @override
  void dispose() {
    _betNumberController.dispose();
    _betAmountController.dispose();
    _betNumberFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DrawTypeCubit, DrawTypeState>(
        listener: (context, state) {
      if (state is DrawTypesLoaded) {
        context
            .read<NewBetBloc>()
            .add(InsertNewBetEvent(drawTypeBet: state.selectedDrawType));
      }
    }, builder: (context, state) {
      final isClosed = state is DrawTypesLoaded && state.drawTypes.isNotEmpty;
      return Form(
        key: formKey,
        child: ListView(
          children: [
            _GroundZeroLabel(),
            _DateCreatedLabel(),
            _BetNumberTextField(
                focusNode: _betNumberFocusNode,
                betNumberController: _betNumberController),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _betAmountController,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: "Bet Amount",
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r"^[+-]?([0-9]+\.?[0-9]*|\.[0-9]+)$"),
                  ),
                  FilteringTextInputFormatter.deny(
                    RegExp(r"[+-]"),
                  )
                ],
                validator: (val) {
                  if (val != null && val.isNotEmpty) {
                    return null;
                  }
                  return "Required";
                },
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
            Container(
              padding: const EdgeInsets.all(8),
              width: double.infinity,
              child: _BetTypeDropdown(),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isClosed
                    ? () {
                        final validate =
                            formKey.currentState?.validate() ?? false;
                        if (validate) {
                          final userState = context.read<LoginBloc>().state;
                          if (userState is LoginSuccess) {
                            final _state = context.read<NewBetBloc>().state;
                            final winAmount = double.parse(
                                _state.drawTypeBet?.winningAmount ?? "0");
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
                            _betAmountController.clear();
                            _betNumberController.clear();
                            _betNumberFocusNode.requestFocus();
                          }
                        }
                      }
                    : null,
                child: Text("APPEND"),
              ),
            ),
            NewBetBuilder(
              builder: (state) {
                if (state.isLoading) {
                  return Center(child: CircularProgressIndicator.adaptive());
                }
                if (state.error.isNotEmpty) {
                  return Center(
                    child: Text(
                      "${state.error}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }
                return notNil;
              },
            ),
            SizedBox(height: 250, child: _BetTable())
          ],
        ),
      );
    });
  }
}

class _BetNumberTextField extends StatelessWidget {
  const _BetNumberTextField({
    Key? key,
    required TextEditingController betNumberController,
    required this.focusNode,
  })  : _betNumberController = betNumberController,
        super(key: key);
  final FocusNode focusNode;
  final TextEditingController _betNumberController;
  @override
  Widget build(BuildContext context) {
    return DrawTypeBuilder(builder: (state) {
      return Form(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            focusNode: focusNode,
            controller: _betNumberController,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: "Bet Number",
            ),
            keyboardType:
                TextInputType.numberWithOptions(decimal: false, signed: false),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r"[0-9]*$"))
            ],
            validator: (val) {
              if (val != null && val.isNotEmpty) {
                final appendBet = context.read<NewBetBloc>().state;
                final isDup = appendBet.items
                    .where((element) => element.betNumber == int.parse(val))
                    .toList();
                if (isDup.isNotEmpty) {
                  return "Bet Number already taken";
                }
                return null;
              }
              return "Required";
            },
            onChanged: (val) {
              if (val.isNotEmpty) {
                final betNumber = int.parse(val);
                context.read<NewBetBloc>().add(InsertNewBetEvent(
                      betNumber: betNumber,
                    ));
              }
              context.read<DrawTypeCubit>().changeDrawTypeByLength(val);
            },
          ),
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
    final loginState = context.watch<LoginBloc>().state;
    if (loginState is LoginSuccess) {
      return Container(
        padding: const EdgeInsets.all(8),
        width: double.infinity,
        color: Colors.blue[700],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Branch Name",
              style: labelStyle,
            ),
            Text(
              ":",
              style: labelStyle,
            ),
            Text(
              "${loginState.user.company}",
              style: labelStyle,
            ),
          ],
        ),
      );
    }
    return notNil;
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
                      DataCell(Text("${draw.drawTypeBet?.drawType?.name}")),
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
                label: Text("Prize"),
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
            .where((element) => (element.winningCombination == null))
            .map((type) => DropdownMenuItem(
                  child: Text("${type.drawType?.name} - ${type.timeStart}"),
                  value: type,
                ))
            .toList(),
      );
    });
  }
}
