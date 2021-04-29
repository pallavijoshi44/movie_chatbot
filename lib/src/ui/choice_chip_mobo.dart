import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChoiceChipMobo extends StatelessWidget {
  final String label;
  final bool selected;
  final Function onSelected;
  final bool isNoPreferenceSelected;

  ChoiceChipMobo(
      {Key key,
      this.label,
      this.selected,
      this.onSelected,
      this.isNoPreferenceSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2.0),
      child: ChoiceChip(
          backgroundColor: Color.fromRGBO(249, 248, 235, 1),
          disabledColor: Colors.lightGreen[100],
          label: Text(label,
              style: TextStyle(fontFamily: 'QuickSand', fontSize: 14)),
          labelStyle: isNoPreferenceSelected
              ? TextStyle(color: Colors.black)
              : TextStyle(color: Colors.lightGreen[900]),
          shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.lightGreen[900]),
              borderRadius: BorderRadius.all(Radius.circular(15))),
          selected: selected,
          selectedColor: Colors.lightGreen[100],
          onSelected: onSelected),
    );
  }
}
