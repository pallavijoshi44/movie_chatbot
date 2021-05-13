import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app/src/domain/ai_response.dart';
import 'package:flutter_app/src/domain/constants.dart';
import 'package:flutter_app/src/domain/parameters.dart';
import 'package:flutter_app/src/models/carousel_model.dart';
import 'package:flutter_app/src/models/contentfiltering/content_filtering_parser.dart';
import 'package:flutter_app/src/models/message_model.dart';
import 'package:flutter_app/src/models/settings_model.dart';
import 'package:flutter_app/src/resources/detect_dialog_responses.dart';
import 'package:flutter_app/src/ui/rating_widget.dart';
import 'package:flutter_dialogflow/v2/message.dart';

import 'chat_message.dart';
import 'content_filtering_tags.dart';

class CarouselDialogSlider extends StatefulWidget {
  final CarouselModel carouselModel;
  final Function carouselItemClicked;
  final Function updateHelpContent;
  final SettingsModel settings;

  CarouselDialogSlider(this.carouselModel, this.carouselItemClicked,
      this.settings, this.updateHelpContent);

  @override
  CarouselDialogSliderState createState() => CarouselDialogSliderState();
}

class CarouselDialogSliderState extends State<CarouselDialogSlider> {
  bool _enabled = true;
  bool _showPlaceHolder = false;
  bool _showDefault = false;
  Timer _timer;
  ScrollController _controller;
  List<ItemCarousel> _items;
  int _pageNumber = 1;
  EntertainmentType _entertainmentType;
  Parameters _parameters;
  ContentFilteringParser _contentFilteringResponse;

  @override
  void initState() {
    _initializeItems(widget.carouselModel);
    _controller = new ScrollController()..addListener(_scrollListener);
    super.initState();
  }

  void _initializeItems(CarouselModel carouselModel) {
    _showPlaceHolder = false;
    _items = carouselModel.getCarouselItems();
    _entertainmentType = carouselModel.getEntertainmentType();
    _parameters = carouselModel.getParameters();
    _pageNumber = carouselModel.getParameters().pageNumber ?? 1;
    _contentFilteringResponse = carouselModel.getContentFilteringResponse();
    _showDefault = false;
  }

  @override
  Widget build(BuildContext context) {
    String entertainmentContent = _entertainmentType == EntertainmentType.MOVIE
        ? ENTERTAINMENT_CONTENT_TYPE_MOVIES
        : ENTERTAINMENT_CONTENT_TYPE_TV_SHOWS;

    return Column(
      children: [
        _items.isEmpty
            ? Stack(children: [
                ChatMessage(
                  text: _showDefault
                      ? DEFAULT_RESPONSE
                      : "Oops, looks like there is no $entertainmentContent matching your criteria.",
                  type: false,
                ),
                if (_showPlaceHolder)
                  Positioned(
                      left: 0,
                      right: 0,
                      top: 0,
                      bottom: 0,
                      child: _getPlaceHolderImage())
              ])
            : Container(
                height: 415.0,
                margin: EdgeInsets.only(top: 20),
                child: ListView(
                  controller: _controller,
                  scrollDirection: Axis.horizontal,
                  children: _items
                      .map((item) => _showPlaceHolder
                          ? _buildPlaceHolderItem(context)
                          : _buildCarouselItem(context, item))
                      .toList(),
                )),
        ContentFilteringTags(
            response: _contentFilteringResponse,
            settingsModel: widget.settings,
            filterContents: _handleFilterContents,
            showPlaceHolderInCarousel: showPlaceHolders)
      ],
    );
  }

