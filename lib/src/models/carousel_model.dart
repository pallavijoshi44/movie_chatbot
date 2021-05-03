import 'package:flutter/cupertino.dart';
import 'package:flutter_app/src/domain/ai_response.dart';
import 'package:flutter_app/src/models/message_model.dart';
import 'package:flutter_dialogflow/v2/message.dart';

class CarouselModel extends MessageModel {

  final CarouselSelect carouselSelect;
  final EntertainmentType entertainmentType;

  CarouselModel({String name, @required MessageType type, this.carouselSelect, this.entertainmentType}) : super(name: name, type: type);

}