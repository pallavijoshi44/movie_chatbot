import 'package:flutter/cupertino.dart';

import 'message_model.dart';

class ContentFilteringTabsModel extends MessageModel {
  ContentFilteringTabsModel({String title, @required MessageType type})
      : super(type: type, name: title);
}