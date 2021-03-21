import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/src/ui/connectivity_check.dart';
import 'package:flutter_app/src/chatbot_ui.dart';
import 'package:flutter_app/src/ui/help_widget.dart';
import 'package:flutter_app/src/ui/settings_widget.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'src/domain/constants.dart';
import 'src/ui/about_app_widget.dart';

final materialThemeData = ThemeData(
    primarySwatch: Colors.green,
    accentColor: Colors.blueGrey[600],
    errorColor: Colors.red,
    textTheme: ThemeData.light().textTheme.copyWith(
        title: TextStyle(
            fontFamily: 'OpenSans', fontSize: 16, fontWeight: FontWeight.bold),
        headline: TextStyle(fontFamily: 'OpenSans', fontSize: 14),
        button: TextStyle(color: Colors.white)),
    appBarTheme: AppBarTheme(
        textTheme: ThemeData.light().textTheme.copyWith(
              title: TextStyle(
                  color: Colors.white,
                  fontFamily: 'OpenSans',
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            )));

final cupertinoTheme = CupertinoThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.green,
    barBackgroundColor: Colors.green,
    scaffoldBackgroundColor: Colors.white,
    textTheme: CupertinoTextThemeData(
        navLargeTitleTextStyle: TextStyle(
            color: Colors.white,
            fontFamily: 'OpenSans',
            fontSize: 20,
            fontWeight: FontWeight.bold),
        navTitleTextStyle: TextStyle(
            fontFamily: 'OpenSans', fontSize: 16, fontWeight: FontWeight.bold),
        tabLabelTextStyle: TextStyle(fontFamily: 'OpenSans', fontSize: 14),
        actionTextStyle: TextStyle(color: Colors.white)));

void main() => runApp(ChatBot());

bool _selectedTips = true;

class ChatBot extends StatefulWidget {
  @override
  _ChatBotState createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  _onTipSelected(bool value) {
    setState(() {
      _selectedTips = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PlatformApp(
      title: APP_TITLE,
      debugShowCheckedModeBanner: false,
      material: (context, _) => MaterialAppData(theme: materialThemeData),
      cupertino: (context, _) => CupertinoAppData(
          theme: cupertinoTheme,
          localizationsDelegates: <LocalizationsDelegate<dynamic>>[
            DefaultMaterialLocalizations.delegate,
            DefaultWidgetsLocalizations.delegate,
            DefaultCupertinoLocalizations.delegate,
          ]),
      onGenerateRoute: (RouteSettings settings) {
        if (settings.name == SettingsWidget.routeName) {
          if (Platform.isIOS) {
            return CupertinoPageRoute(
                builder: (context) =>
                    SettingsWidget(_selectedTips, _onTipSelected),
                fullscreenDialog: true,
                settings: settings);
          } else
            return MaterialPageRoute(
                builder: (context) =>
                    SettingsWidget(_selectedTips, _onTipSelected),
                settings: settings);
        }
        return null;
      },
      home: ChatBotFlow(),
    );
  }
}

class ChatBotFlow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Color.fromRGBO(249, 248, 235, 1),
      appBar: Platform.isIOS
          ? CupertinoNavigationBar(
              middle: FittedBox(
                fit: BoxFit.fitWidth,
                child: new Text(APP_TITLE,
                    style: CupertinoTheme.of(context)
                        .textTheme
                        .navLargeTitleTextStyle),
              ),
              trailing: CupertinoButton(
                onPressed: () async {
                  await _showActionSheet(context);
                },
                padding: EdgeInsets.zero,
                child: Icon(
                  CupertinoIcons.ellipsis,
                  color: Colors.white,
                ),
              ))
          : new AppBar(
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
                        await _showSettingsScreen(context, context);
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
      body: ConnectivityCheck(
        child: ChatBotUI(_selectedTips),
      ),
    );
  }

  Future _showActionSheet(BuildContext context) async {
    showCupertinoModalPopup(
        useRootNavigator: false,
        context: context,
        builder: (ctx) {
          return CupertinoActionSheet(
            cancelButton: CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(CANCEL)),
            actions: [
              CupertinoActionSheetAction(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            fullscreenDialog: true,
                            builder: (context) => AboutAppWidget()));
                  },
                  child: const Text(ABOUT_APP)),
              CupertinoActionSheetAction(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            fullscreenDialog: true,
                            builder: (context) => HelpWidget()));
                    // Navigator.pop(ctx);
                  },
                  child: const Text(HELP)),
              CupertinoActionSheetAction(
                  onPressed: () async {
                    await _showSettingsScreen(ctx, context);
                  },
                  child: const Text(SETTINGS))
            ],
          );
        });
  }

  Future _showSettingsScreen(BuildContext ctx, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var arguments = {'prefs': prefs};
    if (Platform.isIOS) {
      Navigator.of(ctx).pop();
    }
    Navigator.pushNamed(context, SettingsWidget.routeName,
        arguments: arguments);
  }
}
