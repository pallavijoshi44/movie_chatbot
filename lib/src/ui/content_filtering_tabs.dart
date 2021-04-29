import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/src/models/content_filtering_tabs_model.dart';
import 'package:flutter_app/src/ui/multiselect/multi_select_chip_display.dart';

class ContentFilteringTabs extends StatelessWidget {
  final List<EntertainmentContentType> entertainmentItems;
  final Function filterContents;

  ContentFilteringTabs({this.entertainmentItems, this.filterContents});

  @override
  Widget build(BuildContext context) {
    var entertainmentContentItems = entertainmentItems.map((e) => e.value)
        .toList();

    return Container(
      padding: EdgeInsets.all(15),
      child: MultiSelectChipDisplay(
        items: entertainmentContentItems,
        initialSelectedItems: entertainmentItems.map((e) => e.selected).toList(),
        onTap: filterContents,
        containsNoPreference: false,
      ),
    );
  }
}
