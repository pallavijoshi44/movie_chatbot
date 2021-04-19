import 'package:flutter/material.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

class MultiSelectChipDisplay<V> extends StatelessWidget {
  final List<MultiSelectItem<V>> items;
  final Function(V) onTap;
  final ScrollController _scrollController = ScrollController();

  MultiSelectChipDisplay({this.items, this.onTap});

  @override
  Widget build(BuildContext context) {
    if (items == null || items.isEmpty) return Container();
    return Container(
      decoration: BoxDecoration(color: Color.fromRGBO(249, 248, 235, 1)),
      alignment: Alignment.centerLeft,
      child: Container(
          width: MediaQuery.of(context).size.width,
          height: 40,
          child: Scrollbar(
            controller: _scrollController,
            isAlwaysShown: false,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              controller: _scrollController,
              itemCount: items.length,
              itemBuilder: (ctx, index) {
                return _buildItem(items[index], context);
              },
            ),
          )),
    );
  }

  Widget _buildItem(MultiSelectItem<V> item, BuildContext context) {
    return Container(
       padding: const EdgeInsets.all(2.0),
      child: OutlineButton(
        disabledBorderColor: Colors.grey[600],
        disabledTextColor: Colors.grey[900],
        child: Text(item.label,
            style:
            TextStyle(fontFamily: 'QuickSand', fontSize: 14)),
        borderSide: BorderSide(color: Colors.lightGreen[900]),
        textColor: Colors.lightGreen[900],
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15))),
        onPressed: () {
         // return insertQuickReply(quickReply);
        },
      ),
    );
  }
}
