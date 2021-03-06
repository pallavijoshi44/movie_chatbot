import 'package:flutter/cupertino.dart';
import 'package:flutter_app/src/models/message_model.dart';
import 'package:flutter_dialogflow/v2/message.dart';

class CarouselModel extends MessageModel {

  final CarouselSelect carouselSelect;

  CarouselModel({String name, @required MessageType type, this.carouselSelect}) : super(name: name, type: type);

}