class MessageModel {
  final String text;
  final String name;
  final MessageType type;

  MessageModel({this.text, this.name, this.type});
}

enum MessageType { CHAT_MESSAGE, QUICK_REPLY, CAROUSEL, MULTI_SELECT }
