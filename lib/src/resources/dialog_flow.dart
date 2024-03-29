import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_app/src/domain/ai_response.dart';
import 'package:flutter_app/src/resources/auth_google.dart';
import 'package:http/src/response.dart';

class DialogFlow {
  final AuthGoogle authGoogle;
  final String language;

  const DialogFlow({required this.authGoogle, this.language = "en"});

  Uri _getUrl() {
    // return "https://dialogflow.googleapis.com/v2/projects/${authGoogle.getProjectId}/agent/sessions/${authGoogle.getSessionId}:detectIntent";
    String baseURL = "https://dialogflow.googleapis.com";
    String version = "v2";
    String environmentIdentifier;
    if (kReleaseMode)
      environmentIdentifier = "prod";
    else
      environmentIdentifier = "test";
    String url =
        "$baseURL/$version/projects/${authGoogle.getProjectId}/agent/environments/$environmentIdentifier/users/-/sessions/${authGoogle.getSessionId}:detectIntent";
    return Uri.parse(url);
  }

  Future<AIResponse> detectIntent(String? query) async {
    var replacedQuery = query?.replaceAll("'", "\\'");
    var response = await authGoogle?.post(_getUrl(),
        headers: {
          HttpHeaders.authorizationHeader: "Bearer ${authGoogle?.getToken}"
        },
        body:
            "{'queryInput':{'text':{'text':'$replacedQuery','language_code':'$language'}}}");
    return AIResponse(body: json.decode(response!.body));
  }

  Future<AIResponse> detectIntentByEvent(
      String? eventName, dynamic parameters) async {
    var response = await authGoogle.post(_getUrl(),
        headers: {
          HttpHeaders.authorizationHeader: "Bearer ${authGoogle.getToken}"
        },
        body:
            "{'queryInput':{'event':{'name':'$eventName','language_code':'$language',  $parameters}}}");
    return AIResponse(body: json.decode(response.body));
  }

  Future<Response> deleteContexts() async {
    String baseURL = "https://dialogflow.googleapis.com";
    String version = "v2";
    String environmentIdentifier;
    if (kReleaseMode)
      environmentIdentifier = "prod";
    else
      environmentIdentifier = "test";
    String url = "$baseURL/$version/projects/${authGoogle.getProjectId}/agent/environments/$environmentIdentifier/users/-/sessions/${authGoogle.getSessionId}/contexts";
    var response = await authGoogle.delete(Uri.parse(url), headers: {
      HttpHeaders.authorizationHeader: "Bearer ${authGoogle.getToken}"
    }, encoding: null);
    return response;


    // var url =
    //     "https://dialogflow.googleapis.com/v2/projects/${authGoogle.getProjectId}/agent/sessions/${authGoogle.getSessionId}/contexts";
  }
}
