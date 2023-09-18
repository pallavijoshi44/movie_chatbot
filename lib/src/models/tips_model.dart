import 'package:flutter_app/src/models/message_model.dart';

class TipsModel extends MessageModel {
  TipsModel(
      {required String text, required String name, required MessageType type})
      : super(text: text, name: name, type: type);
}
