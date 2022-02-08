import 'package:flutter/material.dart';

class AdminHistoryScaffold extends StatelessWidget {
  const AdminHistoryScaffold({Key? key}) : super(key: key);
  static const path = '/admin/history';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _AdminHistoryBody(),
    );
  }
}

class _AdminHistoryBody extends StatelessWidget {
  const _AdminHistoryBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
