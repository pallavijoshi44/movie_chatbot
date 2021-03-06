import 'package:flutter/cupertino.dart';
import 'package:flutter_app/models/message_model.dart';

class UnreadMessageModel extends MessageModel {
  bool chatType;
  bool messageUnreadStatus;

  UnreadMessageModel({@required MessageType type, this.chatType, this.messageUnreadStatus}) : super(type: type);

}