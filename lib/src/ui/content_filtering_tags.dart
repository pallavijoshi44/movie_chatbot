import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/src/domain/constants.dart';
import 'package:flutter_app/src/models/contentfiltering/content_filtering_parser.dart';
import 'package:flutter_app/src/models/contentfiltering/entertainment_type.dart';
import 'package:flutter_app/src/models/contentfiltering/genre_content_type.dart';
import 'package:flutter_app/src/models/settings_model.dart';

class ContentFilteringTags extends StatefulWidget {
  final ContentFilteringParser response;
  final Function filterContents;
  final Function showPlaceHolderInCarousel;
  final SettingsModel settingsModel;

  ContentFilteringTags({
    this.response,
    this.filterContents,
    this.showPlaceHolderInCarousel,
    this.settingsModel
  });

  @override
  ContentFilteringTagsState createState() => ContentFilteringTagsState();
}

class ContentFilteringTagsState extends State<ContentFilteringTags> {
  ContentFilteringParser _response;
  Timer _clickTimer;
  String _eventName;
  List<String> _genres;
  List<String> _musicArtists;
  List<String> _watchProviders;
  List<String> _watchProvidersOriginal;
  List<String> _searchKeywords;
  List<String> _searchKeywordsOriginal;
  List<String> _languages;
  String _datePeriodOriginal;
  Map _datePeriod;
  String _customDatePeriod;
  String _shortMovie;
  String _likePhrases;
  String _countryCode;
  String _sortBy;
  String _movieOrTvId;

