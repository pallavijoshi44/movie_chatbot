import 'package:flutter/cupertino.dart';
import 'package:flutter_app/src/domain/ai_response.dart';
import 'package:flutter_app/src/domain/parameters.dart';
import 'package:flutter_app/src/models/contentfiltering/content_filtering_parser.dart';
import 'package:flutter_app/src/models/message_model.dart';
import 'package:flutter_dialogflow/v2/message.dart';

class CarouselModel extends MessageModel {
  List<ItemCarousel> _items;
  EntertainmentType _entertainmentType;
  Parameters _parameters;
  final AIResponse response;
  ContentFilteringParser _contentFilteringResponse;

  CarouselModel({String name, @required MessageType type, this.response})
      : super(name: name, type: type) {
    _items = response.containsCarousel()
        ? _getItems(CarouselSelect(response.getCarousel()))
        : [];
    _entertainmentType = response.getEntertainmentContentType();
    _parameters = response.getParametersJson();
    _contentFilteringResponse = ContentFilteringParser(response: response);
  }

  EntertainmentType getEntertainmentType() {
    return _entertainmentType;
  }

  List<ItemCarousel> getCarouselItems() {
    return _items;
  }

  List<ItemCarousel> _getItems(CarouselSelect carouselSelect) {
    return carouselSelect.items != null && carouselSelect.items.length > 0
        ? carouselSelect.items
        : [];
  }

  Parameters getParameters() {
    return _parameters;
  }

  ContentFilteringParser getContentFilteringResponse() {
    return _contentFilteringResponse;
  }

}
