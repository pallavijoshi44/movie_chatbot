import 'package:flutter/cupertino.dart';
import 'package:flutter_app/src/domain/ai_response.dart';
import 'package:flutter_app/src/domain/parameters.dart';
import 'package:flutter_app/src/models/message_model.dart';
import 'package:flutter_dialogflow/v2/message.dart';

class CarouselModel extends MessageModel {
  CarouselSelect _carouselSelect;
  EntertainmentType _entertainmentType;
  Parameters _parameters;
  final AIResponse response;
  final Function fetchMoreData;

  CarouselModel(
      {String name,
      @required MessageType type,
      this.response,
      this.fetchMoreData})
      : super(name: name, type: type) {
    _carouselSelect = new CarouselSelect(response.getCarousel());
    _entertainmentType = response.getEntertainmentContentType();
    _parameters = response.getParametersJson();
  }

  EntertainmentType getEntertainmentType() {
    return _entertainmentType;
  }

  CarouselSelect getCarouselSelect() {
    return _carouselSelect;
  }

  Parameters getParameters() {
    return _parameters;
  }
}
