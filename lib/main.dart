import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/src/chatbot_ui.dart';
import 'package:flutter_app/src/models/settings_model.dart';
import 'package:flutter_app/src/models/tmdb/moviedetails/movie_detail_bloc.dart';
import 'package:flutter_app/src/resources/auth_google.dart';
import 'package:flutter_app/src/ui/connectivity_check.dart';
import 'package:flutter_app/src/ui/location_check.dart';
import 'package:flutter_app/src/ui/settings_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

import 'src/domain/constants.dart';
import 'src/ui/about_app_widget.dart';
final ThemeData theme = ThemeData();
const typeTheme = Typography.blackMountainView;

TextTheme txtTheme = Typography.blackMountainView.copyWith(
  bodyLarge: typeTheme.bodyLarge?.copyWith(fontSize: 16, fontFamily: 'QuickSand', fontWeight: FontWeight.bold),
  bodyMedium: typeTheme.bodyMedium?.copyWith(fontSize: 16, fontFamily: 'QuickSand', fontWeight: FontWeight.normal),
  displayLarge: typeTheme.displayLarge?.copyWith(fontSize: 16, fontFamily: 'QuickSand', fontWeight: FontWeight.bold),
  displayMedium: typeTheme.displayMedium?.copyWith(fontSize: 14, fontFamily: 'QuickSand', fontWeight: FontWeight.normal),
  displaySmall: typeTheme.displaySmall?.copyWith(fontSize: 12, fontFamily: 'QuickSand', fontWeight: FontWeight.bold),
  headlineMedium: typeTheme.headlineMedium?.copyWith(fontSize: 14, fontFamily: 'QuickSand', fontWeight: FontWeight.normal),
  headlineSmall: typeTheme.headlineSmall?.copyWith(fontSize: 12, fontFamily: 'QuickSand', fontWeight: FontWeight.bold),
  titleLarge: typeTheme.titleLarge?.copyWith(fontSize: 16, fontFamily: 'QuickSand', fontWeight: FontWeight.bold),
  titleMedium: typeTheme.titleMedium?.copyWith(fontSize: 14, fontFamily: 'QuickSand', fontWeight: FontWeight.bold),
  titleSmall: typeTheme.titleSmall?.copyWith(fontSize: 12, fontFamily: 'QuickSand', fontWeight: FontWeight.bold),
);
final materialThemeData = theme.copyWith(
    colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.green,
        accentColor: Colors.blueGrey[600],
        errorColor: Colors.red),
    textTheme: txtTheme,
    appBarTheme: AppBarTheme(
      titleTextStyle: TextStyle(
          color: Colors.white,
          fontFamily: 'QuickSand',
          fontSize: 20,
          fontWeight: FontWeight.bold),
    ));

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

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final preferences = await StreamingSharedPreferences.instance;
  final settings = SettingsModel(preferences);
  AuthGoogle authGoogle = await getAuthGoogle();

  runApp(ChatBot(settings, authGoogle));
}

Future<AuthGoogle> getAuthGoogle() async {
  AuthGoogle authGoogle =
      await AuthGoogle(fileJson: "assets/credentials.json").build();
  return authGoogle;
}

class ChatBot extends StatefulWidget {
  final SettingsModel settings;
  final AuthGoogle authGoogle;

  ChatBot(this.settings, this.authGoogle);

  @override
  _ChatBotState createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
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
              builder = (context) => SettingsWidget();
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
      home: ChatBotFlow(widget.settings, widget.authGoogle),
    );
  }
}

class ChatBotFlow extends StatelessWidget {
  final SettingsModel settings;
  final AuthGoogle authGoogle;

  ChatBotFlow(this.settings, this.authGoogle);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => _onBackPressed(context),
        child: PlatformScaffold(
          backgroundColor: Color.fromRGBO(249, 248, 235, 1),
          cupertino: (_, target) => _buildCupertinoPageScaffoldData(context),
          material: (_, target) => _buildMaterialScaffoldData(context),
          body: BlocProvider(
              create: (BuildContext context) => MovieDetailsBloc(),
              child: ConnectivityCheck(
                  child: LocationCheck(
                      settings: this.settings,
                      child: ChatBotUI(settings, authGoogle)))),
        ));
  }

  Future<bool> _onBackPressed(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Do you want to quit the app?"),
        actions: <Widget>[
          TextButton(
            child: Text(YES),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
          TextButton(
            child: Text(NO),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
        ],
      ),
    );
    return Future.value(true);
  }

  MaterialScaffoldData _buildMaterialScaffoldData(BuildContext context) {
    return MaterialScaffoldData(
      appBar: new AppBar(
          centerTitle: true,
          title: FittedBox(
            fit: BoxFit.fitWidth,
            child: new Text(
              APP_TITLE,
              style: Theme.of(context).appBarTheme.titleTextStyle,
            ),
          ),
          actions: <Widget>[
            PopupMenuButton<String>(
              onSelected: (value) async {
                if (value == ABOUT_APP) _showAboutAppScreen(context, context);
                if (value == SETTINGS)
                  await _showSettingsScreen(context, context);
              },
              itemBuilder: (_) => [
                PopupMenuItem(
                  child: Text(SETTINGS),
                  value: SETTINGS,
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

  Future _showSettingsScreen(BuildContext ctx, BuildContext context) async {
    var arguments = {'prefs': settings};
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
