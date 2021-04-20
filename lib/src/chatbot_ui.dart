import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/src/domain/ai_response.dart';
import 'package:flutter_app/src/models/carousel_model.dart';
import 'package:flutter_app/src/models/chat_model.dart';
import 'package:flutter_app/src/models/message_model.dart';
import 'package:flutter_app/src/models/movie_just_watch_model.dart';
import 'package:flutter_app/src/models/movie_provider_model.dart';
import 'package:flutter_app/src/models/movie_provider_url_model.dart';
import 'package:flutter_app/src/models/movie_providers_model.dart';
import 'package:flutter_app/src/models/movie_trailer_model.dart';
import 'package:flutter_app/src/models/multi_select_model.dart';
import 'package:flutter_app/src/models/reply_model.dart';
import 'package:flutter_app/src/models/tips_model.dart';
import 'package:flutter_app/src/models/unread_message_model.dart';
import 'package:flutter_app/src/resources/detect_dialog_responses.dart';
import 'package:flutter_app/src/ui/movie_details/movie_detail_widget.dart';
import 'package:flutter_app/src/ui/originalmoviedetails/movie_thumbnail.dart';
import 'package:flutter_app/src/ui/text_composer.dart';
import 'package:flutter_app/src/ui/typing_indicator.dart';
import 'package:flutter_app/src/ui/unread_message.dart';
import 'package:flutter_app/src/ui/url.dart';
import 'package:flutter_dialogflow/v2/message.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'domain/constants.dart';
import 'ui/carousel_dialog_slider.dart';
import 'ui/chat_message.dart';
import 'ui/movie_details/movie_just_watch.dart';
import 'ui/movie_provider.dart';
import 'ui/multiselect/multi_select.dart';
import 'ui/quick_reply.dart';
import 'ui/tips.dart';

