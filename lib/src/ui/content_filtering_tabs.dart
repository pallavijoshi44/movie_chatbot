import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/src/ui/multiselect/multi_select_chip_display.dart';

class ContentFilteringTabs extends StatelessWidget {
  final List<String> items;
  final Function filterContents;

  ContentFilteringTabs({this.items, this.filterContents});

  @override
  Widget build(BuildContext context) {
    return MultiSelectChipDisplay(
      items: items,
      onTap: filterContents,
      containsNoPreference: false,
    );
  }
}
