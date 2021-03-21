import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/src/domain/constants.dart';
import 'package:flutter_app/src/ui/ios/cupertino_switch_list_tile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'country/country_list_pick.dart';

class SettingsWidget extends StatefulWidget {
  static const routeName = '/settings';

  final currentTipStatus;
  final Function saveTips;

  SettingsWidget(this.currentTipStatus, this.saveTips);

  @override
  _SettingsWidgetState createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget> {
  bool _tipsOn = false;
  SharedPreferences prefs;

  @override
  void initState() {
    _tipsOn = widget.currentTipStatus;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    final routeArgs = ModalRoute.of(context).settings.arguments
        as Map<String, SharedPreferences>;
    prefs = routeArgs['prefs'];
    super.didChangeDependencies();
  }

  Widget _buildSwitchListTile(
    String title,
    String description,
    bool currentValue,
    Function updateValue,
  ) {
    return Container(
      margin: EdgeInsets.only(top: 16.0),
      child: Platform.isIOS
          ? CupertinoSwitchListTile(
              title: Text(
                title,
                style: CupertinoTheme.of(context).textTheme.navTitleTextStyle,
              ),
              value: currentValue,
              subtitle: Text(description,
                  style:
                      CupertinoTheme.of(context).textTheme.tabLabelTextStyle),
              onChanged: updateValue)
          : SwitchListTile(
              title: Text(title),
              value: currentValue,
              subtitle: Text(
                description,
              ),
              onChanged: updateValue,
            ),
    );
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
        initialSelection: prefs.getString(COUNTRY_CODE) ?? 'IN',
        onChanged: (CountryCode code) async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString(COUNTRY_CODE, code.code);
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
            _buildSwitchListTile(
              RECEIVE_TIPS,
              RECEIVE_TIPS_CONTENT,
              _tipsOn,
              (newValue) {
                setState(
                  () {
                    _tipsOn = newValue;
                    widget.saveTips(newValue);
                  },
                );
              },
            ),
            _buildCountryCode(),
          ],
        ));
  }
}
