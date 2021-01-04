import 'package:flutter/material.dart';
import 'package:flutter_app/widget/avatar.dart';
import 'package:flutter_app/widget/quick_reply.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

import 'message_layout.dart';

class MultiSelect extends StatelessWidget {
  MultiSelect(
      {this.buttons,
      this.insertMultiSelect,
      this.title,
      this.name,
      this.previouslySelected});

  final List<ButtonDialogflow> buttons;
  final String title;
  final String name;
  final Function insertMultiSelect;
  final List<String> previouslySelected;

  @override
  Widget build(BuildContext context) {
    final _items = this
        .buttons
        .map((reply) => MultiSelectItem<String>(reply.text, reply.text))
        .toList();

    return Container(
      margin: const EdgeInsets.only(top: 15.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Avatar('B'),
          Expanded(
            child: MultiSelectBottomSheetField(
              decoration: BoxDecoration(
                  color: Colors.lightGreen[200],
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                      bottomRight: Radius.circular(30.0))),
              initialValue: previouslySelected,
              initialChildSize: 0.4,
              listType: MultiSelectListType.CHIP,
              searchable: true,
              buttonText: Text("Select Genres Here",
                  style: Theme.of(context).textTheme.headline),
              title:
                  Text("Genres", style: Theme.of(context).textTheme.headline),
              buttonIcon: Icon(Icons.arrow_drop_down),
              // Colors.blue[700]
              items: _items,
              chipDisplay: MultiSelectChipDisplay(
                onTap: null,
                chipColor: Colors.lightGreen[200],
                textStyle: TextStyle(color: Colors.lightGreen[900]),
              ),
              selectedItemsTextStyle: TextStyle(color: Colors.lightGreen[900]),
              onConfirm: (values) {
                insertMultiSelect(values);
                //  widget.insertQuickReply(_selectedItems.reduce((previousValue, element) => previousValue + " " + element));
              },
            ),
          ),
        ],
      ),
    );
  }
}
