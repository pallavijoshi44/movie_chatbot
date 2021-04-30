import 'package:flutter_app/src/resources/auth_google.dart';
import 'package:flutter_app/src/resources/dialog_flow.dart';
import 'package:flutter_dialogflow/utils/language.dart';

import '../domain/ai_response.dart';

class DetectDialogResponses {
  final Function executeResponse;
  final Function defaultResponse;
  final QUERY_INPUT_TYPE queryInputType;
  final String eventName;
  final String query;
  final dynamic parameters;

  DetectDialogResponses(
      {this.query,
      this.queryInputType,
      this.eventName,
      this.parameters,
      this.executeResponse,
      this.defaultResponse});

  Future<void> callDialogFlow() async {
    AIResponse response;
    try {
      AuthGoogle authGoogle = await getAuthGoogle();
      DialogFlow dialogflow = getDialogFlow(authGoogle);
      try {
        if (queryInputType == QUERY_INPUT_TYPE.QUERY) {
          response = await dialogflow.detectIntent(query);
        } else {
          response =
              await dialogflow.detectIntentByEvent(eventName, parameters);
        }
        executeResponse.call(response);
      } catch (error) {
         defaultResponse.call();
        print(error);
      }
    } catch (error) {
      defaultResponse.call();
      print(error);
    }
  }

  Future<AIResponse> callDialogFlowForGeneralReasons() async {
    AIResponse response;
    AuthGoogle authGoogle = await getAuthGoogle();
    DialogFlow dialogflow = getDialogFlow(authGoogle);
    if (queryInputType == QUERY_INPUT_TYPE.QUERY) {
      response = await dialogflow.detectIntent(query);
    } else {
      response = await dialogflow.detectIntentByEvent(eventName, parameters);
    }
    return response;
  }

  Future<AuthGoogle> getAuthGoogle() async {
    AuthGoogle authGoogle =
        await AuthGoogle(fileJson: "assets/credentials.json").build();
    return authGoogle;
  }

  DialogFlow getDialogFlow(AuthGoogle authGoogle) {
    DialogFlow dialogflow =
        DialogFlow(authGoogle: authGoogle, language: Language.english);
    return dialogflow;
  }

  Future<void> deleteDialogFlowContexts() async {
    AuthGoogle authGoogle = await getAuthGoogle();
    DialogFlow dialogflow = getDialogFlow(authGoogle);
    await dialogflow.deleteContexts();
  }
}

enum QUERY_INPUT_TYPE { EVENT, QUERY }
