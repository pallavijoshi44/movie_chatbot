import 'package:flutter_app/src/models/contentfiltering/content_filtering_parser.dart';

import '../message_model.dart';

class ContentFilteringTagsModel extends MessageModel {
  final String title;
  final MessageType type;
  final Function? handleFilterContents;
  final ContentFilteringParser? response;

  ContentFilteringTagsModel({
    required this.title,
    required this.type,
    this.handleFilterContents,
    this.response,
  }) : super(type: type, name: title);
}
// "parameters": {
// "id": "",
// "like-phrases": "",
// "date-period": {
// "endDate": "1999-12-31T23:59:59+01:00",
// "startDate": "1990-01-01T00:00:00+01:00"
// },
// "country-name": "",
// "language": [
// "Hindi"
// ],
// "search-keyword-original": [
// "cricket"
// ],
// "search-keyword": [
// "5719"
// ],
// "custom-date-period": "",
// "operator-selector": "",
// "watch-provider-original": [],
// "genres": [],
// "country-code": "",
// "music-artist": [],
// "date-period-original": "1990s",
// "watch-provider": [],
// "short-movie": ""
// },
