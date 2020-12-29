import 'package:flutter/material.dart';
import 'package:flutter_app/widget/quick_reply.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class MultiSelect extends StatefulWidget {
  MultiSelect(
      {this.quickReplies, this.insertQuickReply, this.title, this.name});

  final List<String> quickReplies;
  final String title;
  final String name;
  final Function insertQuickReply;

  @override
  _MultiSelectState createState() => _MultiSelectState();
}

class _MultiSelectState extends State<MultiSelect> {
  List<String> _selectedItems = [];
  final _multiSelectKey = GlobalKey<FormFieldState>();

  @override
  void initState() {
    _selectedItems = this.widget.quickReplies;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _items = this
        .widget
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
                    Text(this.widget.name,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Container(
                      margin: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                      child: Text(widget.title),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      child: Column(
                        children: <Widget>[
                          MultiSelectBottomSheetField(
                            initialChildSize: 0.4,
                            listType: MultiSelectListType.CHIP,
                            searchable: true,
                            buttonText: Text("Select genres here"),
                            title: Text("Genres"),
                            buttonIcon: Icon(Icons.arrow_drop_down),
                            items: _items,
                            onConfirm: (values) {
                              _selectedItems = values;
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
