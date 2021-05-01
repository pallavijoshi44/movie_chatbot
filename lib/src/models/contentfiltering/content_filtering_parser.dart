import 'package:flutter_app/src/domain/ai_response.dart';
import 'package:flutter_app/src/domain/constants.dart';

import 'entertainment_type.dart';
import 'genre_content_type.dart';

class ContentFilteringParser {
  final AIResponse response;
  List<EntertainmentContentType> _entertainmentTypes;
  List<GenresContentType> _movieGenreItems = [];
  List<GenresContentType> _tvGenreItems = [];

  ContentFilteringParser({this.response}) {
    bool isMovie =
        response.getEntertainmentContentType() == EntertainmentType.MOVIE;

    _constructEntertainmentType(isMovie);
    _constructGenres(response.getParameters(), isMovie);
  }

  void _constructGenres(Map parameters, bool isMovie) {
    _movieGenreItems = [];
    _tvGenreItems = [];

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

    if (isValid(parameters, 'genres')) {
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

  bool isValid(Map parameters, String key) =>
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
    return result;
  }
}

// "parameters": {
// "operator-selector": "",
// "watch-provider": [],
// "music-artist": [],
// "custom-date-period": "old",
// "language": [
// "Hindi",
// "French",
// "Mandarin"
// ],
// "date-period": "",
// "watch-provider-original": [],
// "country-name": "",
// "genres": [
// "Action",
// "Adventure"
// ],
// "country-code": ""
// }
