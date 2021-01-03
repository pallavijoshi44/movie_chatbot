import 'package:flutter/material.dart';
import 'package:flutter_app/models/carousel_model.dart';
import 'package:flutter_app/models/chat_model.dart';
import 'package:flutter_app/models/message.dart';
import 'package:flutter_app/models/movie_provider.dart';
import 'package:flutter_app/models/movie_provider_url.dart';
import 'package:flutter_app/models/reply_model.dart';
import 'package:flutter_app/widget/carousel_dialog_slider.dart';
import 'package:flutter_app/widget/chat_message.dart';
import 'package:flutter_app/widget/movie_provider_widget.dart';
import 'package:flutter_app/widget/multi_select.dart';
import 'package:flutter_app/widget/quick_reply.dart';
import 'package:flutter_app/models/dialog_flow.dart';
import 'package:flutter_app/widget/url_widget.dart';
import 'package:flutter_dialogflow/utils/language.dart';
import 'package:flutter_dialogflow/v2/auth_google.dart';
import 'package:flutter_dialogflow/v2/message.dart';
import 'constants.dart';
import 'models/movie_providers_model.dart';
import 'models/multi_select_model.dart';

void main() => runApp(ChatBot());

class ChatBot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: APP_TITLE,
      theme: ThemeData(
          primarySwatch: Colors.purple,
          errorColor: Colors.red,
          textTheme: ThemeData.light().textTheme.copyWith(
              title: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
              headline: TextStyle(fontFamily: 'OpenSans', fontSize: 14),
              button: TextStyle(color: Colors.white)),
          appBarTheme: AppBarTheme(
              textTheme: ThemeData.light().textTheme.copyWith(
                    title: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ))),
      home: ChatBotFlow(title: APP_TITLE),
    );
  }
}

class ChatBotFlow extends StatefulWidget {
  ChatBotFlow({Key key, this.title}) : super(key: key);
  final String title;

  @override
  State<StatefulWidget> createState() => _ChatBotFlowState();
}

class _ChatBotFlowState extends State<ChatBotFlow> {
  final List<Message> _messages = [];
  List<String> _selectedGenres = [];
  bool _doNotShowTyping = true;
  final TextEditingController _textController = new TextEditingController();