  Widget _buildPlaceHolderItem(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      child: Container(
        width: 250,
        child: Column(
          children: [
            Container(
                margin: EdgeInsets.all(15),
                padding: EdgeInsets.only(top: 10),
                height: 300,
                width: 200,
                child: _getPlaceHolderImage()),
          ],
        ),
      ),
    );
  }

  Material _buildCarouselItem(BuildContext context, ItemCarousel item) {
    return Material(
      color: Color.fromRGBO(249, 248, 235, 1),
      child: InkWell(
        splashColor: Platform.isIOS
            ? CupertinoTheme.of(context).primaryContrastingColor
            : Theme.of(context).primaryColorLight,
        highlightColor: Colors.green,
        onTap: _enabled
            ? () {
                return _handleTap(item);
              }
            : null,
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 5,
          child: Container(
            width: 250,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.all(15),
                  padding: EdgeInsets.only(top: 10),
                  height: 300,
                  width: 200,
                  child: item.image.imageUri == null
                      ? Image.asset(
                          'assets/images/placeholder.jpg',
                          fit: BoxFit.fitHeight,
                        )
                      : Image.network(item.image.imageUri,
                          fit: BoxFit.fitHeight),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 5, right: 5),
                    child: Column(
                      children: [
                        Text(
                          '${item.title}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14.0,
                            fontFamily: 'QuickSand',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        RatingWidget(
                            rating: item.description, centerAlignment: true),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getPlaceHolderImage() {
    var placeHolderImage = Platform.isIOS
        ? Image.asset(
            "packages/loading_gifs/assets/images/cupertino_activity_indicator.gif",
            scale: 5)
        : Image.asset(
            "packages/loading_gifs/assets/images/circular_progress_indicator.gif",
            scale: 10);
    return placeHolderImage;
  }

  _handleTap(ItemCarousel item) {
    setState(() {
      _enabled = false;
    });
    _timer = Timer(Duration(seconds: 1), () => setState(() => _enabled = true));
    return widget.carouselItemClicked(
        item.info['key'].toString(), _entertainmentType);
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer.cancel();
    }
    _controller.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    if (_controller.position.pixels == _controller.position.maxScrollExtent) {
      String eventName = _entertainmentType == EntertainmentType.MOVIE
          ? MOVIE_RECOMMENDATIONS_EVENT
          : TV_RECOMMENDATIONS_EVENT;
      _pageNumber = _pageNumber + 1;
      Parameters parameters = _parameters;
      parameters.pageNumber = _pageNumber;
      parameters.countryCode = widget.settings.countryCode.getValue();
      _callDialogFlowByEvent(eventName, parameters.toString(),
          _updateItemsInHorizontalScrollview, _showDefaultMessage);
    }
  }

  void _callDialogFlowByEvent(String eventName, String parameters,
      Function execute, Function defaultResponse) {
    DetectDialogResponses detectDialogResponses = new DetectDialogResponses(
        executeResponse: execute,
        eventName: eventName,
        parameters: parameters,
        queryInputType: QUERY_INPUT_TYPE.EVENT,
        defaultResponse: defaultResponse);

    detectDialogResponses.callDialogFlow();
  }

  void _updateItemsInHorizontalScrollview(AIResponse response) {
    var carouselModel = CarouselModel(
        response: response,
        type: MessageType.CAROUSEL,
        settings: widget.settings);
    setState(() {
      _items.addAll(carouselModel.getCarouselItems());
    });
  }

  void _updateItemsForCarouselAndFilters(AIResponse response) {
    CarouselModel carouselModel = CarouselModel(
        response: response,
        type: MessageType.CAROUSEL,
        settings: widget.settings);

    setState(() {
      _initializeItems(carouselModel);
    });
    widget.updateHelpContent(
        response.helpContent(), response.isHelpContentClickable());
  }

  void showPlaceHolders() {
    setState(() {
      _showPlaceHolder = true;
    });
  }

  void _handleFilterContents(String eventName, String parameters) {
    _callDialogFlowByEvent(eventName, parameters,
        _updateItemsForCarouselAndFilters, _showDefaultMessage);
  }

  void _showDefaultMessage() {
    setState(() {
      _showDefault = true;
    });
  }
}
