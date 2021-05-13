import 'package:flutter_app/src/domain/ai_response.dart';
import 'package:flutter_app/src/domain/constants.dart';
import 'package:flutter_app/src/models/settings_model.dart';

import 'entertainment_type.dart';
import 'genre_content_type.dart';

class ContentFilteringParser {
  final AIResponse response;
  final SettingsModel settings;
  List<EntertainmentContentType> _entertainmentTypes;
  List<GenresContentType> _movieGenreItems = [];
  List<GenresContentType> _tvGenreItems = [];
  List<String> _musicArtists = [];
  List<String> _watchProviders = [];
  List<String> _watchProvidersOriginal = [];
  List<String> _searchKeywords = [];
  List<String> _searchKeywordsOriginal = [];
  List<String> _languages = [];
  Map _datePeriod;
  String _datePeriodOriginal = "";
  String _customDatePeriod = "";
  String _short = "";
  String _likePhrases = "";
  String _sortyBy = "";
  String _movieOrTvId = "";

  ContentFilteringParser({this.response, this.settings}) {
    var parameters = response.getParameters();
    bool isMovie =
        response.getEntertainmentContentType() == EntertainmentType.MOVIE;

    _constructEntertainmentType(isMovie);
    _constructGenres(parameters, isMovie);
    _constructLanguages(parameters);
    _constructMusicArtists(parameters);
    _constructWatchProviders(parameters);
    _constructDatePeriod(parameters);
    _constructCustomDate(parameters);
    _constructSearchKeywords(parameters);
    _constructShort(parameters);
    _constructOthers(parameters);
  }


  void _constructDatePeriod(Map parameters) {
    if (_isValidKey(parameters, KEY_DATE_PERIOD)) {
      _datePeriod = parameters[KEY_DATE_PERIOD];
      _datePeriodOriginal = parameters[KEY_DATE_PERIOD_ORIGINAL];
      return;
    }
  }

  void _constructCustomDate(Map parameters) {
    if (_isValidKey(parameters, KEY_CUSTOM_DATE_PERIOD)) {
      _customDatePeriod = parameters[KEY_CUSTOM_DATE_PERIOD];
      return;
    }
  }

  void _constructShort(Map parameters) {
    _initializeKey(_short, KEY_SHORT_MOVIE, parameters);
  }

  void _constructOthers(Map parameters) {
    _initializeKey(_likePhrases, KEY_LIKE_PHRASES, parameters);
    _initializeKey(_sortyBy, KEY_LIKE_PHRASES, parameters);
    _initializeKey(_movieOrTvId, KEY_MOVIE_OR_TV_ID, parameters);
  }

  void _initializeKey(String key, String value, Map parameters) {
    if (_isValidKey(parameters, key)) {
      value = parameters[key];
      return;
    } else {
      value = "";
    }
  }

  bool _isValidKey(Map parameters, String key) {
    return parameters != null &&
        parameters[key] != null &&
        parameters[key].isNotEmpty;
  }

  void _constructLanguages(Map parameters) {
    if (isValidList(parameters, KEY_LANGUAGE)) {
      List<dynamic> list = parameters[KEY_LANGUAGE];
      list.forEach((element) {
        _languages.add(element);
      });
    } else {
      _languages = [];
    }
  }

  void _constructMusicArtists(Map parameters) {
    if (isValidList(parameters, KEY_MUSIC_ARTIST)) {
      List<dynamic> list = parameters[KEY_MUSIC_ARTIST];
      list.forEach((element) {
        _musicArtists.add(element);
      });
    } else {
      _musicArtists = [];
    }
  }

  void _constructWatchProviders(Map parameters) {
    if (isValidList(parameters, KEY_WATCH_PROVIDER_ORIGINAL)) {
      List<dynamic> list = parameters[KEY_WATCH_PROVIDER_ORIGINAL];
      List<dynamic> listIds = parameters[KEY_WATCH_PROVIDER];
      list.forEach((element) {
        _watchProvidersOriginal.add(element);
        _watchProviders.add(listIds[list.indexOf(element)]);
      });
    } else {
      _watchProviders = [];
      _watchProvidersOriginal = [];
    }
  }

