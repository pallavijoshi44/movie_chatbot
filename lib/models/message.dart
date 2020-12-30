class Message {
  final String text;
  final String name;
  final MessageType type;

  Message({this.text, this.name, this.type});
}

enum MessageType { CHAT_MESSAGE, QUICK_REPLY, CAROUSEL }
