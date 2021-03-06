import 'package:flutter/cupertino.dart';
import 'package:flutter_app/models/message_model.dart';

class UnreadMessageModel extends MessageModel {
  bool chatType;

  UnreadMessageModel({@required MessageType type, this.chatType}) : super(type: type);

}