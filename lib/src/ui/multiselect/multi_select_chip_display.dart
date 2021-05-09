import 'package:flutter/material.dart';
import 'package:flutter_app/src/ui/choice_chip_mobo.dart';

class MultiSelectChipDisplay<V> extends StatefulWidget {
  final List<String> items;
  final Function onTap;
  final bool containsNoPreference;
  final List<bool> initialSelectedItems;
  final bool isToggleNeeded;

  MultiSelectChipDisplay(
      {this.items,
      this.onTap,
      this.containsNoPreference,
      this.initialSelectedItems,
      this.isToggleNeeded});

  @override
  _MultiSelectChipDisplayState<V> createState() =>
      _MultiSelectChipDisplayState<V>();
}

class _MultiSelectChipDisplayState<V> extends State<MultiSelectChipDisplay<V>> {
  final ScrollController _scrollController = ScrollController();
  List<bool> _selectedItems = [];
  bool isNoPreferenceSelected = false;
  bool _isToggleNeeded = false;

  @override
  void initState() {
    _selectedItems = widget.initialSelectedItems ??
        new List.filled(widget.items.length, false);
    _isToggleNeeded = widget.isToggleNeeded ?? false;
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
          height: widget.containsNoPreference ? 100 : 40,
          child: widget.containsNoPreference
              ? Container(
                  child: Column(
                    children: [
                      Flexible(child: _buildListView()),
                      ChoiceChipMobo(
                          isNoPreferenceSelected: isNoPreferenceSelected,
                          label: widget.items.last,
                          selected: _selectedItems[widget.items.length - 1] ??
                              false,
                          onSelected: (value) {
                            setState(() {
                              _selectedItems[widget.items.length - 1] =
                                  !_selectedItems[widget.items.length - 1];
                              isNoPreferenceSelected =
                                  _selectedItems[widget.items.length - 1];
                            });
                            if (widget.onTap != null)
                              widget.onTap(
                                  widget.items.last,
                                  _selectedItems[widget.items.length - 1],
                                  _selectedItems);
                          })
                    ],
                  ),
                )
              : _buildListView()),
    );
  }

  ListView _buildListView() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      controller: _scrollController,
      itemCount: widget.containsNoPreference
          ? widget.items.length - 1
          : widget.items.length,
      itemBuilder: (ctx, index) {
        var item = widget.items[index];
        return ChoiceChipMobo(
            isNoPreferenceSelected: isNoPreferenceSelected,
            label: item,
            selected: _selectedItems[index] ?? false,
            onSelected: isNoPreferenceSelected
                ? null
                : (value) {
                    setState(() {
                      bool currentIndex = _selectedItems[index];
                      if (_isToggleNeeded) {
                        _selectedItems = List.filled(widget.items.length, false);
                      }
                      _selectedItems[index] = !currentIndex;
                    });
                    if (widget.onTap != null)
                      widget.onTap(item, _selectedItems[index], _selectedItems);
                  });
      },
    );
  }
}
