import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/src/domain/constants.dart';
import 'package:flutter_app/src/models/content_filtering_tabs_model.dart';
import 'package:flutter_app/src/ui/multiselect/multi_select_chip_display.dart';

class ContentFilteringTabs extends StatefulWidget {
  final List<EntertainmentContentType> entertainmentItems;
  final Function filterContents;

  ContentFilteringTabs({this.entertainmentItems, this.filterContents});

  @override
  _ContentFilteringTabsState createState() => _ContentFilteringTabsState();
}

class _ContentFilteringTabsState extends State<ContentFilteringTabs> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var entertainmentContentItems =
    widget.entertainmentItems.map((e) => e.value).toList();

    return Container(
      padding: EdgeInsets.all(15),
      child: MultiSelectChipDisplay(
        items: entertainmentContentItems,
        initialSelectedItems: widget.entertainmentItems.map((e) => e.selected)
            .toList(),
        isToggleNeeded: true,
        onTap: (value, isSelected, selectedItems) {
          // 'parameters': {'id': '$id', 'country_code': '$countryCode'}
          // var params = "'parameters' : {  }";
          var eventName = value == ENTERTAINMENT_CONTENT_TYPE_MOVIES
              ? MOVIE_RECOMMENDATIONS_EVENT
              : TV_RECOMMENDATIONS_EVENT;

          return widget.filterContents(eventName, DEFAULT_PARAMETERS_FOR_EVENT);
        },
        containsNoPreference: false,
      ),
    );
  }
}
