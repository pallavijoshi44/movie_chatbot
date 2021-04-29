import 'package:flutter/cupertino.dart';
import 'package:flutter_app/src/domain/ai_response.dart';

import 'message_model.dart';

class ContentFilteringTabsModel extends MessageModel {
  ContentFilteringTabsModel({String title, @required MessageType type, AIResponse response})
      : super(type: type, name: title);
}