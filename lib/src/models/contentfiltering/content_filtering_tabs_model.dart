import 'package:flutter/cupertino.dart';

import '../message_model.dart';
import 'entertainment_type.dart';
import 'genre_content_type.dart';

class ContentFilteringTabsModel extends MessageModel {
  final String title;
  final MessageType type;
  final Function handleFilterContents;
  final List<EntertainmentContentType> entertainmentTypes;
  final List<GenresContentType> genreTypes;

  ContentFilteringTabsModel({this.title,
    @required this.type,
    this.handleFilterContents,
    this.entertainmentTypes,
    this.genreTypes})
      : super(type: type, name: title);
}