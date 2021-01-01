import 'package:flutter/material.dart';
import 'package:flutter_app/widget/quick_reply.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class MultiSelect extends StatelessWidget {
  MultiSelect(
      {this.quickReplies, this.insertQuickReply, this.title, this.name, this.previouslySelected});

  final List<String> quickReplies;
  final String title;
  final String name;
  final Function insertQuickReply;
  final List<String> previouslySelected;

  @override
  Widget build(BuildContext context) {
    final _items = this
        .quickReplies
        .map((reply) => MultiSelectItem<String>(reply, reply))
        .toList();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(right: 16.0),
                child: CircleAvatar(child: Text('B')),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(this.name,
                    style: Theme.of(context).textTheme.title),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(25),
                          topLeft: Radius.circular(25),
                          bottomLeft: Radius.circular(25),
                        ),
                      ),
                      margin: const EdgeInsets.only(top: 5.0),
                      padding: const EdgeInsets.all(15),
                      child: Text(title,  style: Theme.of(context).textTheme.headline),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      child: Column(
                        children: <Widget>[
                           MultiSelectBottomSheetField(
                             initialValue: previouslySelected,
                            initialChildSize: 0.4,
                            listType: MultiSelectListType.CHIP,
                            searchable: true,
                            buttonText: Text("Select genres here"),
                            title: Text("Genres"),
                            buttonIcon: Icon(Icons.arrow_drop_down),
                            items: _items,
                            onConfirm: (values) {
                              insertQuickReply(values);
                              //  widget.insertQuickReply(_selectedItems.reduce((previousValue, element) => previousValue + " " + element));
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
