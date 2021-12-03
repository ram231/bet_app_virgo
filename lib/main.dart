import 'package:bet_app_virgo/cashier/dashboard/widgets/scaffold.dart';
import 'package:bet_app_virgo/login/bloc/login_bloc.dart';
import 'package:bet_app_virgo/utils/http_client.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

import 'admin/admin.dart';
import 'cashier/cashier.dart';
import 'login/widgets/scaffold.dart';
import 'login/widgets/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getApplicationDocumentsDirectory(),
  );
  runApp(HttpProvider(child: const BetProviders()));
}

class HttpProvider extends StatelessWidget {
  const HttpProvider({required this.child, Key? key}) : super(key: key);
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => STLHttpClient(),
      child: child,
    );
  }
}

class BetProviders extends StatelessWidget {
  const BetProviders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LoginBloc()),
      ],
      child: MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      initialRoute: SplashScreenScaffold.path,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case BetLoginScaffold.path:
            return CupertinoPageRoute(builder: (context) => BetLoginScaffold());
          case BetDashboardScaffold.path:
            return CupertinoPageRoute(
                builder: (context) => BetDashboardScaffold());
          case BetLogsScaffold.path:
            return CupertinoPageRoute(builder: (context) => BetLogsScaffold());
          case BetCombinationScaffold.path:
            return CupertinoPageRoute(
                builder: (context) => BetCombinationScaffold());
          case BetCategoryScaffold.path:
            return CupertinoPageRoute(
                builder: (context) => BetCategoryScaffold());
          case BetGenerateHitScaffold.path:
            return CupertinoPageRoute(
                builder: (context) => BetGenerateHitScaffold());
          case BetSoldOutScaffold.path:
            return CupertinoPageRoute(
                builder: (context) => BetSoldOutScaffold());
          case SplashScreenScaffold.path:
            return CupertinoPageRoute(
                builder: (context) => SplashScreenScaffold());
          case CashierDashboardScaffold.path:
            return CupertinoPageRoute(
                builder: (context) => CashierDashboardScaffold());
          case CashierNewBetScaffold.path:
            return CupertinoPageRoute(
                builder: (context) => CashierNewBetScaffold());
          case CashierBetHistoryScaffold.path:
            return CupertinoPageRoute(
                builder: (context) => CashierBetHistoryScaffold());
          case CashierHitScaffold.path:
            return CupertinoPageRoute(
                builder: (context) => CashierHitScaffold());
          case CashierBetCancelScaffold.path:
            return CupertinoPageRoute(
                builder: (context) => CashierBetCancelScaffold());
          case CashierPrinterScaffold.path:
            return CupertinoPageRoute(
                builder: (context) => CashierPrinterScaffold());
          default:
            return CupertinoPageRoute(builder: (context) => BetLoginScaffold());
        }
      },
    );
  }
}
