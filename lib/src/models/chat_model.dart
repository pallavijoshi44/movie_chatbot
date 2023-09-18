import 'package:flutter_app/src/models/message_model.dart';

class ChatModel extends MessageModel {
  bool chatType;

  ChatModel({required String text, required String name, required MessageType type, required this.chatType}) : super(text: text, name: name, type: type);

}