import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/src/domain/constants.dart';
import 'package:flutter_app/src/models/contentfiltering/entertainment_type.dart';
import 'package:flutter_app/src/models/contentfiltering/genre_content_type.dart';
import 'package:flutter_app/src/ui/multiselect/multi_select_chip_display.dart';

class ContentFilteringTabs extends StatefulWidget {
  final List<EntertainmentContentType> entertainmentItems;
  final List<GenresContentType> genreTypes;
  final Function filterContents;
  final String eventName;

  ContentFilteringTabs(
      {this.entertainmentItems,
      this.genreTypes,
      this.filterContents,
      this.eventName});

  @override
  _ContentFilteringTabsState createState() => _ContentFilteringTabsState();
}

class _ContentFilteringTabsState extends State<ContentFilteringTabs> {
  String _eventName;
  List<String> _genres;

  @override
  void initState() {
    EntertainmentContentType originalEntertainmentType = widget
        .entertainmentItems
        .firstWhere((e) => e.selected == true, orElse: () => null);
    _eventName =
        originalEntertainmentType.value == ENTERTAINMENT_CONTENT_TYPE_MOVIES
            ? MOVIE_RECOMMENDATIONS_EVENT
            : TV_RECOMMENDATIONS_EVENT;

    _genres = widget.genreTypes.map((item) {
      if (item.selected) return item.value;
    }).toList();
    _genres.removeWhere((value) => value == null);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var entertainmentContentItems =
        widget.entertainmentItems.map((e) => e.value).toList();
    var genresContentItems = widget.genreTypes.map((e) => e.value).toList();

    // List<String> multiSelectList = [];
    // multiSelectList.addAll(entertainmentContentItems);
    // multiSelectList.addAll(genresContentItems);
    //
    // List<bool> initialSelectedItems = [];
    // initialSelectedItems
    //     .addAll(widget.entertainmentItems.map((e) => e.selected).toList());
    // initialSelectedItems
    //     .addAll(widget.genreTypes.map((e) => e.selected).toList());

    return Container(
      padding: EdgeInsets.all(15),
      child: Column(
        children: [
          MultiSelectChipDisplay(
            items: entertainmentContentItems,
            initialSelectedItems:
                widget.entertainmentItems.map((e) => e.selected).toList(),
            isToggleNeeded: true,
            onTap: (value, isSelected, selectedItems) {
              setState(() {
                _eventName = value == ENTERTAINMENT_CONTENT_TYPE_MOVIES
                    ? MOVIE_RECOMMENDATIONS_EVENT
                    : TV_RECOMMENDATIONS_EVENT;
              });

              return widget.filterContents(
                  _eventName, DEFAULT_PARAMETERS_FOR_EVENT);
            },
            containsNoPreference: false,
          ),
          MultiSelectChipDisplay(
            items: genresContentItems,
            initialSelectedItems:
                widget.genreTypes.map((e) => e.selected).toList(),
            isToggleNeeded: false,
            onTap: (value, isSelected, selectedItems) {
              setState(() {
                _genres = widget.genreTypes.map((item) {
                  if (selectedItems
                          .elementAt(widget.genreTypes.indexOf(item)) ==
                      true) return item.value;
                }).toList();
                _genres.removeWhere((value) => value == null);
              });
              // 'parameters': {'id': '$id', 'country_code': '$countryCode'}
              var parameters =
                  "'parameters' : { 'genres' :  ${jsonEncode(_genres)}}";
              return widget.filterContents(_eventName, parameters);
            },
            containsNoPreference: false,
          ),
        ],
      ),
    );
  }
}
