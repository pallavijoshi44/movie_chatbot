import 'package:dialogflow_flutter/language.dart';
import 'package:flutter_app/src/resources/auth_google.dart';
import 'package:flutter_app/src/resources/dialog_flow.dart';

import '../domain/ai_response.dart';

class DetectDialogResponses {
  final Function? executeResponse;
  final Function? defaultResponse;
  final QUERY_INPUT_TYPE? queryInputType;
  final String? eventName;
  final String? query;
  final dynamic parameters;
  final AuthGoogle authGoogle;

  DetectDialogResponses(
      { this.query,
       this.queryInputType,
       this.eventName,
      this.parameters,
       this.executeResponse,
       this.defaultResponse,
       required this.authGoogle});

  Future<void> callDialogFlow() async {
    AIResponse response;
    try {
      DialogFlow dialogflow = await getDialogFlow();
      try {
        if (queryInputType == QUERY_INPUT_TYPE.QUERY) {
          response = await dialogflow.detectIntent(query);
        } else {
          response =
              await dialogflow.detectIntentByEvent(eventName, parameters);
        }
        executeResponse?.call(response);
      } catch (error) {
         defaultResponse?.call();
        print(error);
      }
    } catch (error) {
      defaultResponse?.call();
      print(error);
    }
  }

  Future<AIResponse> callDialogFlowForGeneralReasons() async {
    AIResponse response;
    DialogFlow dialogflow = await getDialogFlow();
    if (queryInputType == QUERY_INPUT_TYPE.QUERY) {
      response = await dialogflow.detectIntent(query);
    } else {
      response = await dialogflow.detectIntentByEvent(eventName, parameters);
    }
    return response;
  }

  Future<DialogFlow> getDialogFlow() async {
    DialogFlow dialogflow =
        DialogFlow(authGoogle: this.authGoogle, language: Language.english);
    return dialogflow;
  }

  Future<void> deleteDialogFlowContexts() async {
    DialogFlow dialogflow = await getDialogFlow();
    await dialogflow.deleteContexts();
  }
}

enum QUERY_INPUT_TYPE { EVENT, QUERY }
