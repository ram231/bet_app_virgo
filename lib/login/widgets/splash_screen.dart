import 'package:bet_app_virgo/cashier/cashier.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

import '../../admin/dashboard/scaffold.dart';
import '../../utils/after_init.dart';
import '../bloc/login_bloc.dart';
import 'scaffold.dart';

class SplashScreenScaffold extends StatefulWidget {
  static const path = '/splash_screen';
  const SplashScreenScaffold({Key? key}) : super(key: key);

  @override
  State<SplashScreenScaffold> createState() => _SplashScreenScaffoldState();
}

class _SplashScreenScaffoldState extends State<SplashScreenScaffold>
    with AfterInitStateMixin {
  @override
  void didInitState() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
      final loginState = context.read<LoginBloc>().state;
      if (loginState is LoginSuccess) {
        if (loginState.user.type == 'A') {
          Navigator.pushReplacementNamed(
            context,
            BetDashboardScaffold.path,
          );
        } else if (loginState.user.type == 'MC' ||
            loginState.user.type == 'C') {
          Navigator.pushReplacementNamed(
            context,
            CashierDashboardScaffold.path,
          );
        }
      } else {
        Navigator.pushReplacementNamed(context, BetLoginScaffold.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
    );
  }
}