  Widget _buildTextComposer() {
    return new IconTheme(
      data: new IconThemeData(color: Theme.of(context).accentColor),
      child: new Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: new Row(
          children: <Widget>[
            new Flexible(
              child: new TextField(
                controller: _textController,
                onChanged: (String text) {
                  setState(() {
                    _doNotShowTyping = text.length > 0 || text == "";
                  });
                },
                onSubmitted: _handleSubmitted,
                decoration:
                    new InputDecoration.collapsed(hintText: HINT_TEXT),
              ),
            ),
            new Container(
                margin: new EdgeInsets.symmetric(horizontal: 4.0),
                child: new IconButton(
                    icon: new Icon(Icons.send),
                    onPressed: _doNotShowTyping
                        ? () => _handleSubmitted(_textController.text)
                        : null)),
          ],
        ),
      ),
    );
  }

  void _insertMultiSelect(List<String> selectedGenres) {
    _selectedGenres = selectedGenres;
    setState(() {
      _doNotShowTyping = false;
    });
    getDialogFlowResponse(ADDITIONAL_FILTERS);
  }

  void _getUrlByCountryCode(
      String countryCode, String movieId, String movieName) {
    var parameters =
        "'parameters' : { 'movie_id':  $movieId, 'country_code': '$countryCode', 'movie_name': '$movieName' }";
    setState(() {
      _doNotShowTyping = false;
    });
    getDialogFlowResponseByEvent(MOVIE_TAPPED_EVENT, parameters);
  }

  void _insertQuickReply(String reply) {
    _textController.clear();
    setState(() {
      _doNotShowTyping = false;
    });
    if (reply.toLowerCase() == 'yes') {
      getDialogFlowResponse(reply);
    } else {
      getDialogFlowResponse('$ADDITIONAL_FILTERS [Random]');
    }
  }

  void getDialogFlowResponse(query) async {
    _textController.clear();

    if (_selectedGenres != null &&
        _selectedGenres.isNotEmpty &&
        query != ADDITIONAL_FILTERS) {
      var _userMoviePreferences = _selectedGenres
          .reduce((previousValue, element) => previousValue + " " + element);

      query = query + " " + "[$_userMoviePreferences]";
      _selectedGenres = [];
    }
    try {
      AuthGoogle authGoogle = await getAuthGoogle();
      Dialogflow dialogflow = getDialogFlow(authGoogle);
      try {
        AIResponse response = await dialogflow.detectIntent(query);
        executeResponse(response);
      } catch (error) {
        print(error);
      }
    } catch (error) {
      print(error);
    }
  }

  void getDialogFlowResponseByEvent(
      String eventName, dynamic parameters) async {
    _textController.clear();
    try {
      AuthGoogle authGoogle = await getAuthGoogle();
      Dialogflow dialogflow = getDialogFlow(authGoogle);
      try {
        AIResponse response =
            await dialogflow.detectIntentByEvent(eventName, parameters);
        executeResponse(response);
      } catch (error) {
        print(error);
      }
    } catch (error) {
      print(error);
    }
  }

  Future<AuthGoogle> getAuthGoogle() async {
    AuthGoogle authGoogle =
        await AuthGoogle(fileJson: "assets/credentials.json").build();
    return authGoogle;
  }

  Dialogflow getDialogFlow(AuthGoogle authGoogle) {
    Dialogflow dialogflow =
        Dialogflow(authGoogle: authGoogle, language: Language.english);
    return dialogflow;
  }

  void executeResponse(AIResponse response) {
    if (response != null && response.getListMessage() != null) {
      var payload = response.getListMessage().firstWhere(
          (element) => element.containsKey('payload'),
          orElse: () => null);

      if (payload != null) {
        QuickReplies replies = new QuickReplies(payload['payload']);

        setState(() {
          var replyModel = ReplyModel(
            text: replies.title,
            name: "Bot",
            quickReplies: replies.quickReplies,
            updateQuickReply: _insertQuickReply,
            type: MessageType.QUICK_REPLY,
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

              MovieProvidersModel movieProviders =
                  new MovieProvidersModel(movieDetails);
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
                        new MovieProvider(
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
                      new MovieProviderUrl(
                          url: movieProviders.urlLink,
                          type: MessageType.MOVIE_PROVIDER_URL,
                          title: movieProviders.urlTitle));
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
      getDialogFlowResponse(text);
    }
  }

  @override
  void initState() {
    var parameters = "'parameters' : {}";
    _doNotShowTyping = true;
    getDialogFlowResponseByEvent(WELCOME_EVENT, parameters);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: new Text("Movie Chatbot"),
      ),
      body: Column(children: <Widget>[
        Flexible(
            child: ListView.builder(
          padding: EdgeInsets.all(8.0),
          reverse: true,
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
                return QuickReply(
                  title: (message as ReplyModel).text,
                  quickReplies: (message as ReplyModel).quickReplies,
                  insertQuickReply: (message as ReplyModel).updateQuickReply,
                  name: (message as ReplyModel).name,
                );
              }
              if (message.type == MessageType.MULTI_SELECT) {
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
                return CarouselDialogSlider(
                    (message as CarouselModel).carouselSelect,
                    _getUrlByCountryCode);
              }
              if (message.type == MessageType.MOVIE_PROVIDER_URL) {
                return UrlWidget(
                    title: (message as MovieProviderUrl).name,
                    url: (message as MovieProviderUrl).text);
              }
              if (message.type == MessageType.MOVIE_PROVIDER) {
                return MovieProviderWidget(
                    title: (message as MovieProvider).text,
                    logos: (message as MovieProvider).logos);
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
          child: _buildTextComposer(),
        ),
      ]),
    );
  }
}
