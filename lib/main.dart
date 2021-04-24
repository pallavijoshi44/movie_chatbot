import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/src/chatbot_ui.dart';
import 'package:flutter_app/src/models/tmdb/moviedetails/movie_detail_bloc.dart';
import 'package:flutter_app/src/ui/connectivity_check.dart';
import 'package:flutter_app/src/ui/help_widget.dart';
import 'package:flutter_app/src/ui/location_check.dart';
import 'package:flutter_app/src/ui/settings_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
            fontFamily: 'QuickSand', fontSize: 16, fontWeight: FontWeight.bold),
        headline: TextStyle(fontFamily: 'QuickSand', fontSize: 14),
        button: TextStyle(color: Colors.white)),
    appBarTheme: AppBarTheme(
        textTheme: ThemeData.light().textTheme.copyWith(
              title: TextStyle(
                  color: Colors.white,
                  fontFamily: 'QuickSand',
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
            fontFamily: 'QuickSand',
            fontSize: 20,
            fontWeight: FontWeight.bold),
        navTitleTextStyle: TextStyle(
            fontFamily: 'QuickSand', fontSize: 16, fontWeight: FontWeight.bold),
        tabLabelTextStyle: TextStyle(fontFamily: 'QuickSand', fontSize: 14),
        actionTextStyle: TextStyle(
            color: Colors.white, fontSize: 14, fontFamily: 'QuickSand')));

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
    var localizationsDelegates = <LocalizationsDelegate<dynamic>>[
      DefaultMaterialLocalizations.delegate,
      DefaultWidgetsLocalizations.delegate,
      DefaultCupertinoLocalizations.delegate,
    ];

    return PlatformApp(
      title: APP_TITLE,
      debugShowCheckedModeBanner: false,
      material: (context, _) {
        return MaterialAppData(
            theme: materialThemeData,
            localizationsDelegates: localizationsDelegates);
      },
      cupertino: (context, _) => CupertinoAppData(
          theme: cupertinoTheme,
          localizationsDelegates: localizationsDelegates),
      onGenerateRoute: (RouteSettings settings) {
        var builder;
        switch (settings.name) {
          case SettingsWidget.routeName:
            {
              builder =
                  (context) => SettingsWidget(_selectedTips, _onTipSelected);
            }
            break;
          case HelpWidget.routeName:
            {
              builder = (context) => HelpWidget();
            }
            break;
          case AboutAppWidget.routeName:
            {
              builder = (context) => AboutAppWidget();
            }
            break;
        }
        if (Platform.isIOS) {
          return CupertinoPageRoute(
              builder: builder, fullscreenDialog: true, settings: settings);
        } else
          return MaterialPageRoute(builder: builder, settings: settings);
      },
      home: ChatBotFlow(),
    );
  }
}

class ChatBotFlow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onBackPressed(context),
      child: PlatformScaffold(
          backgroundColor: Color.fromRGBO(249, 248, 235, 1),
          cupertino: (_, target) => _buildCupertinoPageScaffoldData(context),
          material: (_, target) => _buildMaterialScaffoldData(context),
          body:  BlocProvider(
              create: (BuildContext context) => MovieDetailsBloc(),
              child: ConnectivityCheck(child: LocationCheck(child: ChatBotUI(_selectedTips)))),
    ));
  }

  Future<bool> _onBackPressed(BuildContext context) {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            actionsPadding: EdgeInsets.all(10),
            title: new Text('Are you sure?',  style: Theme.of(context).appBarTheme.textTheme.headline),
            content: new Text(
              'You don\'t want to chat with me anymore?',
              style: Theme.of(context).textTheme.headline,
            ),
            actions: <Widget>[
              new GestureDetector(
                onTap: () => Navigator.of(context).pop(false),
                child: Text("NO",  style: Theme.of(context).textTheme.headline),
              ),
              SizedBox(height: 16),
              new GestureDetector(
                onTap: () => Navigator.of(context).pop(true),
                child: Text("YES",  style: Theme.of(context).textTheme.headline),
              ),
            ],
          ),
        ) ??
        false;
  }

  MaterialScaffoldData _buildMaterialScaffoldData(BuildContext context) {
    return MaterialScaffoldData(
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
                if (value == ABOUT_APP) _showAboutAppScreen(context, context);
                if (value == HELP) _showHelpWidget(context, context);
                if (value == SETTINGS)
                  await _showSettingsScreen(context, context);
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
    );
  }

  CupertinoPageScaffoldData _buildCupertinoPageScaffoldData(
      BuildContext context) {
    return CupertinoPageScaffoldData(
        navigationBar: CupertinoNavigationBar(
            middle: FittedBox(
              fit: BoxFit.fitWidth,
              child: new Text(APP_TITLE,
                  style:
                      CupertinoTheme.of(context).textTheme.navTitleTextStyle),
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
            )));
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
                  onPressed: () => _showAboutAppScreen(ctx, context),
                  child: const Text(ABOUT_APP)),
              CupertinoActionSheetAction(
                  onPressed: () => _showHelpWidget(ctx, context),
                  child: const Text(HELP)),
              CupertinoActionSheetAction(
                  onPressed: () async =>
                      await _showSettingsScreen(ctx, context),
                  child: const Text(SETTINGS))
            ],
          );
        });
  }

  void _showAboutAppScreen(BuildContext ctx, BuildContext context) {
    _popActionSheetForiOS(ctx);
    Navigator.pushNamed(context, AboutAppWidget.routeName);
  }

  void _showHelpWidget(BuildContext ctx, BuildContext context) {
    _popActionSheetForiOS(ctx);
    Navigator.pushNamed(context, HelpWidget.routeName);
  }

  Future _showSettingsScreen(BuildContext ctx, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var arguments = {'prefs': prefs};
    _popActionSheetForiOS(ctx);
    Navigator.pushNamed(context, SettingsWidget.routeName,
        arguments: arguments);
  }

  void _popActionSheetForiOS(BuildContext ctx) {
    if (Platform.isIOS) {
      Navigator.of(ctx).pop();
    }
  }
}