  void _constructSearchKeywords(Map parameters) {
    if (isValidList(parameters, KEY_SEARCH_KEYWORD_ORIGINAL)) {
      List<dynamic> list = parameters[KEY_SEARCH_KEYWORD_ORIGINAL];
      List<dynamic> listIds = parameters[KEY_SEARCH_KEYWORD];
      list.forEach((element) {
        _searchKeywordsOriginal.add(element);
        _searchKeywords.add(listIds[list.indexOf(element)]);
      });
    } else {
      _searchKeywords = [];
      _searchKeywordsOriginal = [];
    }
  }

  void _constructGenres(Map parameters, bool isMovie) {
    _movieGenreItems = [];
    _tvGenreItems = [];
    _musicArtists = [];

    List<String> list1 = isMovie
        ? GenresContentType.movieGenresGroup1
        : GenresContentType.tvGenresGroup1;
    List<String> list2 = isMovie
        ? GenresContentType.movieGenresGroup2
        : GenresContentType.tvGenresGroup2;
    List<String> list3 = isMovie
        ? GenresContentType.movieGenresGroup3
        : GenresContentType.tvGenresGroup3;
    List<String> list4 = isMovie
        ? GenresContentType.movieGenresGroup4
        : GenresContentType.tvGenresGroup4;
    List<String> list5 = isMovie
        ? GenresContentType.movieGenresGroup5
        : GenresContentType.tvGenresGroup5;

    if (isValidList(parameters, 'genres')) {
      List<dynamic> selectedGenres = parameters['genres'];
      selectedGenres.forEach((genre) {
        if (list1.contains(genre)) {
          if (isMovie) {
            _constructGenreGroups(GenresContentType.movieGenresGroup1, genre,
                GenresContentType.tvMovieGroup1);
          } else {
            _constructGenreGroupsForTV(GenresContentType.tvGenresGroup1, genre,
                GenresContentType.movieTvGroup1);
          }
          return;
        }
        if (list2.contains(genre)) {
          if (isMovie) {
            _constructGenreGroups(GenresContentType.movieGenresGroup2, genre,
                GenresContentType.tvMovieGroup2);
          } else {
            _constructGenreGroupsForTV(GenresContentType.tvGenresGroup2, genre,
                GenresContentType.movieTvGroup2);
          }
          return;
        }
        if (list3.contains(genre)) {
          if (isMovie) {
            _constructGenreGroups(GenresContentType.movieGenresGroup3, genre,
                GenresContentType.tvMovieGroup3);
          } else {
            _constructGenreGroupsForTV(GenresContentType.tvGenresGroup3, genre,
                GenresContentType.movieTvGroup3);
          }
          return;
        }
        if (list4.contains(genre)) {
          if (isMovie) {
            _constructGenreGroups(GenresContentType.movieGenresGroup4, genre,
                GenresContentType.tvMovieGroup4);
          } else {
            _constructGenreGroupsForTV(GenresContentType.tvGenresGroup4, genre,
                GenresContentType.movieTvGroup4);
          }
          return;
        }
        if (list5.contains(genre)) {
          if (isMovie) {
            _constructGenreGroups(GenresContentType.movieGenresGroup5, genre,
                GenresContentType.tvMovieGroup5);
          } else {
            _constructGenreGroupsForTV(GenresContentType.tvGenresGroup5, genre,
                GenresContentType.movieTvGroup5);
          }
          return;
        }
      });
    } else {
      _addAllGenresWhenNoneSelected(
          _movieGenreItems,
          GenresContentType.movieGenresGroup1,
          GenresContentType.movieGenresGroup2,
          GenresContentType.movieGenresGroup3,
          GenresContentType.movieGenresGroup4,
          GenresContentType.movieGenresGroup5);
      _addAllGenresWhenNoneSelected(
          _tvGenreItems,
          GenresContentType.tvGenresGroup1,
          GenresContentType.tvGenresGroup2,
          GenresContentType.tvGenresGroup3,
          GenresContentType.tvGenresGroup4,
          GenresContentType.tvGenresGroup5);
    }
  }

