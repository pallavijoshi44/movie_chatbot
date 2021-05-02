import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/src/domain/constants.dart';
import 'package:flutter_app/src/models/contentfiltering/entertainment_type.dart';
import 'package:flutter_app/src/models/contentfiltering/genre_content_type.dart';

import 'choice_chip_mobo.dart';

class ContentFilteringTags extends StatefulWidget {
  final List<EntertainmentContentType> entertainmentItems;
  final List<GenresContentType> movieGenreItems;
  final List<GenresContentType> tvGenreItems;
  final List<String> musicArtists;
  final List<String> watchProviders;
  final List<String> languages;
  final Function filterContents;

  ContentFilteringTags(
      {this.entertainmentItems,
      this.movieGenreItems,
      this.filterContents,
      this.tvGenreItems,
      this.musicArtists,
      this.watchProviders,
      this.languages});

  @override
  _ContentFilteringTagsState createState() => _ContentFilteringTagsState();
}

class _ContentFilteringTagsState extends State<ContentFilteringTags> {
  String _eventName;
  List<String> _genres;
  List<String> _musicArtists;
  List<String> _watchProviders;
  List<String> _languages;
  List<bool> _selectedMovieGenreItems;
  List<bool> _selectedTVGenreItems;
  List<bool> _selectedMusicArtists;
  List<bool> _selectedWatchProviders;
  List<bool> _selectedLanguages;
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

    if (widget.watchProviders != null && widget.watchProviders.isNotEmpty) {
      _selectedWatchProviders = List.filled(widget.watchProviders.length, true);
    }

    if (widget.musicArtists != null && widget.musicArtists.isNotEmpty) {
      _selectedMusicArtists = List.filled(widget.musicArtists.length, true);
    }

    if (widget.languages != null && widget.languages.isNotEmpty) {
      _selectedLanguages = List.filled(widget.languages.length, true);
    }

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

    _musicArtists =
        _createRequestFor(widget.musicArtists, _selectedMusicArtists);

    _watchProviders =
        _createRequestFor(widget.watchProviders, _selectedWatchProviders);

    _languages = _createRequestFor(widget.languages, _selectedLanguages);

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
    List<String> movieGenreItemValues =
        widget.movieGenreItems.map((e) => e.value).toList();
    List<String> entertainmentTypeValues =
        widget.entertainmentItems.map((e) => e.value).toList();
    List<String> tvGenreItemValues =
        widget.tvGenreItems.map((e) => e.value).toList();

    return Container(
      padding: EdgeInsets.all(15),
      child: Column(
        children: [
          _buildListView(entertainmentTypeValues, _selectedEntertainmentItems,
              (index, item) {
            setState(() {
              _selectedEntertainmentItems =
                  List.filled(widget.entertainmentItems.length, false);
              _selectedEntertainmentItems[index] = true;
              _isEntertainmentTypeMovie =
                  item == ENTERTAINMENT_CONTENT_TYPE_MOVIES;
              _eventName = _isEntertainmentTypeMovie
                  ? MOVIE_RECOMMENDATIONS_EVENT
                  : TV_RECOMMENDATIONS_EVENT;
              _selectedMusicArtists = _isEntertainmentTypeMovie
                  ? List.filled(widget.musicArtists.length, true)
                  : [];
              _musicArtists = _isEntertainmentTypeMovie
                  ? _createRequestFor(
                      widget.musicArtists, _selectedMusicArtists)
                  : [];
            });
          }),
          _isEntertainmentTypeMovie
              ? _buildListView(movieGenreItemValues, _selectedMovieGenreItems,
                  (index, item) async {
                  setState(() {
                    _selectedMovieGenreItems[index] =
                        !_selectedMovieGenreItems[index];

                    _genres = _createRequestFor(
                        movieGenreItemValues, _selectedMovieGenreItems);
                    _selectedTVGenreItems =
                        List.filled(widget.tvGenreItems.length, false);
                  });
                  await _fetchContent();
                })
              : _buildListView(tvGenreItemValues, _selectedTVGenreItems,
                  (index, item) async {
                  setState(() {
                    _selectedTVGenreItems[index] =
                        !_selectedTVGenreItems[index];
                    _genres = _createRequestFor(
                        tvGenreItemValues, _selectedTVGenreItems);
                    _selectedMovieGenreItems =
                        List.filled(widget.movieGenreItems.length, false);
                  });
                  await _fetchContent();
                }),
          if (_selectedMusicArtists != null && _selectedMusicArtists.isNotEmpty)
            _buildListView(widget.musicArtists, _selectedMusicArtists,
                (index, item) async {
              setState(() {
                _selectedMusicArtists[index] = !_selectedMusicArtists[index];
                _musicArtists = _createRequestFor(
                    widget.musicArtists, _selectedMusicArtists);
              });
              await _fetchContent();
            }),
          if (_selectedWatchProviders != null &&
              _selectedWatchProviders.isNotEmpty)
            _buildListView(widget.watchProviders, _selectedWatchProviders,
                (index, item) async {
              setState(() {
                _selectedWatchProviders[index] =
                    !_selectedWatchProviders[index];
                _watchProviders = _createRequestFor(
                    widget.watchProviders, _selectedWatchProviders);
              });
              await _fetchContent();
            }),
          if (_selectedLanguages != null && _selectedLanguages.isNotEmpty)
            _buildListView(widget.languages, _selectedLanguages,
                (index, item) async {
              setState(() {
                _selectedLanguages[index] = !_selectedLanguages[index];
                _languages =
                    _createRequestFor(widget.languages, _selectedLanguages);
              });
              await _fetchContent();
            })
        ],
      ),
    );
  }

  List<String> _createRequestFor(List<String> source, selectedItems) {
    var list = source.map((item) {
      if (selectedItems.elementAt(source.indexOf(item)) == true) return item;
    }).toList();
    list.removeWhere((value) => value == null);
    return list;
  }

  Widget _buildListView(source, List<bool> selectedItems, Function onTap) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: 40,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          controller: _scrollController,
          itemCount: source.length,
          itemBuilder: (ctx, index) {
            var item = source[index];
            return ChoiceChipMobo(
                isNoPreferenceSelected: false,
                label: item,
                selected: selectedItems[index],
                onSelected: (value) {
                  onTap.call(index, item);
                });
          },
        ));
  }

  Future _fetchContent() async {
    var parameters =
        "'parameters' : { "
        "${jsonEncode(KEY_GENRES)} :  ${jsonEncode(_genres)}, "
        "${jsonEncode(KEY_MUSIC_ARTIST)} : ${jsonEncode(_musicArtists)},"
        "${jsonEncode(KEY_WATCH_PROVIDER_ORIGINAL)} : ${jsonEncode(_watchProviders)},"
        "${jsonEncode(KEY_LANGUAGE)} : ${jsonEncode(_languages)},"
        "}";

    if (_isFetchContentNotTriggered) {
      _isFetchContentNotTriggered = false;
      await Future<void>.delayed(const Duration(milliseconds: 3000))
          .then((value) => widget.filterContents(_eventName, parameters));
    }
  }
}
