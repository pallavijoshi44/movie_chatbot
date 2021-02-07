import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogflow/v2/auth_google.dart';
import 'package:flutter_dialogflow/v2/dialogflow_v2.dart';

class AIResponse {
  String _responseId;
  QueryResult _queryResult;
  num _intentDetectionConfidence;
  String _languageCode;
  DiagnosticInfo _diagnosticInfo;
  WebhookStatus _webhookStatus;
  dynamic _webhookPayload;

  AIResponse({Map body}) {
    _responseId = body['responseId'];
    _intentDetectionConfidence = body['intentDetectionConfidence'];
    _queryResult = new QueryResult(body['queryResult']);
    _languageCode = body['languageCode'];
    _diagnosticInfo = (body['diagnosticInfo'] != null
        ? new DiagnosticInfo(body['diagnosticInfo'])
        : null);
    _webhookStatus = body['webhookStatus'] != null
        ? new WebhookStatus(body['webhookStatus'])
        : null;
    _webhookPayload = body['queryResult']['webhookPayload'] != null
        ? body['queryResult']['webhookPayload']
        : null;
  }

  String get responseId {
    return _responseId;
  }

  String getMessage() {
    return _queryResult.fulfillmentText;
  }

  List<dynamic> getListMessage() {
    return _queryResult.fulfillmentMessages;
  }

  String getAction() {
    return _queryResult.action;
  }

  dynamic getWebHookPayload() {
    return _webhookPayload;
  }

  num get intentDetectionConfidence {
    return _intentDetectionConfidence;
  }

  String get languageCode {
    return _languageCode;
  }

  DiagnosticInfo get diagnosticInfo {
    return _diagnosticInfo;
  }

  WebhookStatus get webhookStatus {
    return _webhookStatus;
  }

  QueryResult get queryResult {
    return _queryResult;
  }
}

class Dialogflow {
  final AuthGoogle authGoogle;
  final String language;

  const Dialogflow({@required this.authGoogle, this.language = "en"});

  String _getUrl() {
    //return "https://dialogflow.googleapis.com/v2/projects/${authGoogle.getProjectId}/agent/sessions/${authGoogle.getSessionId}:detectIntent";
    String baseURL = "https://dialogflow.googleapis.com";
    String version = "v2";
    String environmentIdentifier;
    if (kReleaseMode)
      environmentIdentifier = "production";
    else
      environmentIdentifier = "test";
    String url = "$baseURL/$version/projects/${authGoogle.getProjectId}/agent/environments/$environmentIdentifier/users/-/sessions/${authGoogle.getSessionId}:detectIntent";
    return url;
  }

  Future<AIResponse> detectIntent(String query) async {
   var replacedQuery =  query.replaceAll("'", "\\'");
    var response = await authGoogle.post(_getUrl(),
        headers: {
          HttpHeaders.authorizationHeader: "Bearer ${authGoogle.getToken}"
        },
        body:
            "{'queryInput':{'text':{'text':'$replacedQuery','language_code':'$language'}}}");
    return AIResponse(body: json.decode(response.body));
  }

  Future<AIResponse> detectIntentByEvent(
      String eventName, dynamic parameters) async {
    var response = await authGoogle.post(_getUrl(),
        headers: {
          HttpHeaders.authorizationHeader: "Bearer ${authGoogle.getToken}"
        },
        body:
            "{'queryInput':{'event':{'name':'$eventName','language_code':'$language',  $parameters}}}");
    return AIResponse(body: json.decode(response.body));
  }
}
