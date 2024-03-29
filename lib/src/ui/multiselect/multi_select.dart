import 'package:dialogflow_flutter/message.dart';
import 'package:flutter/material.dart';

import 'multi_select_chip_display.dart';

class MultiSelect extends StatelessWidget {
  MultiSelect(
      {required this.buttons,
      required this.insertMultiSelect,
      required this.title,
      required this.previouslySelected,
      required this.containsNoPreference});

  final List<ButtonDialogflow> buttons;
  final String title;
  final Function insertMultiSelect;
  final List<dynamic> previouslySelected;
  final bool containsNoPreference;

  @override
  Widget build(BuildContext context) {
    final _items = this
        .buttons
        .map((reply) => reply.text)
        .toList();

    return Container(
      margin: const EdgeInsets.only(top: 15.0),
      child: Material(
          child: MultiSelectChipDisplay(
        items: _items,
        containsNoPreference: containsNoPreference,
        onTap: (value, isSelected, selectedItems) {
          String selectedText = _constructSelectedText(_items, selectedItems);
          if (value == _items.last &&
              containsNoPreference) {
            var text = selectedText.replaceAll(value, "").trim();
            return insertMultiSelect(value, isSelected, text, true);
          }
          return insertMultiSelect(value, isSelected, selectedText, false);
        },
      )),
    );
  }

  String _constructSelectedText(
      List<String?> _items, selectedItems) {
    var list = _items
        .where((item) => selectedItems.elementAt(_items.indexOf(item)) == true);
    String selectedText = list.fold(
        "", (previousValue, element) => previousValue + " " + element!);
    return selectedText;
  }
}
