import 'package:flutter/material.dart';

mixin AfterInitStateMixin<T extends StatefulWidget> on State<T> {
  bool _didInitState = false;
  @override
  @mustCallSuper
  void didChangeDependencies() {
    if (!_didInitState) {
      didInitState();
      _didInitState = true;
    }
    super.didChangeDependencies();
  }

  void didInitState();
}
