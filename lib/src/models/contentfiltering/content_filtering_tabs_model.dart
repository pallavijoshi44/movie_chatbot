import 'package:flutter/cupertino.dart';
import 'package:flutter_app/src/domain/ai_response.dart';
import 'package:flutter_app/src/domain/constants.dart';

import '../message_model.dart';
import 'entertainment_type.dart';
import 'genre_content_type.dart';

class ContentFilteringTabsModel extends MessageModel {
  final String title;
  final MessageType type;
  final AIResponse response;

  final Function handleFilterContents;
  List<EntertainmentContentType> _entertainmentTypes;
  List<GenresContentType> _genreTypes = [];

  Map<String, String> _items;

  ContentFilteringTabsModel(
      {this.title,
      @required this.type,
      this.response,
      this.handleFilterContents})
      : super(type: type, name: title) {
    Map parameters = response.getParameters();

    bool isMovie =
        response.getEntertainmentContentType() == EntertainmentType.MOVIE;
    _constructEntertainmentType(isMovie);
    _constructGenres(parameters, isMovie);
  }

  void _constructGenres(Map parameters, bool isMovie) {
    if (isValid(parameters, 'genres')) {
      List<dynamic> selectedGenres = parameters['genres'];
      List<String> list1 = isMovie ? GenresContentType.movieGenresGroup1 : GenresContentType.tvGenresGroup1;
      List<String> list2 = isMovie ? GenresContentType.movieGenresGroup2 : GenresContentType.tvGenresGroup2;
      List<String> list3 = isMovie ? GenresContentType.movieGenresGroup3 : GenresContentType.tvGenresGroup3;
      List<String> list4 = isMovie ? GenresContentType.movieGenresGroup4 : GenresContentType.tvGenresGroup4;
      List<String> list5 = isMovie ? GenresContentType.movieGenresGroup5 : GenresContentType.tvGenresGroup5;
      
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
      _genreTypes = _genreTypes.toSet().toList();
    }
  }

  void _constructGenreGroups(List<String> list1, String genre) {
       _genreTypes.addAll(list1
        .map((e) => e == genre
            ? GenresContentType(e, true)
            : GenresContentType(e, false))
        .toList());
  }
  
  void _constructEntertainmentType(bool isMovie) {
    _entertainmentTypes = [
      EntertainmentContentType(ENTERTAINMENT_CONTENT_TYPE_MOVIES, isMovie),
      EntertainmentContentType(ENTERTAINMENT_CONTENT_TYPE_TV_SHOWS,
          response.getEntertainmentContentType() == EntertainmentType.TV)
    ];
  }

  bool isValid(Map parameters, String key) =>
      parameters != null && parameters[key] != null && parameters[key].length > 0;

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
