import 'package:dialogflow_flutter/message.dart';
import 'package:flutter_app/src/domain/ai_response.dart';
import 'package:flutter_app/src/domain/parameters.dart';
import 'package:flutter_app/src/models/contentfiltering/content_filtering_parser.dart';
import 'package:flutter_app/src/models/message_model.dart';
import 'package:flutter_app/src/models/settings_model.dart';

class CarouselModel extends MessageModel {
  List<ItemCarousel> _items = [];
  EntertainmentType? _entertainmentType;
  Parameters? _parameters;
  int _totalPages = 1;
  final AIResponse? response;
  final SettingsModel? settings;
  late ContentFilteringParser _contentFilteringResponse;

  CarouselModel(
      {required String name, required MessageType type,  this.response,  this.settings})
      : super(name: name, type: type) {
    _items = response?.containsCarousel() == true
        ? _getItems(CarouselSelect(response?.getPayload()))
        : [];
    _entertainmentType = response?.getEntertainmentContentType();
    _parameters = response?.getParametersJson();
    _contentFilteringResponse =
        ContentFilteringParser(response: response, settings: settings);
    _totalPages =
    response?.containsInnerPayload() == true ? (response?.getInnerPayload()['totalPages'] != null
        ? response?.getInnerPayload()['totalPages']
        : 1) : 1;
  }

  EntertainmentType? getEntertainmentType() {
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

  Parameters? getParameters() {
    return _parameters;
  }

  ContentFilteringParser getContentFilteringResponse() {
    return _contentFilteringResponse;
  }

  int getTotalPages() {
    return _totalPages;
  }

}
