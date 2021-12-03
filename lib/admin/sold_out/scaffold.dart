import 'package:flutter/material.dart';

class BetSoldOutScaffold extends StatelessWidget {
  static const path = "/sold-out";
  const BetSoldOutScaffold({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sold out / Low win"),
        elevation: 0,
      ),
      body: _SoldOutBody(),
    );
  }
}

class _SoldOutBody extends StatefulWidget {
  const _SoldOutBody({Key? key}) : super(key: key);
  @override
  State<_SoldOutBody> createState() => _SoldOutBodyState();
}

class _SoldOutBodyState extends State<_SoldOutBody> {
  static const _items = [
    "Lanao Del Sur",
    "Cotabato City",
    "Maguindanao",
    "Maguindanao B",
    "Marawi",
    "Bukidnon",
    "MAGwin8 win6",
    "L Del Sur Win8",
  ];
  static const _time = [
    "11AM",
    "4PM",
    "9LPM",
    "9SPM",
    "4D",
  ];
  String _selectedItem = _items.first;
  String selectedTime = _time.first;
  static const _radioGroup = [
    "SOLD OUT",
    "LOW WIN",
  ];
  String _selectedType = _radioGroup.first;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(
          child: DropdownButtonFormField(
            items: _items
                .map((e) => DropdownMenuItem<String>(child: Text(e), value: e))
                .toList(),
            value: _selectedItem,
          ),
        ),
        Flexible(
          child: DropdownButtonFormField(
            items: _time
                .map((e) => DropdownMenuItem<String>(child: Text(e), value: e))
                .toList(),
            value: selectedTime,
          ),
        ),
        Flexible(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Radio(
                groupValue: _selectedType,
                onChanged: (val) {},
                value: _radioGroup.first,
              ),
              Text(_selectedType),
              Radio(
                groupValue: _selectedType,
                onChanged: (val) {},
                value: _radioGroup.last,
              ),
              Text(_selectedType),
            ],
          ),
        ),
        Flexible(
          child: TextFormField(
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: "Combination",
            ),
          ),
        ),
        Flexible(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {},
                child: Text("ADD"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child:
                  ElevatedButton(onPressed: () {}, child: Text("REFRESH LIST")),
            )
          ],
        )),
        Expanded(
          child: DataTable(
            columns: [
              DataColumn(label: Text("Draw")),
              DataColumn(label: Text("Comb")),
              DataColumn(label: Text("Action")),
            ],
            rows: [
              DataRow(cells: [
                DataCell(Text("11S2")),
                DataCell(Text("00")),
                DataCell(ElevatedButton(
                  onPressed: () {},
                  child: Text("DELETE"),
                )),
              ])
            ],
          ),
        ),
      ],
    );
  }
}
