import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

import 'multi_select_chip_display.dart';

class MultiSelect extends StatelessWidget {

  MultiSelect(
      {this.buttons,
      this.insertMultiSelect,
      this.title,
      this.previouslySelected});

  final List<ButtonDialogflow> buttons;
  final String title;
  final Function insertMultiSelect;
  final List<dynamic> previouslySelected;

  @override
  Widget build(BuildContext context) {
    final _items = this
        .buttons
        .map((reply) => MultiSelectItem<String>(reply.text, reply.text))
        .toList();

    return Container(
      margin: const EdgeInsets.only(top: 15.0),
      child: Material(
          child: MultiSelectChipDisplay(
        items: _items,
        onTap: (value, isSelected) => insertMultiSelect(value, isSelected),
      )
          ),
    );
  }
}
