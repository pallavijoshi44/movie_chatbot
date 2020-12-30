import 'package:flutter/cupertino.dart';
import 'package:flutter_app/models/message.dart';

class ChatModel extends Message {
  bool chatType;

  ChatModel({String text, String name, @required MessageType type, this.chatType}) : super(text: text, name: name, type: type);

}