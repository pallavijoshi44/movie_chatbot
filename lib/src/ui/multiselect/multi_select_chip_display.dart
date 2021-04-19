import 'package:flutter/material.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

class MultiSelectChipDisplay<V> extends StatefulWidget {
  final List<MultiSelectItem<V>> items;
  final Function onTap;

  MultiSelectChipDisplay({this.items, this.onTap});

  @override
  _MultiSelectChipDisplayState<V> createState() => _MultiSelectChipDisplayState<V>();
}

class _MultiSelectChipDisplayState<V> extends State<MultiSelectChipDisplay<V>> {
  final ScrollController _scrollController = ScrollController();
  List<bool> _selectedItems = [];

  @override
  void initState() {
    _selectedItems = new List.filled(widget.items.length, false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items == null || widget.items.isEmpty) return Container();
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
              itemCount: widget.items.length,
              itemBuilder: (ctx, index) {
                return _buildItem(widget.items[index], context, index);
              },
            ),
          )),
    );
  }

  Widget _buildItem(MultiSelectItem<V> item, BuildContext context, int index) {
    return Container(
      padding: const EdgeInsets.all(2.0),
      child: ChoiceChip(
          backgroundColor: Color.fromRGBO(249, 248, 235, 1),
          disabledColor: Colors.green[300],
          label: Text(item.label,
              style: TextStyle(fontFamily: 'QuickSand', fontSize: 14)),
          labelStyle: TextStyle(color: Colors.lightGreen[900]),
          shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.lightGreen[900]),
              borderRadius: BorderRadius.all(Radius.circular(15))),
          selected:  _selectedItems[index] ?? false ,
          selectedColor: Colors.green[100],
          onSelected: (value) {
            if (widget.onTap != null) widget.onTap(item.label);
            setState(() {
              _selectedItems[index] = !_selectedItems[index];
            });
          }),
    );
  }
}
