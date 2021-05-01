import 'package:flutter_app/src/domain/ai_response.dart';
import 'package:flutter_app/src/domain/constants.dart';

import 'entertainment_type.dart';
import 'genre_content_type.dart';

class ContentFilteringParser {
  final AIResponse response;
  List<EntertainmentContentType> _entertainmentTypes;
  List<GenresContentType> _genreTypes = [];

  ContentFilteringParser({this.response}) {
    _genreTypes = [];

    bool isMovie =
        response.getEntertainmentContentType() == EntertainmentType.MOVIE;

    _constructEntertainmentType(isMovie);
    _constructGenres(response.getParameters(), isMovie);
  }

  void _constructGenres(Map parameters, bool isMovie) {
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
          _constructGenreGroups(list1, genre);
          return;
        }
        if (list2.contains(genre)) {
          _constructGenreGroups(list2, genre);
          return;
        }
        if (list3.contains(genre)) {
          _constructGenreGroups(list3, genre);
          return;
        }
        if (list4.contains(genre)) {
          _constructGenreGroups(list4, genre);
          return;
        }
        if (list5.contains(genre)) {
          _constructGenreGroups(list5, genre);
          return;
        }
      });
    } else {
      _genreTypes
          .addAll(list1.map((e) => GenresContentType(e, false)).toList());
      _genreTypes
          .addAll(list2.map((e) => GenresContentType(e, false)).toList());
      _genreTypes
          .addAll(list3.map((e) => GenresContentType(e, false)).toList());
      _genreTypes
          .addAll(list4.map((e) => GenresContentType(e, false)).toList());
      _genreTypes
          .addAll(list5.map((e) => GenresContentType(e, false)).toList());
    }
  }

  void _constructGenreGroups(List<String> list1, String genre) {
    final _genreValues = _genreTypes.map((item) => item.value).toList();
    var index = _genreValues.indexOf(genre);
    if (index != -1) {
      GenresContentType item = _genreTypes[index];
      if (!item.selected) {
        _genreTypes.remove(item);
        _genreTypes.add(GenresContentType(genre, true));
      }
    } else {
      _genreTypes.addAll(list1.map((e) => e == genre
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

  List<GenresContentType> getGenreContentType() {
    return _genreTypes;
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
