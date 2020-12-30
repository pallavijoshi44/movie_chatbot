import 'package:flutter/cupertino.dart';
import 'package:flutter_app/models/message.dart';
import 'package:flutter_dialogflow/v2/message.dart';

class CarouselModel extends Message {

  final CarouselSelect carouselSelect;

  CarouselModel({String name, @required MessageType type, this.carouselSelect}) : super(name: name, type: type);

}