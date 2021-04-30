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
  List<GenresContentType> _genreTypes;
  Map<String, String> _items;

  ContentFilteringTabsModel(
      {this.title,
      @required this.type,
      this.response,
      this.handleFilterContents})
      : super(type: type, name: title) {
    Map parameters = response.getParameters();

    _entertainmentTypes = [
      EntertainmentContentType(ENTERTAINMENT_CONTENT_TYPE_MOVIES,
          response.getEntertainmentContentType() == EntertainmentType.MOVIE),
      EntertainmentContentType(ENTERTAINMENT_CONTENT_TYPE_TV_SHOWS,
          response.getEntertainmentContentType() == EntertainmentType.TV)
    ];

    if (isValid(parameters, 'genres')) {
      _genreTypes = parameters['genres'].map((genre) {
        return GenresContentType(genre, true);
      });
    }
  }

  bool isValid(Map parameters, key) =>
      parameters != null && parameters[key] != null && parameters[key].size > 0;

  List<EntertainmentContentType> getEntertainmentTypes() {
    return _entertainmentTypes;
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
