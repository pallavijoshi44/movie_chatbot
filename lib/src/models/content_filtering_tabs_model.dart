import 'package:flutter/cupertino.dart';
import 'package:flutter_app/src/domain/ai_response.dart';
import 'package:flutter_app/src/domain/constants.dart';

import 'message_model.dart';

class ContentFilteringTabsModel extends MessageModel {
  final String title;
  final MessageType type;
  final AIResponse response;
  final Function handleFilterContents;

  List<EntertainmentContentType> _entertainmentTypes;
  Map<String, String> _items;

  ContentFilteringTabsModel({this.title, @required this.type, this.response, this.handleFilterContents})
      : super(type: type, name: title) {

    Map parameters = response.getParameters();

    _entertainmentTypes = [
      EntertainmentContentType(ENTERTAINMENT_CONTENT_TYPE_MOVIES,
          response.getEntertainmentContentType() == EntertainmentType.MOVIE),
      EntertainmentContentType(ENTERTAINMENT_CONTENT_TYPE_TV_SHOWS,
          response.getEntertainmentContentType() == EntertainmentType.TV)
    ];
  }

  List<EntertainmentContentType> getEntertainmentTypes() {
    return _entertainmentTypes;
  }
}

class EntertainmentContentType {
  final bool selected;
  final String value;

  EntertainmentContentType(this.value, this.selected);
}
// enum ContentType {
//   ENTERTAINMENT_TYPE,
//   LANGUAGES,
//   CUSTOM_DATE_TYPE,
//   DATE_PERIOD,
//   WATCH_PROVIDERS,
//   GENRES,
//   SHORT,
//   LONG,
//   MUSIC_ARTIST,
//   SEARCH_KEYWORD
// }

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
