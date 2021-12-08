import 'package:flutter/material.dart';

class CreateDrawTypeScaffold extends StatelessWidget {
  const CreateDrawTypeScaffold({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _CreateDrawTypeBody(),
    );
  }
}

class _CreateDrawTypeBody extends StatefulWidget {
  const _CreateDrawTypeBody({Key? key}) : super(key: key);

  @override
  __CreateDrawTypeBodyState createState() => __CreateDrawTypeBodyState();
}

class __CreateDrawTypeBodyState extends State<_CreateDrawTypeBody> {
  late final GlobalKey<FormState> _formkey;
  late final TextEditingController _nameController;
  late final TextEditingController _digitController;
  late final TextEditingController _timeStartController;
  late final TextEditingController _timeEndController;

  @override
  void initState() {
    _formkey = GlobalKey<FormState>();
    _nameController = TextEditingController();
    _digitController = TextEditingController();
    _timeStartController = TextEditingController();
    _timeEndController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _digitController.dispose();
    _timeStartController.dispose();
    _timeEndController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formkey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            /// Draw Type name
            SizedBox(
                child: TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "Draw name",
              ),
            )),
            SizedBox(
                child: TextFormField(
              controller: _digitController,
              decoration: InputDecoration(labelText: "Digits"),
            )),

            /// TODO: use time picker here
            /// time Start
            SizedBox(
                child: TextFormField(
              controller: _timeStartController,
              decoration: InputDecoration(labelText: "Time Start"),
            )),

            /// time end
            SizedBox(
                child: TextFormField(
              controller: _timeEndController,
              decoration: InputDecoration(labelText: "Time End"),
            )),
            SizedBox(
                child: ElevatedButton(
              child: Text("Submit"),
              onPressed: () {},
            ))
          ],
        ),
      ),
    );
  }
}
