import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_app/dialogflow/detect_dialog_responses.dart';
import 'package:flutter_app/dialogflow/dialog_flow.dart';
import 'package:flutter_app/models/carousel_model.dart';
import 'package:flutter_app/models/chat_model.dart';
import 'package:flutter_app/models/message_model.dart';
import 'package:flutter_app/models/movie_provider_model.dart';
import 'package:flutter_app/models/movie_provider_url_model.dart';
import 'package:flutter_app/models/movie_providers_model.dart';
import 'package:flutter_app/models/movie_just_watch_model.dart';
import 'package:flutter_app/models/movie_trailer_model.dart';
import 'package:flutter_app/models/multi_select_model.dart';
import 'package:flutter_app/models/reply_model.dart';
import 'package:flutter_app/models/tips_model.dart';
import 'package:flutter_app/models/unread_message_model.dart';
import 'package:flutter_app/widget/movie_thumbnail.dart';
import 'package:flutter_app/widget/quick_reply.dart';
import 'package:flutter_app/widget/text_composer.dart';
import 'package:flutter_app/widget/unread_message.dart';
import 'package:flutter_app/widget/url.dart';
import 'package:flutter_dialogflow/v2/message.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import '../constants.dart';
import 'carousel_dialog_slider.dart';
import 'chat_message.dart';
import 'movie_just_watch.dart';
import 'movie_provider.dart';
import 'multi_select.dart';
import 'tips.dart';

class ChatBotUI extends StatefulWidget{
  final bool selectedTips;

  ChatBotUI(this.selectedTips);

  @override
  _ChatBotUIState createState() => _ChatBotUIState();
}

