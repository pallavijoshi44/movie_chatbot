import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/src/domain/constants.dart';
import 'package:flutter_app/src/ui/country/country_list_pick.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CountryPickerWidget extends StatelessWidget {
  final String text;
  final SharedPreferences prefs;
  final Function onCountryChanged;
  final String id;

  const CountryPickerWidget({this.text, this.prefs, this.onCountryChanged, this.id});

  @override
  Widget build(BuildContext context) {
      return Container(
        margin: EdgeInsets.only(left: 15.0, right: 15.0),
        child: Row(
          children: [
            Text(text,
                style: Platform.isIOS
                    ? CupertinoTheme.of(context).textTheme.navTitleTextStyle
                    : Theme.of(context).textTheme.title),
            Flexible(
              child: CountryListPick(
                appBar: Platform.isIOS
                    ? CupertinoNavigationBar(
                  leading: new CupertinoButton(
                    padding: EdgeInsets.zero,
                    child:
                    new Icon(CupertinoIcons.back, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  middle: Text('Choose Country',
                      style: CupertinoTheme.of(context)
                          .textTheme
                          .navTitleTextStyle),
                )
                    : AppBar(title: Text('Choose Country')),
                theme: CountryTheme(
                  isShowFlag: true,
                  isShowTitle: true,
                  isShowCode: false,
                  isDownIcon: false,
                  showEnglishName: true,
                ),
                initialSelection: prefs.getString(COUNTRY_CODE),
                onChanged: (CountryCode code) async {
                  await prefs.setString(COUNTRY_CODE, code.code);
                  onCountryChanged.call(id, code.code);
                },
              ),
            )
          ],
        ),
      );
  }
}