import 'dart:async';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/src/ui/settings_widget.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/constants.dart';

class LocationCheck extends StatefulWidget {
  final Widget child;

  LocationCheck({@required this.child});

  @override
  _LocationCheckState createState() => _LocationCheckState();
}

class _LocationCheckState extends State<LocationCheck>
    with WidgetsBindingObserver {
  String _countryCode = "";
  bool _isDialogShown = false;
  bool _isLocationSet = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkLocationPreferences();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_isLocationSet) {
      _checkLocationPreferences();
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  Future<void> _checkLocationPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _countryCode = prefs.getString(KEY_COUNTRY_CODE);

    if (_countryCode == null || _countryCode.isEmpty) {
      var isGpsEnabled = await Geolocator.isLocationServiceEnabled();
      if (!isGpsEnabled) {
        _checkLocationServices(isGpsEnabled, prefs);
      } else {
        await _handleCountryCode();
      }
    }
  }

  _checkLocationServices(bool isGpsEnabled, SharedPreferences prefs) async {
    if (!_isDialogShown) {
      _isDialogShown = true;
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext ctx) {
          return Platform.isIOS
              ? CupertinoAlertDialog(
                  title: Text(LOCATION_PERMISSION_TEXT),
                  actions: <Widget>[
                    CupertinoButton(
                      child: Text(PHONE_SETTINGS),
                      onPressed: () async {
                        Navigator.of(ctx).pop();
                        Geolocator.openLocationSettings();
                      },
                    ),
                    CupertinoButton(
                      child: Text(CHANGE_LOCATION_FROM_APP),
                      onPressed: () async {
                        _showSettingsScreen(ctx, context, prefs);
                      },
                    ),
                  ],
                )
              : AlertDialog(
                  title: Text(LOCATION_PERMISSION_TEXT),
                  actions: <Widget>[
                    FlatButton(
                      child: Text(PHONE_SETTINGS),
                      onPressed: () async {
                        Navigator.of(ctx).pop();
                        Geolocator.openLocationSettings();
                      },
                    ),
                    FlatButton(
                      child: Text(CHANGE_LOCATION_FROM_APP),
                      onPressed: () async {
                        _showSettingsScreen(ctx, context, prefs);
                      },
                    ),
                  ],
                );
        },
      );
    }
  }

  Future _handleCountryCode() async {
    try {
      var currentPosition = await Geolocator.getCurrentPosition();
      var placeMarks = await placemarkFromCoordinates(
          currentPosition.latitude, currentPosition.longitude);
      if (placeMarks != null && placeMarks.length > 0) {
        setState(() {
          _countryCode = placeMarks[0].isoCountryCode;
        });
      }
    } catch (error) {
      setState(() {
        _countryCode = "IN";
      });
    } finally {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(KEY_COUNTRY_CODE, _countryCode);
      setState(() {
        _isLocationSet = true;
      });
    }
  }

  Future _showSettingsScreen(
      BuildContext ctx, BuildContext context, SharedPreferences prefs) async {
    var arguments = {'prefs': prefs};
    Navigator.of(ctx).pop();
    Navigator.pushNamed(context, SettingsWidget.routeName,
        arguments: arguments);
  }
}
