import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/src/domain/ai_response.dart';
import 'package:flutter_app/src/models/settings_model.dart';
import 'package:flutter_app/src/ui/country/country_list_pick.dart';

class CountryPickerWidget extends StatelessWidget {
  final String text;
  final SettingsModel settings;
  final Function onCountryChanged;
  final String id;
  final bool isMovie;

  const CountryPickerWidget(
      {required this.text, required this.settings, required this.onCountryChanged, required this.id, required this.isMovie});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 15.0, right: 15.0),
      child: Row(
        children: [
          Text(text,
              style: Platform.isIOS
                  ? CupertinoTheme.of(context).textTheme.navTitleTextStyle
                  : Theme.of(context).textTheme.titleLarge),
          Flexible(
            child: CountryListPick(
              appBar: AppBar(title: Text('Choose Country')),
              theme: CountryTheme(
                isShowFlag: true,
                isShowTitle: true,
                isShowCode: false,
                isDownIcon: false,
                showEnglishName: true,
              ),
              initialSelection: settings.countryCode.getValue().isEmpty
                  ? "IN"
                  : settings.countryCode.getValue(),
              onChanged: (CountryCode code) async {
                settings.countryCode.setValue(code.code);
                onCountryChanged.call(id, code.code,
                    isMovie ? EntertainmentType.MOVIE : EntertainmentType.TV);
              },
            ),
          )
        ],
      ),
    );
  }
}
