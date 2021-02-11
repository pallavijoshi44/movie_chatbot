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
import 'package:flutter_app/models/movie_trailer_model.dart';
import 'package:flutter_app/models/multi_select_model.dart';
import 'package:flutter_app/models/reply_model.dart';
import 'package:flutter_app/widget/movie_thumbnail.dart';
import 'package:flutter_app/widget/quick_reply.dart';
import 'package:flutter_app/widget/text_composer.dart';
import 'package:flutter_app/widget/url.dart';
import 'package:flutter_dialogflow/v2/message.dart';

import '../constants.dart';
import 'carousel_dialog_slider.dart';
import 'chat_message.dart';
import 'movie_provider.dart';
import 'multi_select.dart';

class ChatBotUI extends StatefulWidget {
  @override
  _ChatBotUIState createState() => _ChatBotUIState();
}

class _ChatBotUIState extends State<ChatBotUI> {
  bool _doNotShowTyping = false;
  bool _isTextFieldEnabled = true;
  final List<MessageModel> _messages = [];
  List<String> _selectedGenres = [];
  int _pageNumber = 2;
  final TextEditingController _textController = new TextEditingController();
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    _getDialogFlowResponseByEvent(
        WELCOME_EVENT, DEFAULT_PARAMETERS_FOR_EVENT, true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Flexible(
          child: ListView.builder(
            padding: EdgeInsets.all(8.0),
            reverse: true,
            controller: _scrollController,
            itemBuilder: (_, int index) {
              var message = _messages[index];
              if (message != null) {
                if (message.type == MessageType.CHAT_MESSAGE) {
                  return ChatMessage(
                    text: (message as ChatModel).text,
                    name: (message as ChatModel).name,
                    type: (message as ChatModel).chatType,
                  );
                }
                if (message.type == MessageType.QUICK_REPLY) {
                  FocusScope.of(context).requestFocus(new FocusNode());
                  return QuickReply(
                    title: (message as ReplyModel).text,
                    quickReplies: (message as ReplyModel).quickReplies,
                    insertQuickReply: (message as ReplyModel).updateQuickReply,
                    name: (message as ReplyModel).name,
                    isEnabled: (message as ReplyModel).enabled,
                  );
                }
                if (message.type == MessageType.MULTI_SELECT) {
                  FocusScope.of(context).requestFocus(new FocusNode());
                  return MultiSelect(
                    title: (message as MultiSelectModel).text,
                    buttons: (message as MultiSelectModel).buttons,
                    insertMultiSelect:
                    (message as MultiSelectModel).updateMultiSelect,
                    name: (message as MultiSelectModel).name,
                    previouslySelected: _selectedGenres,
                  );
                }
                if (message.type == MessageType.CAROUSEL) {
                  FocusScope.of(context).requestFocus(new FocusNode());
                  return CarouselDialogSlider(
                      (message as CarouselModel).carouselSelect,
                      _carouselItemClicked);
                }
                if (message.type == MessageType.MOVIE_PROVIDER_URL) {
                  return Url(
                      title: (message as MovieProviderUrlModel).name,
                      url: (message as MovieProviderUrlModel).text);
                }
                if (message.type == MessageType.MOVIE_PROVIDER) {
                  return MovieProvider(
                      title: (message as MovieProviderModel).text,
                      logos: (message as MovieProviderModel).logos);
                }
                if (message.type == MessageType.MOVIE_TRAILER) {
                  return MovieThumbnail(
                      url: (message as MovieTrailerModel).url,
                      thumbNail: (message as MovieTrailerModel).thumbNail
                  );
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
            style: Theme
                .of(context)
                .textTheme
                .headline,
          ),
        ),
      ),
      Divider(height: 1.0),
      Container(
        decoration: new BoxDecoration(color: Theme
            .of(context)
            .cardColor),
        child: TextComposer(_textController, _textEditorChanged,
            _handleSubmitted, _isTextFieldEnabled),
      ),
    ]);
  }

  void _insertMultiSelect(List<String> selectedGenres) {
    _scrollToBottom();
    _selectedGenres = selectedGenres;
    var genres = jsonEncode(selectedGenres.toList());
    var parameters = "'parameters' : { 'movie-genres': $genres }";
    _getDialogFlowResponseByEvent(
        GENRES_SELECTED_OR_IGNORED, parameters, false);
  }

