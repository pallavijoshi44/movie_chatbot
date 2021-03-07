import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/src/ui/connectivity_check.dart';
import 'package:flutter_app/src/domain/constants.dart';
import 'package:flutter_app/src/resources/detect_dialog_responses.dart';
import 'package:flutter_app/src/domain/ai_response.dart';

class SettingsWidget extends StatefulWidget {
  final currentTipStatus;
  final Function saveTips;

  SettingsWidget(this.currentTipStatus, this.saveTips);

  @override
  _SettingsWidgetState createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget> {
  bool _tipsOn = false;

  @override
  void initState() {
    _tipsOn = widget.currentTipStatus;
    super.initState();
  }

  Widget _buildSwitchListTile(
    String title,
    String description,
    bool currentValue,
    Function updateValue,
  ) {
    return SwitchListTile(
      title: Text(title),
      value: currentValue,
      subtitle: Text(
        description,
      ),
      onChanged: updateValue,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(SETTINGS),
        ),
        body:  _buildSwitchListTile(
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
        ));
  }
}
