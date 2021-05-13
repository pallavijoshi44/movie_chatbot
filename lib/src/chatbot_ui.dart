import 'dart:async';
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
import 'package:flutter_app/src/models/movie_trailer_model.dart';
import 'package:flutter_app/src/models/multi_select_model.dart';
import 'package:flutter_app/src/models/reply_model.dart';
import 'package:flutter_app/src/models/settings_model.dart';
import 'package:flutter_app/src/models/tips_model.dart';
import 'package:flutter_app/src/models/tmdb/moviedetails/movie_detail_bloc.dart';
import 'package:flutter_app/src/models/tmdb/moviedetails/movie_tv_details.dart';
import 'package:flutter_app/src/models/unread_message_model.dart';
import 'package:flutter_app/src/resources/detect_dialog_responses.dart';
import 'package:flutter_app/src/ui/movie_details/movie_detail_widget.dart';
import 'package:flutter_app/src/ui/originalmoviedetails/movie_thumbnail.dart';
import 'package:flutter_app/src/ui/text_composer.dart';
import 'package:flutter_app/src/ui/typing_indicator.dart';
import 'package:flutter_app/src/ui/unread_message.dart';
import 'package:flutter_app/src/ui/url.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dialogflow/v2/message.dart';

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
  final SettingsModel settings;

  ChatBotUI(this.selectedTips, this.settings);

  @override
  _ChatBotUIState createState() => _ChatBotUIState();
}

class _ChatBotUIState extends State<ChatBotUI> with WidgetsBindingObserver {
  Timer _uiInactivityTimer;
  Timer _absoluteInactivityTimer;
  bool _doNotShowTyping = true;
  int _unknownAction = 0;
  bool _isTextFieldEnabled = false;
  bool _removeNoPreferenceQuickReply = false;
  final List<MessageModel> _messages = [];
  List<dynamic> _selectedGenres = [];
  int _pageNumber = 2;
  bool _isCountryChanged = false;
  bool _shouldShowTwinkleButton = false;
  List<String> _helpContent = [];
  bool _helpContentClickable = false;
  final TextEditingController _textController = new TextEditingController();
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _callWelcomeIntent(true);

