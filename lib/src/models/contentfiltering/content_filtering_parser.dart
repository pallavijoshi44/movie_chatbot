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
    _tvGenreItems =[];

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

    List<String> list6 = isMovie
        ? GenresContentType.tvGenresGroup1
        : GenresContentType.movieGenresGroup1;
    List<String> list7 = isMovie
        ? GenresContentType.tvGenresGroup2
        : GenresContentType.movieGenresGroup2;
    List<String> list8 = isMovie
        ? GenresContentType.tvGenresGroup3
        : GenresContentType.movieGenresGroup3;
    List<String> list9 = isMovie
        ? GenresContentType.tvGenresGroup4
        : GenresContentType.movieGenresGroup4;
    List<String> list10 = isMovie
        ? GenresContentType.tvGenresGroup5
        : GenresContentType.movieGenresGroup5;

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
      _addAllGenresWhenNoneSelected(_movieGenreItems, list1, list2, list3, list4, list5);
    }
    _addAllGenresWhenNoneSelected(_tvGenreItems, list6, list7, list8, list9, list10);
  }

  void _addAllGenresWhenNoneSelected(
      List<GenresContentType> result,
      List<String> list1,
      List<String> list2,
      List<String> list3,
      List<String> list4,
      List<String> list5) {

     result
        .addAll(list1.map((e) => GenresContentType(e, false)).toList());
    result
        .addAll(list2.map((e) => GenresContentType(e, false)).toList());
    result
        .addAll(list3.map((e) => GenresContentType(e, false)).toList());
    result
        .addAll(list4.map((e) => GenresContentType(e, false)).toList());
    result
        .addAll(list5.map((e) => GenresContentType(e, false)).toList());
  }

  void _constructGenreGroups(List<String> list1, String genre) {
    final _genreValues = _movieGenreItems.map((item) => item.value).toList();
    var index = _genreValues.indexOf(genre);
    if (index != -1) {
      GenresContentType item = _movieGenreItems[index];
      if (!item.selected) {
        _movieGenreItems.remove(item);
        _movieGenreItems.add(GenresContentType(genre, true));
      }
    } else {
      _movieGenreItems.addAll(list1.map((e) => e == genre
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
    return _movieGenreItems;
  }
  List<GenresContentType> getTVGenreItems() {
    return _tvGenreItems;
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
