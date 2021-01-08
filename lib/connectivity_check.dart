import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

import 'constants.dart';

class ConnectivityCheck extends StatelessWidget {
  final Widget child;

  ConnectivityCheck({@required this.child});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ConnectivityResult>(
        stream: Connectivity().onConnectivityChanged,
        builder: (context, snapshot) {
          if (!snapshot.hasData ||
              snapshot.data == ConnectivityResult.none) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: Text(NO_NETWORK_MESSAGE, style: Theme.of(context).textTheme.headline),
              ),
            );
          } else {
            return child;
          }
        });
  }
}