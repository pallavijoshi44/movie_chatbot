import 'package:dialogflow_flutter/message.dart';
import 'package:flutter_app/src/models/message_model.dart';

class MultiSelectModel extends MessageModel {
  final List<ButtonDialogflow> buttons;
  final Function updateMultiSelect;
  final containsNoPreference;

  MultiSelectModel(
      {required String name,
      required MessageType type,
      required String text,
      required this.buttons,
      required this.updateMultiSelect,
      this.containsNoPreference})
      : super(name: name, type: type, text: text);
}