class _ChatBotUIState extends State<ChatBotUI> with WidgetsBindingObserver {
  Timer _uiInactivityTimer;
  Timer _absoluteInactivityTimer;
  bool _doNotShowTyping = false;
  int _unknownAction = 0;
  bool _isTextFieldEnabled = true;
  int _movieSliderShownCount = 0;
  final List<MessageModel> _messages = [];
  List<dynamic> _selectedGenres = [];
  int _pageNumber = 2;
  final TextEditingController _textController = new TextEditingController();
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _getDialogFlowResponseByEvent(
        WELCOME_EVENT, DEFAULT_PARAMETERS_FOR_EVENT, true);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _messages.removeWhere((element) => element is UnreadMessageModel );
    });
  }

  _startUIInactivityTimer(String eventName) {
    if (widget.selectedTips) {
      _uiInactivityTimer = new Timer(Duration(seconds: TIPS_DURATION), () {
        _showTips(eventName);
      });
    }
  }

  _startAbsoluteInactivityTimer(String eventName) {
    if (widget.selectedTips) {
      _absoluteInactivityTimer =
          new Timer(Duration(seconds: ABSOLUTE_DURATION), () {
        _showTips(eventName);
      });
    }
  }

  void _showTips(String eventName) {
    _getDialogFlowResponseByEvent(
        eventName, DEFAULT_PARAMETERS_FOR_EVENT, false);
  }

  void _handleUserInteraction() {
    stopUITimer();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleUserInteraction,
      behavior: HitTestBehavior.translucent,
      child: Column(children: <Widget>[
        Flexible(
            child: ListView.builder(
          padding: EdgeInsets.all(8.0),
          reverse: true,
          controller: _scrollController,
          itemBuilder: (_, int index) {
            var message = _messages[index];
            if (message != null) {
              switch (message.type) {
                case MessageType.CHAT_MESSAGE:
                  return ChatMessage(
                    text: (message as ChatModel).text,
                    type: (message as ChatModel).chatType,
                  );
                case MessageType.QUICK_REPLY:
                  {
                    FocusScope.of(context).requestFocus(new FocusNode());
                    return QuickReply(
                      quickReplies: (message as ReplyModel).quickReplies,
                      insertQuickReply:
                          (message as ReplyModel).updateQuickReply,
                    );
                  }
                case MessageType.MULTI_SELECT:
                  {
                    FocusScope.of(context).requestFocus(new FocusNode());
                    return MultiSelect(
                      title: (message as MultiSelectModel).text,
                      buttons: (message as MultiSelectModel).buttons,
                      insertMultiSelect:
                          (message as MultiSelectModel).updateMultiSelect,
                      previouslySelected: _selectedGenres,
                    );
                  }
                case MessageType.CAROUSEL:
                  {
                    FocusScope.of(context).requestFocus(new FocusNode());
                    return CarouselDialogSlider(
                        (message as CarouselModel).carouselSelect,
                        _movieItemClicked);
                  }
                case MessageType.MOVIE_PROVIDER_URL:
                  return Url(
                      title: (message as MovieProviderUrlModel).name,
                      url: (message as MovieProviderUrlModel).text);
                case MessageType.MOVIE_PROVIDER:
                  return MovieProvider(
                      title: (message as MovieProviderModel).text,
                      logos: (message as MovieProviderModel).logos);
                case MessageType.MOVIE_TRAILER:
                  return MovieThumbnail(
                      url: (message as MovieTrailerModel).url,
                      thumbNail: (message as MovieTrailerModel).thumbNail);
                case MessageType.MOVIE_JUST_WATCH:
                  return MovieJustWatch(
                      title: (message as MovieJustWatchModel).name);
                case MessageType.TIPS_MESSAGE:
                  return Tips(text: (message as TipsModel).text);
                case MessageType.UNREAD_MESSAGE:
                  return UnreadMessage((message as UnreadMessageModel).messageUnreadStatus);
              }
            }
            return Container();
          },
          itemCount: _messages.length,
        )),
        Visibility(
          visible: !_doNotShowTyping,
          child: Container(
            alignment: Alignment.topLeft,
            margin: EdgeInsets.all(10.0),
            child: Text(
              'Bot is typing...',
              style: Theme.of(context).textTheme.headline,
            ),
          ),
        ),
        Divider(height: 1.0),
        Container(
          decoration: new BoxDecoration(color: Theme.of(context).cardColor),
          child: TextComposer(_textController, _textEditorChanged,
              _handleSubmitted, _isTextFieldEnabled),
        ),
      ]),
    );
  }

  void _selectGenres(List<dynamic> selectedGenres) {
    _scrollToBottom();
    _selectedGenres = selectedGenres;
    var genres = jsonEncode(selectedGenres.toList());
    var parameters = "'parameters' : { 'movie-genres': $genres }";
    _getDialogFlowResponseByEvent(
        GENRES_SELECTED_OR_IGNORED, parameters, false);
  }

  Future<void> _movieItemClicked(String movieId) async {
    try {
      var _countryCode = 'US';
      var currentPosition = await Geolocator.getCurrentPosition();
      var placeMarks = await placemarkFromCoordinates(
          currentPosition.latitude, currentPosition.longitude);
      if (placeMarks != null && placeMarks.length > 0) {
        _countryCode = placeMarks[0].isoCountryCode;
      }
      var parameters =
          "'parameters' : { 'movie_id':  $movieId, 'country_code': '$_countryCode'}";
      _getDialogFlowResponseByEvent(MOVIE_TAPPED_EVENT, parameters, false);
    } catch (error) {
      _defaultResponse.call();
      print(error);
    }
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      0.0,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
    );
  }

  void _insertQuickReply(String reply) {
    setState(() {
      _messages.removeAt(0);
    });
    _showChatMessage(reply, true, true);

    if (reply.toLowerCase() == SHOW_GENRES) {
      _pageNumber = 2;
      _getDialogFlowResponse(reply);
      return;
    }
    if (reply.toLowerCase() == IGNORE_GENRES) {
      _pageNumber = 2;
      _getDialogFlowResponseByEvent(
          GENRES_SELECTED_OR_IGNORED, DEFAULT_PARAMETERS_FOR_EVENT, false);
      return;
    }
    if (reply.toLowerCase() == SAME_CRITERIA) {
      var param = "'parameters' : { 'page-number':  $_pageNumber }";
      _getDialogFlowResponseByEvent(SAME_CRITERIA_EVENT, param, false);
      _pageNumber = _pageNumber + 1;
      return;
    }
    _getDialogFlowResponse(reply);
  }

  void _getDialogFlowResponse(query) async {
    _textController.clear();
    setState(() {
      _doNotShowTyping = false;
    });

    DetectDialogResponses detectDialogResponses = new DetectDialogResponses(
        query: query,
        queryInputType: QUERY_INPUT_TYPE.QUERY,
        executeResponse: _executeResponse,
        defaultResponse: _defaultResponse);

    detectDialogResponses.callDialogFlow();
  }

  void _getDialogFlowResponseByEvent(
      String eventName, dynamic parameters, bool firstTime) async {
    _textController.clear();
    setState(() {
      _doNotShowTyping = firstTime ?? false;
    });
    DetectDialogResponses detectDialogResponses = new DetectDialogResponses(
        executeResponse: _executeResponse,
        eventName: eventName,
        parameters: parameters,
        queryInputType: QUERY_INPUT_TYPE.EVENT,
        defaultResponse: _defaultResponse);

    detectDialogResponses.callDialogFlow();
  }

  void _defaultResponse() {
    _showChatMessage(DEFAULT_RESPONSE, false, true);
  }

  void _showChatMessage(String text, bool chatType, bool doNotShowTyping) {
    setState(() {
      _isTextFieldEnabled = true;
      _doNotShowTyping = doNotShowTyping;
      var chatModel = new ChatModel(
          type: MessageType.CHAT_MESSAGE, text: text, chatType: chatType);
      _messages.insert(0, chatModel);
    });
  }

  void _executeResponse(AIResponse response) {
    setState(() {
      _isTextFieldEnabled = true;
      _messages.removeWhere((element) => element is UnreadMessageModel );
    });
    if (response != null) {
      var action = response.getAction();
      if (ACTION_START_OVER == action) {
        _getDialogFlowResponseByEvent(
            START_OVER_EVENT, DEFAULT_PARAMETERS_FOR_EVENT, false);
      }
      if (ACTION_TRIGGER_TIPS == action) {
        _scrollToBottom();
        setState(() {
          _doNotShowTyping = true;
          var chatModel = new TipsModel(
              type: MessageType.TIPS_MESSAGE,
              text: response.getMessage() ??
                  response.getListMessage()[0]['text']['text'][0]);
          _messages.insert(0, chatModel);
        });
        stopAbsoluteTimer();
        stopUITimer();
        return;
      }
      if (ACTION_MOVIE_RECOMMENDATIONS == action) {
        _startUIInactivityTimer(POST_RECOMMENDATION_TIPS_EVENT);
        _startAbsoluteInactivityTimer(POST_RECOMMENDATION_TIPS_EVENT);
      }
      if (ACTION_UNKNOWN == action) {
        _unknownAction++;

        if (widget.selectedTips && _unknownAction == 2) {
          setState(() {
            _unknownAction = 0;
          });
          _startUIInactivityTimer(POST_ERROR_TIPS_EVENT);
          _startAbsoluteInactivityTimer(POST_ERROR_TIPS_EVENT);
        }
      }

      if (response.getListMessage() != null) {
        var payload = response.getListMessage().firstWhere(
            (element) => element.containsKey('payload'),
            orElse: () => null);

        if (payload != null) {
          QuickReplies replies = new QuickReplies(payload['payload']);

          setState(() {
            _scrollToBottom();
            _isTextFieldEnabled = false;
            var replyModel = ReplyModel(
              text: replies.title,
              quickReplies: replies.quickReplies,
              updateQuickReply: _insertQuickReply,
              type: MessageType.QUICK_REPLY,
            );
            _doNotShowTyping = true;
            _messages.insert(
                0,
                new ChatModel(
                    type: MessageType.CHAT_MESSAGE,
                    text: replies.title,
                    chatType: false));

            _messages.insert(0, replyModel);
          });
        } else {
          var carouselSelect = response.getListMessage().firstWhere(
              (element) => element.containsKey('carouselSelect'),
              orElse: () => null);

          if (carouselSelect != null) {
            CarouselSelect carouselSelect =
                new CarouselSelect(response.getListMessage()[0]);

            if (_movieSliderShownCount == 0) {
              _movieSliderShownCount++;
              setState(() {
                var chatModel = new ChatModel(
                    type: MessageType.CHAT_MESSAGE,
                    text: MOVIE_RESPONSE,
                    chatType: false);
                _messages.insert(0, chatModel);
              });

              Future.delayed(const Duration(milliseconds: 2000), () {
                setState(() {
                  var chatModel = new ChatModel(
                      type: MessageType.CHAT_MESSAGE,
                      text: ASK_FOR_MORE,
                      chatType: false);
                  _messages.insert(0, chatModel);
                });
                Future.delayed(const Duration(milliseconds: 2000), () {
                  setState(() {
                    _doNotShowTyping = true;
                    _isTextFieldEnabled = true;
                    var carouselModel = CarouselModel(
                      carouselSelect: carouselSelect,
                      type: MessageType.CAROUSEL,
                    );
                    _messages.insert(0, carouselModel);
                  });
                });
              });
            } else {
              if (_movieSliderShownCount < 5)
                _movieSliderShownCount++;
              else
                _movieSliderShownCount = 0;

              setState(() {
                _doNotShowTyping = true;
                _isTextFieldEnabled = true;
                var carouselModel = CarouselModel(
                  carouselSelect: carouselSelect,
                  type: MessageType.CAROUSEL,
                );
                _messages.insert(0, carouselModel);
              });
            }
          } else {
            _scrollToBottom();
            var multiSelect = response.getListMessage().firstWhere(
                (element) => element.containsKey('card'),
                orElse: () => null);

            if (multiSelect != null) {
              CardDialogflow card =
                  new CardDialogflow(response.getListMessage()[0]);

              setState(() {
                _selectedGenres = [];
                _isTextFieldEnabled = false;
                var multiSelectModel = MultiSelectModel(
                  text: card.title,
                  buttons: card.buttons,
                  updateMultiSelect: _selectGenres,
                  type: MessageType.MULTI_SELECT,
                );
                _doNotShowTyping = true;
                _messages.insert(0, multiSelectModel);
              });
            } else {
              if (response.getWebHookPayload() != null &&
                  response.getWebHookPayload().containsKey('movieDetail')) {
                setState(() {
                  var unreadMessageModel = new UnreadMessageModel(
                      type: MessageType.UNREAD_MESSAGE,
                      messageUnreadStatus: true);
                  _messages.insert(0, unreadMessageModel);
                });

                var movieDetails = response.getWebHookPayload()['movieDetail'];
                var videos = response.getWebHookPayload()['videos'];

                MovieProvidersAndVideoModel movieProviders =
                    new MovieProvidersAndVideoModel(movieDetails, videos);
                setState(() {
                  _doNotShowTyping = true;
                  if (movieProviders.title != null &&
                      movieProviders.title != "") {
                    _messages.insert(
                        0,
                        new MovieJustWatchModel(
                            type: MessageType.MOVIE_JUST_WATCH,
                            title: movieProviders.title));
                  }
                  if (movieProviders.providers != null &&
                      movieProviders.providers.length > 0) {
                    movieProviders.providers.forEach((provider) {
                      _messages.insert(
                          0,
                          new MovieProviderModel(
                              text: provider.title,
                              type: MessageType.MOVIE_PROVIDER,
                              logos: provider.logos));
                    });
                  }
                  if (movieProviders.videoUrl != null) {
                    _messages.insert(
                        0,
                        new MovieTrailerModel(
                          url: movieProviders.videoUrl,
                          thumbNail: movieProviders.videoThumbnail,
                          type: MessageType.MOVIE_TRAILER,
                        ));
                  }
                });
              } else {
                _scrollToBottom();
                setState(() {
                  _doNotShowTyping = true;
                  var chatModel = new ChatModel(
                      type: MessageType.CHAT_MESSAGE,
                      text: response.getMessage() ??
                          response.getListMessage()[0]['text']['text'][0],
                      chatType: false);
                  _messages.insert(0, chatModel);
                });
              }
            }
          }
        }
      }
    }
  }

  void _handleSubmitted(String text) {
    stopUITimer();
    stopAbsoluteTimer();
    if (text != "") {
      _textController.clear();
      setState(() {
        _doNotShowTyping = false;
        var chatModel = new ChatModel(
            type: MessageType.CHAT_MESSAGE, text: text, chatType: true);
        _messages.insert(0, chatModel);
      });
      _getDialogFlowResponse(text);
    }
  }

  void stopAbsoluteTimer() {
    if (_absoluteInactivityTimer != null) {
      _absoluteInactivityTimer.cancel();
    }
  }

  void stopUITimer() {
    if (_uiInactivityTimer != null) {
      _uiInactivityTimer.cancel();
    }
  }

  void _textEditorChanged(String text) {
    stopUITimer();
    stopAbsoluteTimer();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    stopUITimer();
    stopAbsoluteTimer();
    super.dispose();
  }
}
