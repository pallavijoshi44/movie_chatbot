import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/src/domain/constants.dart';
import 'package:flutter_app/src/models/settings_model.dart';

import 'country/country_list_pick.dart';

class SettingsWidget extends StatefulWidget {
  static const routeName = '/settings';

  @override
  _SettingsWidgetState createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget> {
  SettingsModel prefs;

  @override
  void didChangeDependencies() {
    final routeArgs = ModalRoute.of(context).settings.arguments
        as Map<String, SettingsModel>;
    prefs = routeArgs['prefs'];
    super.didChangeDependencies();
  }

  Widget _buildCountryCode() {
    return ListTile(
      title: Platform.isIOS
          ? Text(SET_COUNTRY,
              style: CupertinoTheme.of(context).textTheme.navTitleTextStyle)
          : Text(SET_COUNTRY),
      subtitle: Platform.isIOS
          ? Text(SET_COUNTRY_LOCATION_CONTENT,
              style: CupertinoTheme.of(context).textTheme.tabLabelTextStyle)
          : Text(
              SET_COUNTRY_LOCATION_CONTENT,
            ),
      trailing: CountryListPick(
        appBar: Platform.isIOS
            ? CupertinoNavigationBar(
                leading: new CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: new Icon(CupertinoIcons.back, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                middle: Text('Choose Country',
                    style:
                        CupertinoTheme.of(context).textTheme.navTitleTextStyle),
              )
            : AppBar(
                title: Text('Choose Country'),
              ),
        theme: CountryTheme(
          isShowFlag: true,
          isShowTitle: true,
          isShowCode: false,
          isDownIcon: false,
          showEnglishName: true,
        ),
        initialSelection: prefs.countryCode.getValue(),
        onChanged: (CountryCode code)  {
          prefs.countryCode.setValue(code.code);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Platform.isIOS
            ? CupertinoNavigationBar(
                leading: CupertinoButton(
                  child: Text(CANCEL,
                      textScaleFactor: 1.0,
                      style:
                          CupertinoTheme.of(context).textTheme.actionTextStyle),
                  padding: EdgeInsets.zero,
                  onPressed: () => Navigator.of(context).pop(),
                ),
                middle: Text(SETTINGS,
                    style:
                        CupertinoTheme.of(context).textTheme.navTitleTextStyle),
              )
            : AppBar(
                title: Text(SETTINGS),
              ),
        body: Column(
          children: [
            _buildCountryCode(),
          ],
        ));
  }
}
