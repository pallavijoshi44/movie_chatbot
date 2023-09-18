import 'package:flutter/material.dart';

class ChoiceChipMobo extends StatelessWidget {
  final String label;
  final bool selected;
  final Function(bool isSelected)? onSelected;
  final bool isNoPreferenceSelected;

  ChoiceChipMobo(
      {Key? key,
      required this.label,
      required this.selected,
      required this.onSelected,
      required this.isNoPreferenceSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2.0),
      child: Material(
        color: Color.fromRGBO(249, 248, 235, 1),
        child: ChoiceChip(
            elevation: 2,
            backgroundColor: Color.fromRGBO(249, 248, 235, 1),
            disabledColor: Colors.lightGreen[100],
            label: Text(label,
                style: TextStyle(fontFamily: 'QuickSand', fontSize: 14)),
            labelStyle: isNoPreferenceSelected
                ? TextStyle(color: Colors.black)
                : TextStyle(color: Colors.lightGreen[900]),
            shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.lightGreen[900]!),
                borderRadius: BorderRadius.all(Radius.circular(15))),
            selected: selected,
            selectedColor: Colors.lightGreen[100],
            onSelected: onSelected),
      ),
    );
  }
}
