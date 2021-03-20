import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/src/ui/connectivity_check.dart';
import 'package:flutter_app/src/domain/constants.dart';
import 'package:flutter_app/src/resources/detect_dialog_responses.dart';
import 'package:flutter_app/src/domain/ai_response.dart';

class HelpWidget extends StatelessWidget {
  static const routeName = '/help';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Platform.isIOS
            ? CupertinoNavigationBar(
                leading: new IconButton(
                  icon: new Icon(CupertinoIcons.back, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                middle: Text(HELP,
                    style: CupertinoTheme.of(context)
                        .textTheme
                        .navLargeTitleTextStyle),
              )
            : AppBar(
                title: Text(HELP),
              ),
        body: HelpContent());
  }
}

Future<String> _getHelpContent() async {
  DetectDialogResponses detectDialogResponses = new DetectDialogResponses(
      query: 'help', queryInputType: QUERY_INPUT_TYPE.QUERY);

  AIResponse response =
      await detectDialogResponses.callDialogFlowForGeneralReasons();

  return Future.value(
      response.getMessage() ?? response.getListMessage()[0]['text']['text'][0]);
}

class HelpContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: _getHelpContent(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Container(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator());
            default:
              if (snapshot.hasError)
                return _buildSingleChildScrollView(DEFAULT_HELP_CONTENT);
              else
                return ConnectivityCheck(
                  child: _buildSingleChildScrollView(snapshot.data),
                );
          }
        });
  }

  SingleChildScrollView _buildSingleChildScrollView(String data) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.all(15.0),
        padding: EdgeInsets.only(bottom: 15.0),
        child: Text(
          data,
          textAlign: TextAlign.justify,
          style: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 16,
            color: Color.fromRGBO(13, 37, 63, 1),
          ),
        ),
      ),
    );
  }
}