  void _addAllGenresWhenNoneSelected(
      List<GenresContentType> result,
      List<String> list1,
      List<String> list2,
      List<String> list3,
      List<String> list4,
      List<String> list5) {
    result.addAll(list1.map((e) => GenresContentType(e, false)).toList());
    result.addAll(list2.map((e) => GenresContentType(e, false)).toList());
    result.addAll(list3.map((e) => GenresContentType(e, false)).toList());
    result.addAll(list4.map((e) => GenresContentType(e, false)).toList());
    result.addAll(list5.map((e) => GenresContentType(e, false)).toList());
  }

  void _constructGenreGroups(
      List<String> list1, String genre, List<String> list2) {
    _setResult(_movieGenreItems, genre, list1);
    _setResult(_tvGenreItems, genre, list2);
  }

  void _constructGenreGroupsForTV(
      List<String> list1, String genre, List<String> list2) {
    _setResult(_tvGenreItems, genre, list1);
    _setResult(_movieGenreItems, genre, list2);
  }

  void _setResult(
      List<GenresContentType> source, String genre, List<String> list1) {
    final _genreValues = source.map((item) => item.value).toList();
    var index = _genreValues.indexOf(genre);
    if (index != -1) {
      GenresContentType item = source[index];
      if (!item.selected) {
        source.remove(item);
        source.add(GenresContentType(genre, true));
      }
    } else {
      source.addAll(list1.map((e) => e == genre
          ? GenresContentType(e, true)
          : GenresContentType(e, false)));
    }
  }

  void _constructEntertainmentType(bool isMovie) {
    _entertainmentTypes = [
      EntertainmentContentType(ENTERTAINMENT_CONTENT_TYPE_MOVIES, isMovie),
      EntertainmentContentType(ENTERTAINMENT_CONTENT_TYPE_TV_SHOWS,
          response.getEntertainmentContentType() == EntertainmentType.TV)
    ];
  }

  bool isValidList(Map parameters, String key) =>
      parameters != null &&
      parameters[key] != null &&
      parameters[key].length > 0;

  List<EntertainmentContentType> getEntertainmentTypes() {
    return _entertainmentTypes;
  }

  List<GenresContentType> getMovieGenreContentType() {
    return _removeDuplicates(_movieGenreItems);
  }

  List<GenresContentType> getTVGenreItems() {
    return _removeDuplicates(_tvGenreItems);
  }

  List<String> getMusicArtists() {
    return _musicArtists;
  }

  List<String> getWatchProviders() {
    return _watchProviders;
  }

  List<String> getWatchProvidersOriginal() {
    return _watchProvidersOriginal;
  }

  List<String> getSearchKeywords() {
    return _searchKeywords;
  }

  List<String> getSearchKeywordsOriginal() {
    return _searchKeywordsOriginal;
  }


  List<String> getLanguages() {
    return _languages;
  }

  Map getDatePeriod() {
    return _datePeriod;
  }

  String getDatePeriodOriginal() {
    return _datePeriodOriginal;
  }

  String getCustomDatePeriod() {
    return _customDatePeriod;
  }
  String getShortMovie() {
    return _short;
  }

  List<GenresContentType> _removeDuplicates(List<GenresContentType> source) {
    List<GenresContentType> result = [];
    var _genreValues = source.map((item) => item.value).toList();
    _genreValues = _genreValues.toSet().toList();
    _genreValues.forEach((element) {
      GenresContentType item = source
          .firstWhere((item) => item.value == element, orElse: () => null);
      if (item != null) {
        result.add(item);
      }
    });
    result.sort((a, b) {
      if (b.selected) return 1;
      return -1;
    });
    return result;
  }

  String getLikePhrases() {
    return _likePhrases;
  }

  String getMovieOrTvId() {
    return _movieOrTvId;
  }

  String getSortBy() {
    return _sortyBy;
  }
}
