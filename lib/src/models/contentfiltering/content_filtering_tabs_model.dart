import 'package:flutter/cupertino.dart';

import '../message_model.dart';
import 'entertainment_type.dart';
import 'genre_content_type.dart';

class ContentFilteringTabsModel extends MessageModel {
  final String title;
  final MessageType type;
  final Function handleFilterContents;
  final List<EntertainmentContentType> entertainmentTypes;
  final List<GenresContentType> movieGenreTypes;
  final List<GenresContentType> tvGenreTypes;
  final List<String> musicArtists;
  final List<String> watchProviders;
  final List<String> languages;

  ContentFilteringTabsModel(
      {this.title,
      @required this.type,
      this.handleFilterContents,
      this.entertainmentTypes,
      this.movieGenreTypes,
      this.tvGenreTypes,
      this.musicArtists,
      this.watchProviders,
      this.languages})
      : super(type: type, name: title);
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
