import 'package:flutter_app/src/domain/constants.dart';
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

  List<String> getChatMessage() {
    return getDefaultOrChatMessage();
  }

  List<String> getDefaultOrChatMessage() {
    List<String> list = [];
    if (getListMessage() != null && getListMessage().length > 0) {
      getListMessage().forEach((element) {
        var listMessage = element['text']['text'];
        if (listMessage != null &&
            listMessage[0] != null &&
            listMessage[0].toString().isNotEmpty) {
          list.add(listMessage[0]);
        }
      });
    }
    if (list.isEmpty) {
      var message = getMessage() ?? DEFAULT_RESPONSE;
      list.add(message);
    }
    return list;
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
