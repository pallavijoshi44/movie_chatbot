class MessageModel {
  final String text;
  final String name;
  final MessageType type;

  MessageModel({this.text, this.name, this.type});
}

enum MessageType { CHAT_MESSAGE, QUICK_REPLY, CAROUSEL, MULTI_SELECT, MOVIE_PROVIDER, MOVIE_PROVIDER_URL, MOVIE_TRAILER, MOVIE_JUST_WATCH, TIPS_MESSAGE }
