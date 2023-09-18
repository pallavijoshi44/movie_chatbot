import 'package:flutter_app/src/models/message_model.dart';

class ReplyModel extends MessageModel {
  final List<String> quickReplies;
  final Function updateQuickReply;
  ReplyModel({required String name, required MessageType type, required String text, required this.quickReplies, required this.updateQuickReply}) : super(name: name, type: type, text: text);
}