class ChatBotUI extends StatefulWidget {
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
  bool _isTextFieldEnabled = false;
  bool _isLoading = false;
  bool _removeNoPreferenceQuickReply = false;
  int _movieSliderShownCount = 0;
  final List<MessageModel> _messages = [];
  List<dynamic> _selectedGenres = [];
  int _pageNumber = 2;
  bool _isCountryChanged = false;
  bool _shouldShowTwinkleButton = false;
  final TextEditingController _textController = new TextEditingController();
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _deleteDialogFlowContexts();
    _callWelcomeIntent();
    super.initState();
  }

  Future<void> _callWelcomeIntent() async {
    var countryCode = await _getCountryCode();
    var parameters = "'parameters' : { 'watch-region' : '$countryCode' }";
    _getDialogFlowResponseByEvent(WELCOME_EVENT, parameters, true);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _messages.removeWhere((element) => element is UnreadMessageModel);
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
      child: Stack(
        children: [
          Column(children: <Widget>[
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
                        _disableKeyboardForAndroid(context);
                        return QuickReply(
                          quickReplies: (message as ReplyModel).quickReplies,
                          insertQuickReply:
                              (message as ReplyModel).updateQuickReply,
                        );
                      }
                    case MessageType.MULTI_SELECT:
                      {
                        _disableKeyboardForAndroid(context);
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
                        _disableKeyboardForAndroid(context);
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
                      return UnreadMessage();
                  }
                }
                return Container();
              },
              itemCount: _messages.length,
            )),
            Align(
              alignment: Alignment.bottomLeft,
              child: TypingIndicator(
                showIndicator: !_doNotShowTyping,
              ),
            ),
            Divider(height: 1.0),
            TextComposer(
              textController: _textController,
              textEditorChanged: _textEditorChanged,
              handleSubmitted: _handleSubmitted,
              isTextFieldEnabled: _isTextFieldEnabled,
              shouldShowTwinkleButton: _shouldShowTwinkleButton,
              handleTwinkleButton: _handleTwinkleButton,
            ),
          ]),
          Center(
            child: Container(
              width: 40,
              height: 40,
              child: Visibility(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.white,
                ),
                visible: _isLoading,
              ),
            ),
          )
        ],
      ),
    );
  }

  void _disableKeyboardForAndroid(BuildContext context) {
    if (Platform.isAndroid)
      FocusScope.of(context).requestFocus(new FocusNode());
  }

  Future<void> _multiSelectItemClicked(String value, bool isSelected) async {
    setState(() {
      // _messages.removeAt(0);
      //_isTextFieldEnabled = true;
      if (isSelected) {
        _textController.text = _textController.text.isEmpty
            ? value
            : _textController.text + ', ' + value;
      } else {
        if (_textController.text.contains(value)) {
          _textController.text =
              _textController.text.replaceAll(value, "").trim();
        }
      }
      if (_textController.text.isEmpty) {
        _shouldShowTwinkleButton = false;
      } else {
        _shouldShowTwinkleButton = true;
      }
    });
    // if (selectedGenres.isEmpty) {
    //   _showChatMessage(ALL_GENRES_TEXT, true, true);
    // } else {
    //   _showChatMessage(
    //       SELECTED_GENRES_TEXT + selectedGenres
    //
    //
    //
    //    .join("\n - "), true, true);
    // }

    // _scrollToBottom();
    //_selectedGenres = selectedGenres;
    // var genres = jsonEncode(selectedGenres.toList());
    // var countryCode = await _getCountryCode();
    // var parameters =
    //     "'parameters' : { 'genres': $genres , 'watch-region' : '$countryCode' }";
    //TODO - add tv genres
    //  var parameters = "'parameters' : { 'movie-genres': $genres  }";
    //  _getDialogFlowResponseByEvent(WELCOME_EVENT, parameters, false);
    // var genres =
    //     _selectedGenres.reduce((value, element) => value + ", " + element);
    // _getDialogFlowResponse(genres);
  }

  void _handleTwinkleButton(String text) {
    setState(() {
      _shouldShowTwinkleButton = false;
      _messages.removeAt(0);
      _showChatMessage(
          SELECTED_GENRES + text, true, true);
    });
    var list = text.split(" ");
    var genres = jsonEncode(list);
    var parameters = "'parameters' : { 'movie-genres': $genres  }";
    _getDialogFlowResponseByEvent(WELCOME_EVENT, parameters, false);
  }

  Future<void> _movieItemClicked(String movieId) async {
    _stopAllTimers();
    setState(() {
      _isLoading = true;
    });
    String _countryCode = await _getCountryCode();
    await _getWatchProvidersAndVideos(movieId, _countryCode);
  }

  Future<String> _getCountryCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _countryCode = prefs.getString(KEY_COUNTRY_CODE);

    if (_countryCode == null || _countryCode.isEmpty) {
      _countryCode = "IN";
    }
    return _countryCode;
  }

  Future _getWatchProvidersAndVideos(String id, String _countryCode) async {
    var parameters =
        "'parameters' : { 'id':  $id, 'country_code': '$_countryCode'}";
    _getDialogFlowResponseByEvent(
        MOVIE_OR_TV_CARD_TAPPED_EVENT, parameters, true);
  }

  void _stopAllTimers() {
    stopAbsoluteTimer();
    stopUITimer();
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      0.0,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
    );
  }

  Future<void> _insertQuickReply(String reply) async {
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
      String countryCode = await _getCountryCode();
      var parameters = "'parameters' : { 'watch-region' : '$countryCode' }";
      _getDialogFlowResponseByEvent(
          GENRES_SELECTED_OR_IGNORED, parameters, false);
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

  void _deleteDialogFlowContexts() {
    DetectDialogResponses detectDialogResponses = new DetectDialogResponses();
    detectDialogResponses.deleteDialogFlowContexts();
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
      _isLoading = false;
      _messages.removeWhere((element) => element is UnreadMessageModel);
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
              text: response.getChatMessage()[0]);
          _messages.insert(0, chatModel);
        });
        _stopAllTimers();
        return;
      }
      if (ACTION_MOVIE_RECOMMENDATIONS == action ||
          ACTION_MORE_MOVIE_RECOMMENDATIONS == action) {
        _startUIInactivityTimer(POST_RECOMMENDATION_TIPS_EVENT);
        _startAbsoluteInactivityTimer(POST_RECOMMENDATION_TIPS_EVENT);
      }
      // if (ACTION_MOVIE_WATCH_PROVIDERS_TRAILER_VIDEOS == action) {
      //   _startUIInactivityTimer(POST_WATCH_PROVIDERS_TIPS_EVENT);
      //   _startAbsoluteInactivityTimer(POST_WATCH_PROVIDERS_TIPS_EVENT);
      // }
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
        response.getListMessage().forEach((element) {
          var payload = element.containsKey('quickReplies')
              ? element
              : element['payload'];

          if (payload != null) {
            QuickReplies replies = new QuickReplies(payload);
            var quickReplies = replies.quickReplies;
            setState(() {
              _scrollToBottom();
              if (quickReplies != null && quickReplies.length == 1) {
                _removeNoPreferenceQuickReply = true;
                _isTextFieldEnabled = true;
              } else {
                _isTextFieldEnabled = false;
              }
              var replyModel = ReplyModel(
                text: replies.title,
                quickReplies: quickReplies,
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
            var carouselSelect = element['carouselSelect'];
            if (carouselSelect != null) {
              CarouselSelect carouselSelect = new CarouselSelect(element);

              if (_movieSliderShownCount == 0) {
                _stopAllTimers();
                _movieSliderShownCount++;
                setState(() {
                  _isTextFieldEnabled = false;
                  var chatModel = new ChatModel(
                      type: MessageType.CHAT_MESSAGE,
                      text: MOVIE_RESPONSE,
                      chatType: false);
                  _messages.insert(0, chatModel);
                });

                Future.delayed(const Duration(milliseconds: 2000), () {
                  setState(() {
                    _isTextFieldEnabled = false;
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
              var multiSelect = element.containsKey('card');

              if (multiSelect) {
                CardDialogflow card = new CardDialogflow(element);

                setState(() {
                  _selectedGenres = [];
                  _isTextFieldEnabled = false;
                  var multiSelectModel = MultiSelectModel(
                    text: card.title,
                    buttons: card.buttons,
                    updateMultiSelect: _multiSelectItemClicked,
                    type: MessageType.MULTI_SELECT,
                  );
                  _doNotShowTyping = true;
                  _messages.insert(
                      0,
                      new ChatModel(
                          type: MessageType.CHAT_MESSAGE,
                          text: card.title,
                          chatType: false));

                  _messages.insert(0, multiSelectModel);
                });
              } else {
                if (response.getWebHookPayload() != null) {
                  MovieProvidersAndVideoModel movieProviders =
                      new MovieProvidersAndVideoModel(
                          response.getWebHookPayload());
                  setState(() {
                    _doNotShowTyping = true;
                    _handleNewUIForMovieDetails(movieProviders);
                  });
                } else {
                  _scrollToBottom();
                  var queryText = element['text']['text'] != null &&
                          element['text']['text'][0] != ""
                      ? element['text']['text'][0]
                      : DEFAULT_RESPONSE;

                  setState(() {
                    _doNotShowTyping = true;
                    var chatModel = new ChatModel(
                        type: MessageType.CHAT_MESSAGE,
                        text: queryText,
                        chatType: false);
                    _messages.insert(0, chatModel);
                  });
                }
              }
            }
          }
        });
      }
    }
  }

  void _handleSubmitted(String text) {
    _stopAllTimers();

    if (text.trim() != "") {
      _textController.clear();
      setState(() {
        _doNotShowTyping = false;
        if (_removeNoPreferenceQuickReply && _messages.first is ReplyModel) {
          _messages.removeAt(0);
          _removeNoPreferenceQuickReply = false;
        }
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
    _stopAllTimers();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _textController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    _stopAllTimers();
    super.dispose();
  }

  Future<void> _handleNewUIForMovieDetails(
      MovieProvidersAndVideoModel movieProviders) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var cupertinoPageRoute = CupertinoPageRoute(
        builder: (context) =>
            MovieDetailWidget(movieProviders, prefs, _onCountryChanged));
    var materialPageRoute = MaterialPageRoute(
        builder: (context) =>
            MovieDetailWidget(movieProviders, prefs, _onCountryChanged));

    if (_isCountryChanged) {
      _isCountryChanged = false;
      Platform.isIOS
          ? Navigator.pushReplacement(
              context,
              cupertinoPageRoute,
            )
          : Navigator.pushReplacement(
              context,
              materialPageRoute,
            );
    } else {
      Platform.isIOS
          ? Navigator.push(
              context,
              cupertinoPageRoute,
            )
          : Navigator.push(
              context,
              materialPageRoute,
            );
    }
  }

  Future<void> _onCountryChanged(String id, String countryCode) async {
    await _getWatchProvidersAndVideos(id, countryCode);
    _isCountryChanged = true;
  }
}
