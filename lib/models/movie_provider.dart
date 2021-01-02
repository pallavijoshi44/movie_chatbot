import 'package:flutter/cupertino.dart';
import 'package:flutter_app/models/message.dart';

class MovieProvider extends Message {
  final List<dynamic> logos;

  MovieProvider({String text, @required MessageType type, this.logos})
      : super(text: text, type: type);
}
