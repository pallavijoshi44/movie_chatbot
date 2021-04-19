import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

import '../avatar.dart';
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Avatar(),
          Expanded(
            child: Material(
                child: MultiSelectChipDisplay(
              items: _items,
              onTap: (value) => insertMultiSelect(value),
            )
                // MultiSelectBottomSheetField(
                //   decoration: BoxDecoration(
                //       color: Colors.lightGreen[200],
                //       borderRadius: BorderRadius.only(
                //           topLeft: Radius.circular(30.0),
                //           topRight: Radius.circular(30.0),
                //           bottomRight: Radius.circular(30.0))),
                //   initialValue: previouslySelected,
                //   initialChildSize: 0.5,
                //   maxChildSize: 0.5,
                //   minChildSize: 0.5,
                //   listType: MultiSelectListType.CHIP,
                //   searchable: false,
                //   buttonText: Text("Select Genres Here",
                //       style: Platform.isIOS
                //           ? CupertinoTheme.of(context).textTheme.tabLabelTextStyle
                //           : Theme.of(context).textTheme.headline),
                //   title: Text("Genres",
                //       style: Platform.isIOS
                //           ? CupertinoTheme.of(context).textTheme.tabLabelTextStyle
                //           : Theme.of(context).textTheme.headline),
                //   buttonIcon: Icon(Icons.arrow_drop_down),
                //   selectedColor: Platform.isIOS? Colors.lightGreen[400] : null,
                //   items: _items,
                //   chipDisplay: MultiSelectChipDisplay(
                //     scroll: true,
                //     onTap: null,
                //     chipColor: Colors.lightGreen[200],
                //     textStyle: TextStyle(color: Colors.lightGreen[900]),
                //   ),
                //   selectedItemsTextStyle:
                //       TextStyle(color: Colors.lightGreen[900]),
                //   onConfirm: (values) {
                //     insertMultiSelect(values);
                //   },
                // ),
                ),
          ),
        ],
      ),
    );
  }
}
