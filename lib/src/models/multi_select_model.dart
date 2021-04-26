import 'package:flutter/cupertino.dart';
import 'package:flutter_app/src/models/message_model.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';

class MultiSelectModel extends MessageModel {
  final List<ButtonDialogflow> buttons;
  final Function updateMultiSelect;
  final containsNoPreference;
  MultiSelectModel({ String name, @required MessageType type, String text, this.buttons, this.updateMultiSelect, this.containsNoPreference}) : super(name: name, type: type, text: text);
}