  void _carouselItemClicked(String countryCode, String movieId) {
    // "country_code": {
    // "name": "Belgium",
    // "alpha-2": "BE",
    // "alpha-3": "BEL",
    // "numeric": 56
    // },
    var parameters = "'parameters' : { 'movie_id':  $movieId, 'country_code': '$countryCode'}";
    _scrollToBottom();
    _getDialogFlowResponseByEvent(MOVIE_TAPPED_EVENT, parameters, false);
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      0.0,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
    );
  }

  void _insertQuickReply(String reply) {
    if (_messages[0] is ReplyModel) {
      (_messages[0] as ReplyModel).enabled = false;
    }
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

  void _getDialogFlowResponseByEvent(String eventName, dynamic parameters,
      bool firstTime) async {
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
    setState(() {
      _isTextFieldEnabled = true;
      _doNotShowTyping = true;
      var chatModel = new ChatModel(
          name: "Bot",
          type: MessageType.CHAT_MESSAGE,
          text: DEFAULT_RESPONSE,
          chatType: false);
      _messages.insert(0, chatModel);
    });
  }

  void _executeResponse(AIResponse response) {
    _scrollToBottom();

    setState(() {
      _isTextFieldEnabled = true;
    });
    if (response != null) {
      var action = response.getAction();
      if (ACTION_START_OVER == action) {
        _getDialogFlowResponseByEvent(
            START_OVER_EVENT, DEFAULT_PARAMETERS_FOR_EVENT, false);
      }
      if (response.getListMessage() != null) {
        var payload = response.getListMessage().firstWhere(
                (element) => element.containsKey('payload'),
            orElse: () => null);

        if (payload != null) {
          QuickReplies replies = new QuickReplies(payload['payload']);

          setState(() {
            _isTextFieldEnabled = false;
            var replyModel = ReplyModel(
              text: replies.title,
              name: "Bot",
              quickReplies: replies.quickReplies,
              updateQuickReply: _insertQuickReply,
              type: MessageType.QUICK_REPLY,
              enabled: true
            );
            _doNotShowTyping = true;
            _messages.insert(0, replyModel);
          });
        } else {
          var carouselSelect = response.getListMessage().firstWhere(
                  (element) => element.containsKey('carouselSelect'),
              orElse: () => null);

          if (carouselSelect != null) {
            CarouselSelect carouselSelect =
            new CarouselSelect(response.getListMessage()[0]);

            setState(() {
              var carouselModel = CarouselModel(
                name: "Bot",
                carouselSelect: carouselSelect,
                type: MessageType.CAROUSEL,
              );
              _doNotShowTyping = true;
              _messages.insert(0, carouselModel);
            });
          } else {
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
                  name: "Bot",
                  buttons: card.buttons,
                  updateMultiSelect: _insertMultiSelect,
                  type: MessageType.MULTI_SELECT,
                );
                _doNotShowTyping = true;
                _messages.insert(0, multiSelectModel);
              });
            } else {
              if (response.getWebHookPayload() != null &&
                  response.getWebHookPayload().containsKey('movieDetail')) {
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
                        new ChatModel(
                            name: "Bot",
                            type: MessageType.CHAT_MESSAGE,
                            text: movieProviders.title,
                            chatType: false));
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
                  if (movieProviders.urlTitle != null &&
                      movieProviders.urlTitle != "" &&
                      movieProviders.urlLink != null &&
                      movieProviders.urlLink != "") {
                    _messages.insert(
                        0,
                        new MovieProviderUrlModel(
                            url: movieProviders.urlLink,
                            type: MessageType.MOVIE_PROVIDER_URL,
                            title: movieProviders.urlTitle));
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
                setState(() {
                  _doNotShowTyping = true;
                  var chatModel = new ChatModel(
                      name: "Bot",
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
    if (text != "") {
      _textController.clear();
      setState(() {
        _doNotShowTyping = false;
        var chatModel = new ChatModel(
            name: "Pallavi",
            type: MessageType.CHAT_MESSAGE,
            text: text,
            chatType: true);
        _messages.insert(0, chatModel);
      });
      _getDialogFlowResponse(text);
    }
  }

  void _textEditorChanged(String text) {
    setState(() {
      _doNotShowTyping = text.length > 0 || text == "";
    });
  }
}
