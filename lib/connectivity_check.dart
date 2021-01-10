import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'constants.dart';

class ConnectivityCheck extends StatefulWidget {
  final Widget child;

  ConnectivityCheck({@required this.child});

  @override
  _ConnectivityCheckState createState() => _ConnectivityCheckState();
}

class _ConnectivityCheckState extends State<ConnectivityCheck> {
  bool isInternetOn = true;
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  Widget build(BuildContext context) {
    return isInternetOn ? widget.child : buildAlertDialog();
  }

  Future<void> initConnectivity() async {
    ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    if (result == ConnectivityResult.none) {
      setState(() {
        isInternetOn = false;
      });
    } else {
      setState(() {
        isInternetOn = true;
      });
    }
  }

  AlertDialog buildAlertDialog() {
    return AlertDialog(
      title: Text(
        NO_NETWORK_MESSAGE,
        style: Theme.of(context).textTheme.headline,
      ),
    );
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }
}
