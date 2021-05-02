import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/src/domain/constants.dart';
import 'package:flutter_app/src/models/contentfiltering/content_filtering_parser.dart';
import 'package:flutter_app/src/models/contentfiltering/entertainment_type.dart';
import 'package:flutter_app/src/models/contentfiltering/genre_content_type.dart';

import 'choice_chip_mobo.dart';

class ContentFilteringTags extends StatefulWidget {
  final ContentFilteringParser response;
  final Function filterContents;

  ContentFilteringTags({this.response, this.filterContents});

  @override
  _ContentFilteringTagsState createState() => _ContentFilteringTagsState();
}

class _ContentFilteringTagsState extends State<ContentFilteringTags> {
  String _eventName;
  List<String> _genres;
  List<String> _musicArtists;
  List<String> _watchProviders;
  List<String> _watchProvidersOriginal;
  List<String> _languages;
  String _datePeriodOriginal;
  Map _datePeriod;
  String _customDatePeriod;

  List<bool> _selectedMovieGenreItems;
  List<bool> _selectedTVGenreItems;
  List<bool> _selectedMusicArtists;
  List<bool> _selectedWatchProviders;
  List<bool> _selectedWatchProvidersOriginal;
  List<bool> _selectedLanguages;
  List<bool> _selectedDatePeriodOriginal;
  List<bool> _selectedCustomDate;
  List<bool> _selectedEntertainmentItems;
  bool _isEntertainmentTypeMovie;
  bool _isFetchContentNotTriggered = true;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _selectedEntertainmentItems =
        widget.response.getEntertainmentTypes().map((e) => e.selected).toList();

    _selectedMovieGenreItems = widget.response
        .getMovieGenreContentType()
        .map((e) => e.selected)
        .toList();
    _selectedTVGenreItems =
        widget.response.getTVGenreItems().map((e) => e.selected).toList();

    if (widget.response.getWatchProvidersOriginal() != null &&
        widget.response.getWatchProvidersOriginal().isNotEmpty) {
      _selectedWatchProviders =
          List.filled(widget.response.getWatchProvidersOriginal().length, true);
    }

    if (widget.response.getMusicArtists() != null &&
        widget.response.getMusicArtists().isNotEmpty) {
      _selectedMusicArtists =
          List.filled(widget.response.getMusicArtists().length, true);
    }

    if (widget.response.getLanguages() != null &&
        widget.response.getLanguages().isNotEmpty) {
      _selectedLanguages =
          List.filled(widget.response.getLanguages().length, true);
    }

    if (widget.response.getDatePeriodOriginal() != null &&
        widget.response.getDatePeriodOriginal().isNotEmpty) {
      _selectedDatePeriodOriginal = [true];
    }
    if (widget.response.getWatchProvidersOriginal() != null &&
        widget.response.getWatchProvidersOriginal().isNotEmpty) {
      _selectedWatchProvidersOriginal =
          List.filled(widget.response.getWatchProvidersOriginal().length, true);
    }

    if (widget.response.getCustomDatePeriod() != null &&
        widget.response.getCustomDatePeriod().isNotEmpty) {
      _selectedCustomDate = [true];
    }

    EntertainmentContentType originalEntertainmentType = widget.response
        .getEntertainmentTypes()
        .firstWhere((e) => e.selected == true, orElse: () => null);

    _isEntertainmentTypeMovie =
        originalEntertainmentType.value == ENTERTAINMENT_CONTENT_TYPE_MOVIES;

    _eventName = _isEntertainmentTypeMovie
        ? MOVIE_RECOMMENDATIONS_EVENT
        : TV_RECOMMENDATIONS_EVENT;

    _genres = _isEntertainmentTypeMovie
        ? _createGenresForDialogflow(widget.response.getMovieGenreContentType())
        : _createGenresForDialogflow(widget.response.getTVGenreItems());

    _musicArtists = _createRequestFor(
        widget.response.getMusicArtists(), _selectedMusicArtists);

    _watchProviders = _createRequestFor(
        widget.response.getWatchProviders(), _selectedWatchProviders);

    _watchProvidersOriginal = _createRequestFor(
        widget.response.getWatchProvidersOriginal(),
        _selectedWatchProvidersOriginal);

    _languages =
        _createRequestFor(widget.response.getLanguages(), _selectedLanguages);

    _datePeriodOriginal = widget.response.getDatePeriodOriginal();
    _datePeriod = widget.response.getDatePeriod();
    _customDatePeriod = widget.response.getCustomDatePeriod();

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
        widget.response.getMovieGenreContentType().map((e) => e.value).toList();
    List<String> entertainmentTypeValues =
        widget.response.getEntertainmentTypes().map((e) => e.value).toList();
    List<String> tvGenreItemValues =
        widget.response.getTVGenreItems().map((e) => e.value).toList();

