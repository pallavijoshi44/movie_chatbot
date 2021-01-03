import 'package:flutter/cupertino.dart';
import 'package:flutter_app/models/message_model.dart';

class ReplyModel extends MessageModel {
  final List<String> quickReplies;
  final Function updateQuickReply;
  ReplyModel({@required String name, @required MessageType type, String text, this.quickReplies, this.updateQuickReply}) : super(name: name, type: type, text: text);
}