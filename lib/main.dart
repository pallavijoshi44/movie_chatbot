import 'package:flutter/material.dart';
import 'package:flutter_app/connectivity_check.dart';
import 'package:flutter_app/widget/chatbot_ui.dart';
import 'constants.dart';

void main() => runApp(ChatBot());

class ChatBot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: APP_TITLE,
      theme: ThemeData(
          primarySwatch: Colors.green,
          accentColor: Colors.blueGrey[600],
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
                        color: Colors.white,
                        fontFamily: 'OpenSans',
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ))),
      home: ChatBotFlow(),
    );
  }
}

class ChatBotFlow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Color.fromRGBO(249, 248, 235, 1),
      appBar: new AppBar(
        centerTitle: true,
        title: new Text(
          APP_TITLE,
          style: Theme.of(context).appBarTheme.textTheme.title,
        ),
      ),
      body: ConnectivityCheck(
        child: ChatBotUI(),
      ),
    );
  }
}