    return Container(
      padding: EdgeInsets.all(15),
      child: Column(
        children: [
          _buildListView(entertainmentTypeValues, _selectedEntertainmentItems,
              (index, item) {
            setState(() {
              _selectedEntertainmentItems = List.filled(
                  widget.response.getEntertainmentTypes().length, false);
              _selectedEntertainmentItems[index] = true;
              _isEntertainmentTypeMovie =
                  item == ENTERTAINMENT_CONTENT_TYPE_MOVIES;
              _eventName = _isEntertainmentTypeMovie
                  ? MOVIE_RECOMMENDATIONS_EVENT
                  : TV_RECOMMENDATIONS_EVENT;
              _selectedMusicArtists = _isEntertainmentTypeMovie
                  ? List.filled(widget.response.getMusicArtists().length, true)
                  : [];
              _musicArtists = _isEntertainmentTypeMovie
                  ? _createRequestFor(
                      widget.response.getMusicArtists(), _selectedMusicArtists)
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
                    _selectedTVGenreItems = List.filled(
                        widget.response.getTVGenreItems().length, false);
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
                    _selectedMovieGenreItems = List.filled(
                        widget.response.getMovieGenreContentType().length,
                        false);
                  });
                  await _fetchContent();
                }),
          if (_selectedMusicArtists != null && _selectedMusicArtists.isNotEmpty)
            _buildListView(
                widget.response.getMusicArtists(), _selectedMusicArtists,
                (index, item) async {
              setState(() {
                _selectedMusicArtists[index] = !_selectedMusicArtists[index];
                _musicArtists = _createRequestFor(
                    widget.response.getMusicArtists(), _selectedMusicArtists);
              });
              await _fetchContent();
            }),
          if (_selectedWatchProviders != null &&
              _selectedWatchProviders.isNotEmpty)
            _buildListView(widget.response.getWatchProvidersOriginal(),
                _selectedWatchProviders, (index, item) async {
              setState(() {
                _selectedWatchProviders[index] =
                    !_selectedWatchProviders[index];

                _selectedWatchProvidersOriginal[index] =
                    !_selectedWatchProvidersOriginal[index];

                _watchProviders = _createRequestFor(
                    widget.response.getWatchProviders(),
                    _selectedWatchProviders);

                _watchProvidersOriginal = _createRequestFor(
                    widget.response.getWatchProvidersOriginal(),
                    _selectedWatchProvidersOriginal);
              });
              await _fetchContent();
            }),
          if (_selectedLanguages != null && _selectedLanguages.isNotEmpty)
            _buildListView(widget.response.getLanguages(), _selectedLanguages,
                (index, item) async {
              setState(() {
                _selectedLanguages[index] = !_selectedLanguages[index];
                _languages = _createRequestFor(
                    widget.response.getLanguages(), _selectedLanguages);
              });
              await _fetchContent();
            }),
          if (_selectedDatePeriodOriginal != null &&
              _selectedDatePeriodOriginal.isNotEmpty)
            _buildListView([widget.response.getDatePeriodOriginal()],
                _selectedDatePeriodOriginal, (index, item) async {
              setState(() {
                _selectedDatePeriodOriginal[index] =
                    !_selectedDatePeriodOriginal[index];
                _datePeriodOriginal = _selectedDatePeriodOriginal[index]
                    ? _datePeriodOriginal
                    : "";
                _datePeriod =
                    _selectedDatePeriodOriginal[index] ? _datePeriod : "";
              });
              await _fetchContent();
            }),
          if (_selectedCustomDate != null && _selectedCustomDate.isNotEmpty)
            _buildListView(
                [widget.response.getCustomDatePeriod()], _selectedCustomDate,
                (index, item) async {
              setState(() {
                _selectedCustomDate[index] = !_selectedCustomDate[index];
                _customDatePeriod =
                    _selectedCustomDate[index] ? _customDatePeriod : "";
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
    var parameters = "'parameters' : { "
        "${jsonEncode(KEY_GENRES)} :  ${jsonEncode(_genres)}, "
        "${jsonEncode(KEY_MUSIC_ARTIST)} : ${jsonEncode(_musicArtists)},"
        "${jsonEncode(KEY_WATCH_PROVIDER)} : ${jsonEncode(_watchProviders)},"
        "${jsonEncode(KEY_WATCH_PROVIDER_ORIGINAL)} : ${jsonEncode(_watchProvidersOriginal)},"
        "${jsonEncode(KEY_LANGUAGE)} : ${jsonEncode(_languages)},"
        "${jsonEncode(KEY_DATE_PERIOD_ORIGINAL)} : ${jsonEncode(_datePeriodOriginal)},"
        "${jsonEncode(KEY_DATE_PERIOD)} : ${jsonEncode(_datePeriod ?? "")},"
        "${jsonEncode(KEY_CUSTOM_DATE_PERIOD)} : ${jsonEncode(_customDatePeriod)},"
        "}";

    if (_isFetchContentNotTriggered) {
      _isFetchContentNotTriggered = false;
      await Future<void>.delayed(const Duration(milliseconds: 3000))
          .then((value) => widget.filterContents(_eventName, parameters));
    }
  }
}
