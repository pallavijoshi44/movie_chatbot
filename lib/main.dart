import 'package:flutter/material.dart';
import 'package:flutter_app/src/api/services.dart';
import 'package:flutter_app/src/blocs/bloc.dart';
import 'package:flutter_app/src/ui/connectivity_check.dart';
import 'package:flutter_app/src/chatbot_ui.dart';
import 'package:flutter_app/src/ui/help_widget.dart';
import 'package:flutter_app/src/ui/settings_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'src/domain/constants.dart';
import 'src/ui/about_app_widget.dart';

void main() => runApp(ChatBot());

class ChatBot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: APP_TITLE,
      debugShowCheckedModeBanner: false,
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

class ChatBotFlow extends StatefulWidget {
  @override
  _ChatBotFlowState createState() => _ChatBotFlowState();
}

class _ChatBotFlowState extends State<ChatBotFlow> {
  bool _selectedTips = true;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Color.fromRGBO(249, 248, 235, 1),
      appBar: new AppBar(
          centerTitle: true,
          title: FittedBox(
            fit: BoxFit.fitWidth,
            child: new Text(
              APP_TITLE,
              style: Theme.of(context).appBarTheme.textTheme.title,
            ),
          ),
          actions: <Widget>[
            PopupMenuButton<String>(
              onSelected: (value) async {
                if (value == ABOUT_APP) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AboutAppWidget(),
                    ),
                  );
                }
                if (value == HELP) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HelpWidget(),
                    ),
                  );
                }
                if (value == SETTINGS) {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          SettingsWidget(_selectedTips, _onTipSelected, prefs),
                    ),
                  );
                }
              },
              itemBuilder: (_) => [
                PopupMenuItem(
                  child: Text(SETTINGS),
                  value: SETTINGS,
                ),
                PopupMenuItem(
                  child: Text(HELP),
                  value: HELP,
                ),
                PopupMenuItem(
                  child: Text(ABOUT_APP),
                  value: ABOUT_APP,
                ),
              ],
            ),
          ]),
      body: BlocProvider(
          create: (BuildContext context) =>
              DialogFlowBloc(dialogFlowRepo: DialogFlow()),
          child: ChatBotUI(_selectedTips)),
    );
  }

  _onTipSelected(bool value) {
    setState(() {
      _selectedTips = value;
    });
  }
}
