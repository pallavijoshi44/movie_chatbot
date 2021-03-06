import 'package:flutter/cupertino.dart';
import 'package:flutter_app/src/models/message_model.dart';

class MovieProviderUrlModel extends MessageModel {
  MovieProviderUrlModel({String url, String title, @required MessageType type})
      : super(text: url, type: type, name: title);
}
