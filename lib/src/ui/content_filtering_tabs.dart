import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/src/domain/constants.dart';
import 'package:flutter_app/src/models/contentfiltering/entertainment_type.dart';
import 'package:flutter_app/src/models/contentfiltering/genre_content_type.dart';
import 'package:flutter_app/src/ui/multiselect/multi_select_chip_display.dart';

import 'choice_chip_mobo.dart';

class ContentFilteringTabs extends StatefulWidget {
  final List<EntertainmentContentType> entertainmentItems;
  final List<GenresContentType> genreTypes;
  final Function filterContents;

  ContentFilteringTabs(
      {this.entertainmentItems, this.genreTypes, this.filterContents});

  @override
  _ContentFilteringTabsState createState() => _ContentFilteringTabsState();
}

class _ContentFilteringTabsState extends State<ContentFilteringTabs> {
  final ScrollController _scrollController = ScrollController();
  List<bool> _selectedGenreItems = [];
  String _eventName;
  List<String> _genres;
  List<String> _genresContentItems;

  @override
  void initState() {
    // _genresContentItems = widget.genreTypes.map((e) => e.value).toList();

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

    _selectedGenreItems = widget.genreTypes.map((e) => e.selected).toList();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _genresContentItems = widget.genreTypes.map((e) => e.value).toList();

    return Container(
      padding: EdgeInsets.all(15),
      child: Column(
        children: [
          MultiSelectChipDisplay(
            items: widget.entertainmentItems.map((e) => e.value).toList(),
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
          Container(
            width: MediaQuery.of(context).size.width,
            height: 40,
            child: Scrollbar(
              controller: _scrollController,
              isAlwaysShown: false,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                controller: _scrollController,
                itemCount: _genresContentItems.length,
                itemBuilder: (ctx, index) {
                  var item = _genresContentItems[index];
                  return ChoiceChipMobo(
                      isNoPreferenceSelected: false,
                      label: item,
                      selected: _selectedGenreItems[index] ?? false,
                      onSelected: (value) {
                        setState(() {
                          _selectedGenreItems[index] = !_selectedGenreItems[index];
                          _genres = widget.genreTypes.map((item) {
                            if (_selectedGenreItems
                                .elementAt(widget.genreTypes.indexOf(item)) ==
                                true) return item.value;
                          }).toList();
                          _genres.removeWhere((value) => value == null);
                        });
                        var parameters =
                            "'parameters' : { 'genres' :  ${jsonEncode(_genres)}}";
                        return widget.filterContents(_eventName, parameters);
                      });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
