import 'package:flutter/cupertino.dart';
import 'package:flutter_app/models/message_model.dart';

class MovieJustWatchModel extends MessageModel {
  MovieJustWatchModel({String title, @required MessageType type})
      : super(type: type, name: title);
}
