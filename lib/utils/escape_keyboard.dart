import 'package:flutter/material.dart';

class EscapeKeyboard extends StatelessWidget {
  const EscapeKeyboard({
    Key? key,
    required this.child,
  }) : super(key: key);
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final currentScope = FocusScope.of(context);
        final hasFocus = !currentScope.hasPrimaryFocus && currentScope.hasFocus;
        if (hasFocus) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: child,
    );
  }
}
