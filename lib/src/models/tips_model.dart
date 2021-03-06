import 'package:flutter/cupertino.dart';
import 'package:flutter_app/src/models/message_model.dart';

class TipsModel extends MessageModel {
  TipsModel(
      {String text, String name, @required MessageType type})
      : super(text: text, name: name, type: type);
}
