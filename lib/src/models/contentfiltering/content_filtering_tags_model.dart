import 'package:flutter/cupertino.dart';
import 'package:flutter_app/src/models/contentfiltering/content_filtering_parser.dart';

import '../message_model.dart';

class ContentFilteringTagsModel extends MessageModel {
  final String title;
  final MessageType type;
  final Function handleFilterContents;
  final ContentFilteringParser response;

  ContentFilteringTagsModel({
    this.title,
    @required this.type,
    this.handleFilterContents,
    this.response,
  }) : super(type: type, name: title);
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
