import 'package:flutter/cupertino.dart';
import 'package:flutter_app/models/message.dart';

class MovieProviderUrl extends Message {
  MovieProviderUrl({String url, String title, @required MessageType type})
      : super(text: url, type: type, name: title);
}
