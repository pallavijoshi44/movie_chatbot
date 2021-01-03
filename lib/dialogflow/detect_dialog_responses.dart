import 'package:flutter_dialogflow/utils/language.dart';
import 'package:flutter_dialogflow/v2/auth_google.dart';

import 'dialog_flow.dart';

class DetectDialogResponses {
  final Function executeResponse;
  final QUERY_INPUT_TYPE queryInputType;
  final String eventName;
  final String query;
  final dynamic parameters;

  DetectDialogResponses(
      {this.query,
      this.queryInputType,
      this.eventName,
      this.parameters,
      this.executeResponse});

  Future<void> callDialogFlow() async {
    AIResponse response;
    try {
      AuthGoogle authGoogle = await getAuthGoogle();
      Dialogflow dialogflow = getDialogFlow(authGoogle);
      try {
        if (queryInputType == QUERY_INPUT_TYPE.QUERY) {
          response = await dialogflow.detectIntent(query);
        } else {
          response =
              await dialogflow.detectIntentByEvent(eventName, parameters);
        }
        executeResponse.call(response);
      } catch (error) {
        print(error);
      }
    } catch (error) {
      print(error);
    }
  }

  Future<AuthGoogle> getAuthGoogle() async {
    AuthGoogle authGoogle =
        await AuthGoogle(fileJson: "assets/credentials.json").build();
    return authGoogle;
  }

  Dialogflow getDialogFlow(AuthGoogle authGoogle) {
    Dialogflow dialogflow =
        Dialogflow(authGoogle: authGoogle, language: Language.english);
    return dialogflow;
  }
}

enum QUERY_INPUT_TYPE { EVENT, QUERY }
