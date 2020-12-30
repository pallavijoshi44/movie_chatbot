import 'package:flutter/material.dart';
import 'package:flutter_app/models/carousel_model.dart';
import 'package:flutter_app/models/chat_model.dart';
import 'package:flutter_app/models/message.dart';
import 'package:flutter_app/models/reply_model.dart';
import 'package:flutter_app/widget/carousel_dialog_slider.dart';
import 'package:flutter_app/widget/chat_message.dart';
import 'package:flutter_app/widget/multi_select.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';

const String ADDITIONAL_FILTERS = "ask-additional-filters";

void main() => runApp(ChatBot());

class ChatBot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChatBot flow flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChatBotFlow(title: 'ChatBotFlow Home Page'),
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
  String _userMoviePreferences = "";

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
                onSubmitted: _handleSubmitted,
                decoration:
                    new InputDecoration.collapsed(hintText: "Send a message"),
              ),
            ),
            new Container(
              margin: new EdgeInsets.symmetric(horizontal: 4.0),
              child: new IconButton(
                  icon: new Icon(Icons.send),
                  onPressed: () => _handleSubmitted(_textController.text)),
            ),
          ],
        ),
      ),
    );
  }

  void _insertQuickReply(String selectedGenres) {
    _userMoviePreferences = selectedGenres;
    getDialogFlowResponse(ADDITIONAL_FILTERS);
  }

  void getDialogFlowResponse(query) async {
    _textController.clear();
    if (_userMoviePreferences != "" && query != ADDITIONAL_FILTERS) {
      query = query + " " + "[$_userMoviePreferences]";
      _userMoviePreferences = "";
    }
    try {
      AuthGoogle authGoogle =
          await AuthGoogle(fileJson: "assets/credentials.json").build();
      Dialogflow dialogflow =
          Dialogflow(authGoogle: authGoogle, language: Language.english);
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
            _messages.insert(0, carouselModel);
          });
        } else {
          setState(() {
            var chatModel = new ChatModel(
                name: "Bot",
                type: MessageType.CHAT_MESSAGE,
                text: response.getMessage() ??
                    new CardDialogflow(response.getListMessage()[0]).title,
                chatType: false);
            _messages.insert(0, chatModel);
          });
        }
      }
    }
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    setState(() {
      var chatModel = new ChatModel(
          name: "Pallavi",
          type: MessageType.CHAT_MESSAGE,
          text: text,
          chatType: true);
      _messages.insert(0, chatModel);
    });
    getDialogFlowResponse(text);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: new Text("Flutter and Dialogflow"),
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
                return MultiSelect(
                  title: (message as ReplyModel).text,
                  quickReplies: (message as ReplyModel).quickReplies,
                  insertQuickReply: (message as ReplyModel).updateQuickReply,
                  name: (message as ReplyModel).name,
                );
              }
              if (message.type == MessageType.CAROUSEL) {
                return CarouselDialogSlider(
                    (message as CarouselModel).carouselSelect);
              }
            }
            return Container();
          },
          itemCount: _messages.length,
        )),
        Divider(height: 1.0),
        Container(
          decoration: new BoxDecoration(color: Theme.of(context).cardColor),
          child: _buildTextComposer(),
        ),
      ]),
    );
  }
}
