import 'package:bet_app_virgo/admin/dashboard/scaffold.dart';
import 'package:bet_app_virgo/cashier/cashier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/login_bloc.dart';
import 'builder.dart';

class BetLoginScaffold extends StatelessWidget {
  static const path = "/";
  const BetLoginScaffold({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: BetLoginBody());
  }
}

class BetLoginBody extends StatefulWidget {
  const BetLoginBody({
    Key? key,
  }) : super(key: key);

  @override
  State<BetLoginBody> createState() => _BetLoginBodyState();
}

class _BetLoginBodyState extends State<BetLoginBody> {
  bool _obscure = true;
  final _userController = TextEditingController();
  final _passController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return LoginAuthenticator(
      successListener: (state) {
        if (state.user.type == 'A') {
          Navigator.pushReplacementNamed(context, BetDashboardScaffold.path);
        } else if (state.user.type == 'MC' || state.user.type == 'C') {
          Navigator.pushReplacementNamed(
              context, CashierDashboardScaffold.path);
        }
      },
      builder: (context, state) => Form(
        key: _formKey,
        child: Column(
          children: [
            Spacer(),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _userController,
                  validator: (val) {
                    if (val != null) {
                      if (val.isEmpty) {
                        return "Required!";
                      }
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "User",
                  ),
                ),
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _passController,
                  validator: (val) {
                    if (val != null) {
                      if (val.isEmpty) {
                        return "Required!";
                      }
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Passkey",
                    suffix: GestureDetector(
                      onTap: () {
                        setState(() {
                          _obscure = !_obscure;
                        });
                      },
                      child: Icon(
                        _obscure ? Icons.visibility_off : Icons.visibility,
                      ),
                    ),
                  ),
                  obscureText: _obscure,
                ),
              ),
            ),
            Spacer(),
            if (state is LoginLoading)
              Center(child: CircularProgressIndicator.adaptive())
            else
              SizedBox(
                width: MediaQuery.of(context).size.width - 100,
                height: 32,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow[700],
                  ),
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      context.read<LoginBloc>().add(
                            SignInEvent(
                              username: _userController.text,
                              password: _passController.text,
                            ),
                          );
                    }
                  },
                  child: Text(
                    "LOGIN",
                    style: Theme.of(context).textTheme.button?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
            if (state is LoginFailed)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  "ERROR:${state.error}",
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
