import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app/src/domain/ai_response.dart';
import 'package:flutter_app/src/domain/constants.dart';
import 'package:flutter_app/src/domain/parameters.dart';
import 'package:flutter_app/src/models/carousel_model.dart';
import 'package:flutter_app/src/models/message_model.dart';
import 'package:flutter_app/src/resources/detect_dialog_responses.dart';
import 'package:flutter_app/src/ui/rating_widget.dart';
import 'package:flutter_dialogflow/v2/message.dart';
import 'package:loading_gifs/loading_gifs.dart';

class CarouselDialogSlider extends StatefulWidget {
  CarouselDialogSlider(
      {Key key,
      this.carouselSelect,
      this.carouselItemClicked,
      this.entertainmentType,
      this.parameters})
      : super(key: key);

  final CarouselSelect carouselSelect;
  final EntertainmentType entertainmentType;
  final Function carouselItemClicked;
  final Parameters parameters;

  @override
  CarouselDialogSliderState createState() => CarouselDialogSliderState();
}

class CarouselDialogSliderState extends State<CarouselDialogSlider> {
  bool _enabled = true;
  bool _showPlaceHolder = false;
  Timer _timer;
  ScrollController _controller;
  List<ItemCarousel> _items;
  int _pageNumber = 1;
  EntertainmentType _entertainmentType;
  Parameters _parameters;

  @override
  void initState() {
    _items = widget.carouselSelect.items;
    _entertainmentType = widget.entertainmentType;
    _parameters = widget.parameters;
    _controller = new ScrollController()..addListener(_scrollListener);
    super.initState();
  }

  void _scrollListener() {
    if (_controller.position.extentAfter <= 0) {
      _pageNumber++;
      String eventName = _entertainmentType == EntertainmentType.MOVIE
          ? MOVIE_RECOMMENDATIONS_EVENT
          : TV_RECOMMENDATIONS_EVENT;
      Parameters parameters = _parameters;
      parameters.pageNumber = _pageNumber;
      setState(() {
        _pageNumber += 1;
      });
      //var param = "'parameters' : { 'page-number':  $_pageNumber }";
      DetectDialogResponses detectDialogResponses = new DetectDialogResponses(
          executeResponse: _updateItems,
          eventName: eventName,
          parameters: parameters,
          queryInputType: QUERY_INPUT_TYPE.EVENT,
          defaultResponse: null);

      detectDialogResponses.callDialogFlow();
      //   widget.fetchMoreData.call(widget.parameters, widget.entertainmentType);
    }
  }

  void _updateItems(AIResponse response) {
    if (response.containsCarousel()) {
      var carouselModel =
          CarouselModel(response: response, type: MessageType.CAROUSEL);
      setState(() {
        _items.addAll(carouselModel.getCarouselSelect().items);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
        ));
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
        ? FadeInImage.assetNetwork(
            placeholder: cupertinoActivityIndicator,
            image: "image.png",
            placeholderScale: 5)
        : Image.asset(circularProgressIndicator, scale: 10);
    return placeHolderImage;
  }

  _handleTap(ItemCarousel item) {
    setState(() {
      _enabled = false;
    });
    _timer = Timer(Duration(seconds: 1), () => setState(() => _enabled = true));
    return widget.carouselItemClicked(item.info['key'], _entertainmentType);
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer.cancel();
    }
    _controller.removeListener(_scrollListener);
    super.dispose();
  }

  void showPlaceHolders() {
    setState(() {
      _showPlaceHolder = true;
    });
  }

  void showCarouselItems(CarouselSelect carouselSelect, Parameters parameters,
      EntertainmentType entertainmentType) {
    setState(() {
      _showPlaceHolder = false;
      _items = carouselSelect.items;
      _parameters = parameters;
      _entertainmentType = entertainmentType;
    });
  }
}
