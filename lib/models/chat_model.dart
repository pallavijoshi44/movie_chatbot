import 'package:flutter/cupertino.dart';
import 'package:flutter_app/models/message_model.dart';

class ChatModel extends MessageModel {
  bool chatType;

  ChatModel({String text, String name, @required MessageType type, this.chatType}) : super(text: text, name: name, type: type);

}