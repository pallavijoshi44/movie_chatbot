import 'package:flutter/cupertino.dart';
import 'package:flutter_app/models/message_model.dart';

class ReplyModel extends MessageModel {
  final List<String> quickReplies;
  final Function updateQuickReply;
  bool enabled;
  ReplyModel({@required String name, @required MessageType type, String text, this.quickReplies, this.updateQuickReply, this.enabled}) : super(name: name, type: type, text: text);
}