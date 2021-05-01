import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/src/domain/constants.dart';
import 'package:flutter_app/src/models/contentfiltering/entertainment_type.dart';
import 'package:flutter_app/src/models/contentfiltering/genre_content_type.dart';

import 'choice_chip_mobo.dart';

class ContentFilteringTabs extends StatefulWidget {
  final List<EntertainmentContentType> entertainmentItems;
  final List<GenresContentType> movieGenreItems;
  final List<GenresContentType> tvGenreItems;
  final Function filterContents;

  ContentFilteringTabs(
      {this.entertainmentItems,
      this.movieGenreItems,
      this.filterContents,
      this.tvGenreItems});

  @override
  _ContentFilteringTabsState createState() => _ContentFilteringTabsState();
}

class _ContentFilteringTabsState extends State<ContentFilteringTabs> {
  String _eventName;
  List<String> _genres;
  List<bool> _selectedMovieGenreItems;
  List<bool> _selectedTVGenreItems;
  List<bool> _selectedEntertainmentItems;
  bool _isEntertainmentTypeMovie;
  bool _isFetchContentNotTriggered = true;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _selectedEntertainmentItems =
        widget.entertainmentItems.map((e) => e.selected).toList();

    _selectedMovieGenreItems =
        widget.movieGenreItems.map((e) => e.selected).toList();
    _selectedTVGenreItems = widget.tvGenreItems.map((e) => e.selected).toList();
    EntertainmentContentType originalEntertainmentType = widget
        .entertainmentItems
        .firstWhere((e) => e.selected == true, orElse: () => null);

    _isEntertainmentTypeMovie =
        originalEntertainmentType.value == ENTERTAINMENT_CONTENT_TYPE_MOVIES;

    _eventName = _isEntertainmentTypeMovie
        ? MOVIE_RECOMMENDATIONS_EVENT
        : TV_RECOMMENDATIONS_EVENT;

    _genres = _isEntertainmentTypeMovie
        ? _createGenresForDialogflow(widget.movieGenreItems)
        : _createGenresForDialogflow(widget.tvGenreItems);

    super.initState();
  }

  List<String> _createGenresForDialogflow(List<GenresContentType> source) {
    var list = source.map((item) {
      if (item.selected) return item.value;
    }).toList();
    list.removeWhere((value) => value == null);
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              controller: _scrollController,
              itemCount: widget.entertainmentItems.length,
              itemBuilder: (ctx, index) {
                var item = widget.entertainmentItems[index];
                return ChoiceChipMobo(
                    isNoPreferenceSelected: false,
                    label: item.value,
                    selected: _selectedEntertainmentItems[index],
                    onSelected: (value) {
                      setState(() {
                        _selectedEntertainmentItems = List.filled(
                            widget.entertainmentItems.length, false);
                        _selectedEntertainmentItems[index] = true;
                        _isEntertainmentTypeMovie =
                            item.value == ENTERTAINMENT_CONTENT_TYPE_MOVIES;
                        _eventName = _isEntertainmentTypeMovie
                            ? MOVIE_RECOMMENDATIONS_EVENT
                            : TV_RECOMMENDATIONS_EVENT;
                      });
                    });
              },
            ),
          ),
          _isEntertainmentTypeMovie
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    controller: _scrollController,
                    itemCount: widget.movieGenreItems.length,
                    itemBuilder: (ctx, index) {
                      var item = widget.movieGenreItems[index];
                      return ChoiceChipMobo(
                          isNoPreferenceSelected: false,
                          label: item.value,
                          selected: _selectedMovieGenreItems[index],
                          onSelected: (value) async {
                            setState(() {
                              _selectedMovieGenreItems[index] =
                                  !_selectedMovieGenreItems[index];
                              _genres = widget.movieGenreItems.map((item) {
                                if (_selectedMovieGenreItems.elementAt(
                                        widget.movieGenreItems.indexOf(item)) ==
                                    true) return item.value;
                              }).toList();

                              _genres.removeWhere((value) => value == null);
                              _selectedTVGenreItems = List.filled(
                                  widget.tvGenreItems.length, false);
                            });
                            await _fetchContent();
                          });
                    },
                  ),
                )
              : Container(
                  width: MediaQuery.of(context).size.width,
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    controller: _scrollController,
                    itemCount: widget.tvGenreItems.length,
                    itemBuilder: (ctx, index) {
                      var item = widget.tvGenreItems[index];
                      return ChoiceChipMobo(
                          isNoPreferenceSelected: false,
                          label: item.value,
                          selected: _selectedTVGenreItems[index],
                          onSelected: (value) async {
                            setState(() {
                              _selectedTVGenreItems[index] =
                                  !_selectedTVGenreItems[index];
                              _genres = widget.tvGenreItems.map((item) {
                                if (_selectedTVGenreItems.elementAt(
                                        widget.tvGenreItems.indexOf(item)) ==
                                    true) return item.value;
                              }).toList();
                              _genres.removeWhere((value) => value == null);
                              _selectedMovieGenreItems = List.filled(
                                  widget.movieGenreItems.length, false);
                            });
                            await _fetchContent();
                          });
                    },
                  ),
                )
        ],
      ),
    );
  }

  Future _fetchContent() async {
    var parameters = "'parameters' : { 'genres' :  ${jsonEncode(_genres)}}";

    if (_isFetchContentNotTriggered) {
      _isFetchContentNotTriggered = false;
      await Future<void>.delayed(const Duration(milliseconds: 3000))
          .then((value) => widget.filterContents(_eventName, parameters));
    }
  }
}