    widget.settings.countryCode.listen((value) {
      _changeCountryCode();
    });
    super.initState();
  }

  Future<void> _callWelcomeIntent(bool clearMessages) async {
    if (clearMessages) {
      _messages.clear();
    }
    _deleteDialogFlowContexts();
    var countryCode = _getCountryCode();
    var parameters = "'parameters' : { 'country-code' : '$countryCode' }";
    _getDialogFlowResponseByEvent(WELCOME_EVENT, parameters, true);
  }

  Future<void> _changeCountryCode() async {
    var countryCode = _getCountryCode();
    var parameters = "'parameters' : { 'country-code' : '$countryCode' }";
    _getDialogFlowResponseByEvent(CHANGE_COUNTRY_EVENT, parameters, false);
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
                        return QuickReply(
                          quickReplies: (message as ReplyModel).quickReplies,
                          insertQuickReply:
                              (message as ReplyModel).updateQuickReply,
                        );
                      }
                    case MessageType.MULTI_SELECT:
                      {
                        return MultiSelect(
                            title: (message as MultiSelectModel).text,
                            buttons: (message as MultiSelectModel).buttons,
                            insertMultiSelect:
                                (message as MultiSelectModel).updateMultiSelect,
                            previouslySelected: _selectedGenres,
                            containsNoPreference: (message as MultiSelectModel)
                                .containsNoPreference);
                      }
                    case MessageType.CAROUSEL:
                      {
                        return CarouselDialogSlider(message as CarouselModel,
                            _movieItemClicked, widget.settings, _constructHelpContent);
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
            Visibility(
              visible: !_doNotShowTyping,
              child: Align(
                alignment: Alignment.bottomLeft,
                child: TypingIndicator(
                  showIndicator: !_doNotShowTyping,
                ),
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
                helpContent: _helpContent,
                helpContentClickable: _helpContentClickable),
          ]),
          // _firstTimeOverlayWidget(context),
          BlocConsumer<MovieDetailsBloc, MovieDetailsState>(
            builder: (BuildContext context, state) {
              if (state is MovieDetailsLoading) {
                return Center(
                  child: Container(
                      width: 40,
                      height: 40,
                      child: Platform.isIOS
                          ? Image.asset(
                              "packages/loading_gifs/assets/images/cupertino_activity_indicator.gif",
                              scale: 5)
                          : Image.asset(
                              "packages/loading_gifs/assets/images/circular_progress_indicator.gif",
                              scale: 10)),
                );
              }
              return Container();
            },
            listener: (BuildContext context, state) {
              if (state is MovieDetailsLoaded) {
                _handleNewUIForMovieDetails(state.model);
              }
              if (state is MovieDetailsError) {
                _defaultResponse();
              }
            },
          ),
          Align(
            alignment: Alignment.topRight,
            child: FloatingActionButton(
              foregroundColor: Colors.deepOrangeAccent,
              backgroundColor: Colors.orange[200],
              child: new Icon(
                  Platform.isIOS ? CupertinoIcons.refresh : Icons.refresh),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext ctx) {
                    return Platform.isIOS
                        ? CupertinoAlertDialog(
                            title: Text(SHOULD_REFRESH_TEXT),
                            actions: <Widget>[
                              CupertinoButton(
                                child: Text(YES),
                                onPressed: () async {
                                  Navigator.of(ctx).pop();
                                  _callWelcomeIntent(true);
                                },
                              ),
                              CupertinoButton(
                                child: Text(NO),
                                onPressed: () async {
                                  Navigator.of(ctx).pop();
                                },
                              ),
                            ],
                          )
                        : AlertDialog(
                            title: Text(SHOULD_REFRESH_TEXT),
                            actions: <Widget>[
                              TextButton(
                                child: Text(YES),
                                onPressed: () async {
                                  Navigator.of(ctx).pop();
                                  _callWelcomeIntent(true);
                                },
                              ),
                              TextButton(
                                child: Text(NO),
                                onPressed: () async {
                                  Navigator.of(ctx).pop();
                                },
                              ),
                            ],
                          );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _disableKeyboardForAndroid(BuildContext context) {
    if (Platform.isAndroid)
      FocusScope.of(context).requestFocus(new FocusNode());
  }

  Future<void> _multiSelectItemClicked(String value, bool isSelected,
      String selectedText, bool noPreferenceSelected) async {
    setState(() {
      _isTextFieldEnabled = true;
      if (noPreferenceSelected && isSelected) {
        _textController.text = value;
      } else {
        _textController.text = selectedText;
      }

      if (_textController.text.isEmpty) {
        _shouldShowTwinkleButton = false;
      } else {
        _shouldShowTwinkleButton = true;
      }
    });
  }

  void _handleTwinkleButton(String text) {
    setState(() {
      _shouldShowTwinkleButton = false;
      _messages.removeAt(0);
      _showChatMessage(text, true, true);
    });
    _getDialogFlowResponse(text);
  }

  Future<void> _movieItemClicked(
      String movieId, EntertainmentType entertainmentType) async {
    _stopAllTimers();
    String _countryCode = _getCountryCode();
    context.read<MovieDetailsBloc>().add(MovieDetailsEvent(
        id: movieId,
        countryCode: _countryCode,
        entertainmentType: entertainmentType,
        eventStatus: EventStatus.fetchMovieDetails));
    //  await _getWatchProvidersAndVideos(movieId, _countryCode);
  }

  String _getCountryCode() {
    String _countryCode = widget.settings.countryCode.getValue();
    return _countryCode;
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

  void _insertQuickReply(String reply, bool isTapped) {
    if (isTapped) {
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
        String countryCode = _getCountryCode();
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
  }

  Future<void> handleFilterContents(eventName, parameters) async {
    setState(() {
      _doNotShowTyping = true;
      // _messages.removeAt(0);
      //_messages.removeWhere((element) => element is CarouselModel);
    });
    _getDialogFlowResponseByEvent(eventName, parameters, true);
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
     // _isTextFieldEnabled = true;
      _doNotShowTyping = doNotShowTyping;
      var chatModel = new ChatModel(
          type: MessageType.CHAT_MESSAGE, text: text, chatType: chatType);
      _messages.insert(0, chatModel);
    });
  }

  void _executeResponse(AIResponse response) {
    setState(() {
      _isTextFieldEnabled = false;
      _doNotShowTyping = true;
    });
    if (response != null) {
      var action = response.getAction();
      if (ACTION_START_OVER == action) {
        _callWelcomeIntent(false);
      }
      if (ACTION_CHANGE_COUNTRY == action) {
        return;
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
      _handleTimers(action);

      if (response.containsHelpContent()) {
        _constructHelpContent(response.helpContent(), response.isHelpContentClickable());
      }

      if (response.containsMultiSelect()) {
        _constructMultiSelect(response.getMultiSelectResponse());
        return;
      }

      if (response.containsCard()) {
        _constructMultiSelect(response.getCard());
        return;
      }

      if (response.containsMovieDetails()) {
        _constructMovieDetails(response.getMovieDetails());
        return;
      }
      if (response.containsQuickReplies()) {
        var payload = response.getPayload();
        _constructQuickReplies(payload);
        return;
      }

      if (response.containsMovieOrTvRecommendationsActions()) {
        _constructCarousel(response);
        return;
      }

      _constructChatMessage(response.getDefaultOrChatMessage());
      return;
    }
  }

  void _handleTimers(String action) {
    if (ACTION_MOVIE_RECOMMENDATIONS == action ||
        ACTION_MORE_MOVIE_RECOMMENDATIONS == action) {
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
  }

  void _constructChatMessage(element) {
    _scrollToBottom();
    setState(() {
      _doNotShowTyping = true;
      var chatModel = new ChatModel(
          type: MessageType.CHAT_MESSAGE,
          text: element[0] ?? DEFAULT_RESPONSE,
          chatType: false);
      _messages.insert(0, chatModel);
    });
  }

  void _constructMovieDetails(response) {
    MovieTvDetailsModel movieProviders = new MovieTvDetailsModel(response);
    setState(() {
      _doNotShowTyping = true;
      _handleNewUIForMovieDetails(movieProviders);
    });
  }

  void _constructHelpContent(List<dynamic> helpContent, bool isClickable) {
    setState(() {
      _isTextFieldEnabled = true;
      _helpContent = [];
      _helpContentClickable = isClickable;
      helpContent.forEach((content) {
        _helpContent.add(content['text']);
      });
    });
  }

  void _constructMultiSelect(response) {
    CardDialogflow card = new CardDialogflow(response);
    bool isTextFieldEnabled = response['enableTextField'];
    bool containsNoPreference = response['containsNoPreference'];

    setState(() {
      _selectedGenres = [];
      _isTextFieldEnabled = isTextFieldEnabled ?? false;
      var multiSelectModel = MultiSelectModel(
          text: card.title,
          buttons: card.buttons,
          updateMultiSelect: _multiSelectItemClicked,
          type: MessageType.MULTI_SELECT,
          containsNoPreference: containsNoPreference ?? false);
      _doNotShowTyping = true;

      _messages.insert(
          0,
          new ChatModel(
              type: MessageType.CHAT_MESSAGE,
              text: card.title,
              chatType: false));

      _messages.insert(0, multiSelectModel);
    });
  }

  void _constructCarousel(AIResponse response) {
    setState(() {
      _doNotShowTyping = true;
      _isTextFieldEnabled = true;

      var carouselModel = CarouselModel(
          response: response,
          type: MessageType.CAROUSEL,
          settings: widget.settings);

      _messages.insert(0, carouselModel);
    });
  }

  void _constructQuickReplies(payload) {
    QuickReplies replies = new QuickReplies(payload);
    var quickReplies = replies.quickReplies;
    setState(() {
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
        name: '',
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
  }

  void _handleSubmitted(String text) {
    _messages.removeWhere((element) => element is CarouselModel);

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
      MovieTvDetailsModel movieProviders) async {
    var cupertinoPageRoute = CupertinoPageRoute(
        builder: (context) => MovieDetailWidget(
            movieProviders, widget.settings, _onCountryChanged));
    var materialPageRoute = MaterialPageRoute(
        builder: (context) => MovieDetailWidget(
            movieProviders, widget.settings, _onCountryChanged));

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

  Future<void> _onCountryChanged(String id, String countryCode,
      EntertainmentType entertainmentType) async {
    context.read<MovieDetailsBloc>().add(MovieDetailsEvent(
        id: id,
        countryCode: countryCode,
        entertainmentType: entertainmentType,
        eventStatus: EventStatus.fetchMovieDetails));
    // await _getWatchProvidersAndVideos(id, countryCode);
    _isCountryChanged = true;
  }
}
