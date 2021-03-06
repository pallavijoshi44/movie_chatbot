import 'package:flutter/widgets.dart';

import 'message_model.dart';

class MovieTrailerModel extends MessageModel {
  String url;
  String thumbNail;


  MovieTrailerModel({String text, @required MessageType type, this.url, this.thumbNail})
      : super(text: text, type: type);
}