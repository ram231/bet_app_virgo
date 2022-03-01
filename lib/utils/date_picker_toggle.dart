import 'package:flutter/material.dart';

class DatePickerToggleButton extends StatefulWidget {
  const DatePickerToggleButton({required this.onPressed, Key? key})
      : super(key: key);
  final void Function(int index) onPressed;
  @override
  _DatePickerToggleButtonState createState() => _DatePickerToggleButtonState();
}

class _DatePickerToggleButtonState extends State<DatePickerToggleButton> {
  List<bool> tabs = [
    true,
    false,
    false,
    false,
  ];
  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      selectedBorderColor: Colors.yellow[700],
      selectedColor: Colors.yellow[700],
      borderRadius: BorderRadius.circular(4),
      borderWidth: 1,
      onPressed: (index) async {
        tabs = tabs.map((e) => false).toList();
        setState(() {
          tabs[index] = true;
        });
        widget.onPressed(index);
      },
      isSelected: tabs,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text("Today"),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text("Yesterday"),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text("Last 7 days"),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Icon(
            Icons.date_range_outlined,
          ),
        )
      ],
    );
  }
}
