import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_app/src/domain/ai_response.dart';
import 'package:flutter_app/src/resources/dialog_flow.dart';
import 'package:flutter_dialogflow/utils/language.dart';
import 'package:flutter_dialogflow/v2/auth_google.dart';

abstract class DialogFlowRepo {
  Future<AIResponse> getAIResponseForQuery(String query);

  Future<AIResponse> getAIResponseFoEvent(String eventName, String parameters);
}

class DialogFlow extends DialogFlowRepo {
  @override
  Future<AIResponse> getAIResponseForQuery(String query) async {
    AuthGoogle authGoogle = await _getAuthGoogle();
    var replacedQuery = query.replaceAll("'", "\\'");
    var response = await authGoogle.post(
        _getUrl(authGoogle.getProjectId, authGoogle.getSessionId),
        headers: {
          HttpHeaders.authorizationHeader: "Bearer ${authGoogle.getToken}"
        },
        body:
            "{'queryInput':{'text':{'text':'$replacedQuery','language_code':'${Language.english}'}}}");
    return AIResponse(body: json.decode(response.body));
  }

  @override
  Future<AIResponse> getAIResponseFoEvent(
      String eventName, String parameters) async {
    AuthGoogle authGoogle = await _getAuthGoogle();
    var url = await _getUrl(authGoogle.getProjectId, authGoogle.getSessionId);
    var response = await authGoogle.post(url,
        headers: {
          HttpHeaders.authorizationHeader: "Bearer ${authGoogle.getToken}"
        },
        body:
            "{'queryInput':{'event':{'name':'$eventName','language_code':'${Language.english}',  $parameters}}}");
    return AIResponse(body: json.decode(response.body));
  }
}

Future<String> _getUrl(String projectId, String sessionId) async {
  //return "https://dialogflow.googleapis.com/v2/projects/${authGoogle.getProjectId}/agent/sessions/${authGoogle.getSessionId}:detectIntent";
  String baseURL = "https://dialogflow.googleapis.com";
  String version = "v2";
  String environmentIdentifier;
  if (kReleaseMode)
    environmentIdentifier = "production";
  else
    environmentIdentifier = "test";
  String url =
      "$baseURL/$version/projects/$projectId/agent/environments/$environmentIdentifier/users/-/sessions/$sessionId:detectIntent";
  return url;
}

Future<AuthGoogle> _getAuthGoogle() async {
  AuthGoogle authGoogle =
      await AuthGoogle(fileJson: "assets/credentials.json").build();
  return authGoogle;
}
