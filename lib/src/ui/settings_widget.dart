import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/src/domain/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'country/country_list_pick.dart';

class SettingsWidget extends StatefulWidget {
  static const routeName = '/settings';

  final currentTipStatus;
  final Function saveTips;
  //final SharedPreferences prefs;

  SettingsWidget(this.currentTipStatus, this.saveTips);

  @override
  _SettingsWidgetState createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget> {
  bool _tipsOn = false;
  String _initialSelection = 'IN';

  @override
  Future<void> initState() async {
    _tipsOn = widget.currentTipStatus;
    var prefs = await getPrefs();
    _initialSelection = prefs.getString(COUNTRY_CODE);
    super.initState();
  }

  Future<SharedPreferences> getPrefs() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs;
  }


  Widget _buildSwitchListTile(String title,
      String description,
      bool currentValue,
      Function updateValue,) {
    return Container(
      margin: EdgeInsets.only(top: 16.0),
      child: SwitchListTile(
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
      title: Text(SET_COUNTRY),
      subtitle: Text(
        SET_COUNTRY_LOCATION_CONTENT,
      ),
      trailing: CountryListPick(
        appBar: AppBar(
          title: Text('Choose Country'),
        ),
        theme: CountryTheme(
          isShowFlag: true,
          isShowTitle: true,
          isShowCode: false,
          isDownIcon: false,
          showEnglishName: true,
        ),
        initialSelection: _initialSelection,
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
        appBar: AppBar(
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