  List<bool> _selectedMovieGenreItems;
  List<bool> _selectedTVGenreItems;
  List<bool> _selectedMusicArtists;
  List<bool> _selectedWatchProviders;
  List<bool> _selectedWatchProvidersOriginal;
  List<bool> _selectedSearchKeywords;
  List<bool> _selectedSearchKeywordsOriginal;
  List<bool> _selectedEntertainmentItems;
  List<bool> _selectedLanguages;
  bool _selectedDatePeriodOriginal;
  bool _selectedCustomDate;
  bool _selectedShortMovie;
  bool _isEntertainmentTypeMovie;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _initialize();
    super.initState();
  }

  void _initialize() {
    _response = widget.response;
    _initializeEntertainmentType();
    _initializeGenreItems();
    _initializeMusicArtists();
    _initializeWatchProviders();
    _initializeLanguages();
    _initializeDatePeriod();
    _initializeSearchKeywords();
    _initializeShortMovie();
    _initializeOthers();
  }

  void _initializeDatePeriod() {
    if (_response.getDatePeriodOriginal() != null &&
        _response.getDatePeriodOriginal().isNotEmpty) {
      _selectedDatePeriodOriginal = true;
    }

    if (_response.getCustomDatePeriod() != null &&
        _response.getCustomDatePeriod().isNotEmpty) {
      _selectedCustomDate = true;
    }
    _datePeriodOriginal = _response.getDatePeriodOriginal();
    _datePeriod = _response.getDatePeriod();
    _customDatePeriod = _response.getCustomDatePeriod();
  }

  void _initializeShortMovie() {
    if (_response.getShortMovie() != null &&
        _response.getShortMovie().isNotEmpty) {
      _selectedShortMovie = true;
    }
    _shortMovie = _response.getShortMovie();
  }

  void _initializeLanguages() {
    if (_response.getLanguages() != null &&
        _response.getLanguages().isNotEmpty) {
      _selectedLanguages = List.filled(_response.getLanguages().length, true);
    }

    _languages =
        _createRequestFor(_response.getLanguages(), _selectedLanguages);
  }

  void _initializeOthers() {
    _likePhrases = _response.getLikePhrases();
    _countryCode = _response.getCountryCode();
    _sortBy = _response.getSortBy();
    _movieOrTvId = _response.getMovieOrTvId();
  }

  void _initializeWatchProviders() {
    if (_response.getWatchProvidersOriginal() != null &&
        _response.getWatchProvidersOriginal().isNotEmpty) {
      _selectedWatchProviders =
          List.filled(_response.getWatchProvidersOriginal().length, true);
    }
    if (_response.getWatchProvidersOriginal() != null &&
        _response.getWatchProvidersOriginal().isNotEmpty) {
      _selectedWatchProvidersOriginal =
          List.filled(_response.getWatchProvidersOriginal().length, true);
    }

    _watchProviders = _createRequestFor(
        _response.getWatchProviders(), _selectedWatchProviders);

    _watchProvidersOriginal = _createRequestFor(
        _response.getWatchProvidersOriginal(), _selectedWatchProvidersOriginal);
  }

  void _initializeSearchKeywords() {
    if (_response.getSearchKeywords() != null &&
        _response.getSearchKeywords().isNotEmpty) {
      _selectedSearchKeywords =
          List.filled(_response.getSearchKeywords().length, true);
    }
    if (_response.getSearchKeywordsOriginal() != null &&
        _response.getSearchKeywordsOriginal().isNotEmpty) {
      _selectedSearchKeywordsOriginal =
          List.filled(_response.getSearchKeywordsOriginal().length, true);
    }

    _searchKeywords = _createRequestFor(
        _response.getSearchKeywords(), _selectedSearchKeywords);

    _searchKeywordsOriginal = _createRequestFor(
        _response.getSearchKeywordsOriginal(), _selectedSearchKeywordsOriginal);
  }

  void _initializeMusicArtists() {
    if (_response.getMusicArtists() != null &&
        _response.getMusicArtists().isNotEmpty) {
      _selectedMusicArtists =
          List.filled(_response.getMusicArtists().length, true);
    }

    _musicArtists =
        _createRequestFor(_response.getMusicArtists(), _selectedMusicArtists);
  }

  void _initializeGenreItems() {
    _selectedMovieGenreItems =
        _response.getMovieGenreContentType().map((e) => e.selected).toList();
    _selectedTVGenreItems =
        _response.getTVGenreItems().map((e) => e.selected).toList();

    _genres = _isEntertainmentTypeMovie
        ? _createGenresForDialogflow(_response.getMovieGenreContentType())
        : _createGenresForDialogflow(_response.getTVGenreItems());
  }

  void _initializeEntertainmentType() {
    _selectedEntertainmentItems =
        _response.getEntertainmentTypes().map((e) => e.selected).toList();

    EntertainmentContentType originalEntertainmentType = _response
        .getEntertainmentTypes()
        .firstWhere((e) => e.selected == true, orElse: () => null);

    _isEntertainmentTypeMovie =
        originalEntertainmentType.value == ENTERTAINMENT_CONTENT_TYPE_MOVIES;

    _eventName = _isEntertainmentTypeMovie
        ? MOVIE_RECOMMENDATIONS_EVENT
        : TV_RECOMMENDATIONS_EVENT;
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
        _response.getMovieGenreContentType().map((e) => e.value).toList();
    List<String> entertainmentTypeValues =
        _response.getEntertainmentTypes().map((e) => e.value).toList();
    List<String> tvGenreItemValues =
        _response.getTVGenreItems().map((e) => e.value).toList();

    return Container(
      padding: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildListView(entertainmentTypeValues, _selectedEntertainmentItems,
              (item) async {
            setState(() {
              _selectedEntertainmentItems =
                  List.filled(_response.getEntertainmentTypes().length, false);
              _selectedEntertainmentItems[
                  entertainmentTypeValues.indexOf(item)] = true;
              _isEntertainmentTypeMovie =
                  item == ENTERTAINMENT_CONTENT_TYPE_MOVIES;
              _eventName = _isEntertainmentTypeMovie
                  ? MOVIE_RECOMMENDATIONS_EVENT
                  : TV_RECOMMENDATIONS_EVENT;
              _selectedMusicArtists = _isEntertainmentTypeMovie
                  ? List.filled(_response.getMusicArtists().length, true)
                  : [];
              _musicArtists = _isEntertainmentTypeMovie
                  ? _createRequestFor(
                      _response.getMusicArtists(), _selectedMusicArtists)
                  : [];
            });
            await _fetchContent();
          }),
          if (_isEntertainmentTypeMovie)
            _buildListView(movieGenreItemValues, _selectedMovieGenreItems,
                (item) async {
              setState(() {
                _selectedMovieGenreItems[movieGenreItemValues.indexOf(item)] =
                    !_selectedMovieGenreItems[
                        movieGenreItemValues.indexOf(item)];

                _genres = _createRequestFor(
                    movieGenreItemValues, _selectedMovieGenreItems);
                _selectedTVGenreItems =
                    List.filled(_response.getTVGenreItems().length, false);
              });
              await _fetchContent();
            }),
          if (!_isEntertainmentTypeMovie)
            _buildListView(tvGenreItemValues, _selectedTVGenreItems,
                (item) async {
              setState(() {
                _selectedTVGenreItems[tvGenreItemValues.indexOf(item)] =
                    !_selectedTVGenreItems[tvGenreItemValues.indexOf(item)];
                _genres =
                    _createRequestFor(tvGenreItemValues, _selectedTVGenreItems);
                _selectedMovieGenreItems = List.filled(
                    _response.getMovieGenreContentType().length, false);
              });
              await _fetchContent();
            }),
          Wrap(
            alignment: WrapAlignment.start,
            spacing: 5,
            runSpacing: 5,
            direction: Axis.horizontal,
            children: <Widget>[
              if (_selectedMusicArtists != null &&
                  _selectedMusicArtists.isNotEmpty)
                ..._response.getMusicArtists().map((item) {
                  var index = _response.getMusicArtists().indexOf(item);
                  return _buildChip(item, _selectedMusicArtists[index],
                      (item) async {
                    setState(() {
                      _selectedMusicArtists[index] =
                          !_selectedMusicArtists[index];
                      _musicArtists = _createRequestFor(
                          _response.getMusicArtists(), _selectedMusicArtists);
                    });
                    await _fetchContent();
                  });
                }).toList(),
              if (_selectedWatchProviders != null &&
                  _selectedWatchProviders.isNotEmpty)
                ..._response.getWatchProvidersOriginal().map((item) {
                  var index =
                      _response.getWatchProvidersOriginal().indexOf(item);
                  return _buildChip(item, _selectedWatchProviders[index],
                      (item) async {
                    setState(() {
                      _selectedWatchProviders[index] =
                          !_selectedWatchProviders[index];

                      _selectedWatchProvidersOriginal[index] =
                          !_selectedWatchProvidersOriginal[index];

                      _watchProviders = _createRequestFor(
                          _response.getWatchProviders(),
                          _selectedWatchProviders);

                      _watchProvidersOriginal = _createRequestFor(
                          _response.getWatchProvidersOriginal(),
                          _selectedWatchProvidersOriginal);
                    });
                    await _fetchContent();
                  });
                }).toList(),
              if (_selectedSearchKeywords != null &&
                  _selectedSearchKeywords.isNotEmpty)
                ..._response.getSearchKeywordsOriginal().map((item) {
                  var index =
                      _response.getSearchKeywordsOriginal().indexOf(item);
                  return _buildChip(item, _selectedSearchKeywords[index],
                      (item) async {
                    setState(() {
                      _selectedSearchKeywords[index] =
                          !_selectedSearchKeywords[index];

                      _selectedSearchKeywordsOriginal[index] =
                          !_selectedSearchKeywordsOriginal[index];

                      _searchKeywords = _createRequestFor(
                          _response.getSearchKeywords(),
                          _selectedSearchKeywords);

                      _searchKeywordsOriginal = _createRequestFor(
                          _response.getSearchKeywordsOriginal(),
                          _selectedSearchKeywordsOriginal);
                    });
                    await _fetchContent();
                  });
                }).toList(),
              if (_selectedLanguages != null && _selectedLanguages.isNotEmpty)
                ..._response.getLanguages().map((item) {
                  var index = _response.getLanguages().indexOf(item);
                  return _buildChip(item, _selectedLanguages[index],
                      (item) async {
                    setState(() {
                      _selectedLanguages[index] = !_selectedLanguages[index];
                      _languages = _createRequestFor(
                          _response.getLanguages(), _selectedLanguages);
                    });
                    await _fetchContent();
                  });
                }).toList(),
              if (_selectedDatePeriodOriginal != null)
                _buildChip(_response.getDatePeriodOriginal(),
                    _selectedDatePeriodOriginal, (item) async {
                  setState(() {
                    _selectedDatePeriodOriginal = !_selectedDatePeriodOriginal;
                    _datePeriodOriginal =
                        _selectedDatePeriodOriginal ? _datePeriodOriginal : "";
                    // _datePeriod =
                    //     _selectedDatePeriodOriginal ? _datePeriod : "";
                  });
                  await _fetchContent();
                }),
              if (_selectedCustomDate != null)
                _buildChip(_response.getCustomDatePeriod(), _selectedCustomDate,
                    (item) async {
                  setState(() {
                    _selectedCustomDate = !_selectedCustomDate;
                    _customDatePeriod =
                        _selectedCustomDate ? _customDatePeriod : "";
                  });
                  await _fetchContent();
                }),
              if (_selectedShortMovie != null)
                _buildChip(_response.getShortMovie(), _selectedShortMovie,
                    (item) async {
                  setState(() {
                    _selectedShortMovie = !_selectedShortMovie;
                    _shortMovie = _selectedShortMovie ? _shortMovie : "";
                  });
                  await _fetchContent();
                })
            ],
          ),
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
            return Container(
                margin: EdgeInsets.only(right: 5),
                child: _buildChip(item, selectedItems[index], onTap));
          },
        ));
  }

  Widget _buildChip(String item, bool selectedItem, Function onTap) {
    return Container(
      height: 40,
      child: Material(
        child: FilterChip(
            backgroundColor: Color.fromRGBO(249, 248, 235, 1),
            disabledColor: Colors.lightGreen[100],
            label: Text(item,
                style: TextStyle(fontFamily: 'QuickSand', fontSize: 14)),
            labelStyle: TextStyle(color: Colors.lightGreen[900]),
            shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.lightGreen[900]),
                borderRadius: BorderRadius.all(Radius.circular(15))),
            selected: selectedItem,
            checkmarkColor: Colors.green,
            selectedColor: Colors.lightGreen[100],
            onSelected: (value) {
              onTap.call(item);
            }),
      ),
    );
  }

  Future _fetchContent() async {
    var datePeriod =
        _selectedDatePeriodOriginal != null && _selectedDatePeriodOriginal
            ? jsonEncode(_datePeriod)
            : jsonEncode("");
    var parameters = "'parameters' : { "
        "${jsonEncode(KEY_GENRES)} :  ${jsonEncode(_genres)}, "
        "${jsonEncode(KEY_MUSIC_ARTIST)} : ${jsonEncode(_musicArtists)},"
        "${jsonEncode(KEY_WATCH_PROVIDER)} : ${jsonEncode(_watchProviders)},"
        "${jsonEncode(KEY_WATCH_PROVIDER_ORIGINAL)} : ${jsonEncode(_watchProvidersOriginal)},"
        "${jsonEncode(KEY_LANGUAGE)} : ${jsonEncode(_languages)},"
        "${jsonEncode(KEY_DATE_PERIOD_ORIGINAL)} : ${jsonEncode(_datePeriodOriginal)},"
        "${jsonEncode(KEY_DATE_PERIOD)} : $datePeriod,"
        "${jsonEncode(KEY_CUSTOM_DATE_PERIOD)} : ${jsonEncode(_customDatePeriod)},"
        "${jsonEncode(KEY_SEARCH_KEYWORD)} : ${jsonEncode(_searchKeywords)},"
        "${jsonEncode(KEY_SEARCH_KEYWORD_ORIGINAL)} : ${jsonEncode(_searchKeywordsOriginal)},"
        "${jsonEncode(KEY_SHORT_MOVIE)} : ${jsonEncode(_shortMovie)},"
        "${jsonEncode(KEY_PAGE_NUMBER)} : ${jsonEncode(1)},"
        "${jsonEncode(KEY_LIKE_PHRASES)} : ${jsonEncode(_likePhrases)},"
        "${jsonEncode(KEY_SORT_BY)} : ${jsonEncode(_sortBy)},"
        "${jsonEncode(KEY_COUNTRY_CODE)} : ${jsonEncode(widget.settingsModel.countryCode.getValue())},"
        "${jsonEncode(KEY_MOVIE_OR_TV_ID)} : ${jsonEncode(_movieOrTvId)},"
        "}";
    _stopClickTimer();
    _startClickTimer(parameters);
    widget.showPlaceHolderInCarousel();
  }

  void _stopClickTimer() {
    if (_clickTimer != null) {
      _clickTimer.cancel();
      _clickTimer = null;
    }
  }

  void _startClickTimer(String parameters) {
    _clickTimer =
        new Timer(Duration(seconds: CONTENT_FILTERING_DURATION_SECONDS), () {
      widget.filterContents(_eventName, parameters);
    });
  }

  @override
  void dispose() {
    _stopClickTimer();
    super.dispose();
  }

  void updateFilteringTags(ContentFilteringParser response) {
    setState(() {
      _initialize();
    });
  }
}
