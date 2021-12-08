import 'package:bet_app_virgo/admin/draws/create_draw/widgets/scaffold.dart';
import 'package:bet_app_virgo/login/bloc/login_bloc.dart';
import 'package:bet_app_virgo/models/draw.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminDrawScaffold extends StatelessWidget {
  const AdminDrawScaffold({Key? key}) : super(key: key);
  static const path = '/draws';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () async {
                final user = context.read<LoginBloc>().state;
                if (user is LoginSuccess) {
                  final result = await Navigator.pushNamed<DrawBet>(
                    context,
                    CreateDrawScaffold.path,
                    arguments: DrawBet(id: 0, employee: user.user),
                  );
                  if (result != null) {}
                }
              },
              icon: Icon(Icons.add))
        ],
      ),
      body: _AdminDrawBody(),
    );
  }
}

class _AdminDrawBody extends StatelessWidget {
  const _AdminDrawBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return ListTile(
          title: Text("Draw Name #$index"),
          subtitle: Text("Digits $index"),
          trailing: PopupMenuButton<String>(
            onSelected: (val) {},
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.edit),
                      Text("Edit"),
                    ],
                  ),
                ),
                PopupMenuItem(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.delete),
                      Text("Delete"),
                    ],
                  ),
                ),
              ];
            },
          ),
        );
      },
    );
  }
}
