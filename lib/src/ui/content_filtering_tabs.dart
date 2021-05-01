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
  List<String> _movieGenres;
  List<String> _tvGenres;
  List<bool> _selectedMovieGenreItems;
  List<bool> _selectedTVGenreItems;
  List<bool> _selectedEntertainmentItems;
  bool _isEntertainmentTypeMovie;
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

    _movieGenres = _createGenresForDialogflow(widget.movieGenreItems);
    _tvGenres = _createGenresForDialogflow(widget.tvGenreItems);
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
                          selected: item.selected,
                          onSelected: (value) {
                            setState(() {
                              _selectedMovieGenreItems[index] =
                                  !_selectedMovieGenreItems[index];
                              _movieGenres = widget.movieGenreItems.map((item) {
                                if (_selectedMovieGenreItems.elementAt(
                                        widget.movieGenreItems.indexOf(item)) ==
                                    true) return item.value;
                              }).toList();

                              _movieGenres
                                  .removeWhere((value) => value == null);
                              _selectedTVGenreItems = List.filled(
                                  widget.tvGenreItems.length, false);
                            });
                            var parameters =
                                "'parameters' : { 'genres' :  ${jsonEncode(_movieGenres)}}";
                            return widget.filterContents(
                                _eventName, parameters);
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
                          onSelected: (value) {
                            setState(() {
                              _selectedTVGenreItems[index] =
                                  !_selectedTVGenreItems[index];
                              _tvGenres = widget.tvGenreItems.map((item) {
                                if (_selectedTVGenreItems.elementAt(
                                        widget.tvGenreItems.indexOf(item)) ==
                                    true) return item.value;
                              }).toList();
                              _tvGenres.removeWhere((value) => value == null);
                              _selectedMovieGenreItems = List.filled(
                                  widget.movieGenreItems.length, false);
                            });
                            var parameters =
                                "'parameters' : { 'genres' :  ${jsonEncode(_tvGenres)}}";
                            return widget.filterContents(
                                _eventName, parameters);
                          });
                    },
                  ),
                )
        ],
      ),
    );
  }
}
