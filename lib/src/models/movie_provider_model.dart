import 'package:flutter/cupertino.dart';
import 'package:flutter_app/src/models/message_model.dart';

class MovieProviderModel extends MessageModel {
  final List<dynamic> logos;

  MovieProviderModel({String text, @required MessageType type, this.logos})
      : super(text: text, type: type);
}
