import 'package:flutter_app/src/domain/constants.dart';
import 'package:flutter_app/src/domain/parameters.dart';
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

  Map getParameters() {
    return _queryResult.parameters;
  }

  Parameters getParametersJson() {
    Parameters parameters = Parameters.fromJson(_queryResult.parameters);
    return parameters;
  }

  EntertainmentType getEntertainmentContentType() {
    if (_queryResult.action == ACTION_MOVIE_RECOMMENDATIONS)
      return EntertainmentType.MOVIE;
    else
      return EntertainmentType.TV;
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

  dynamic getPayload() {
    var payload = getListMessage()
        .firstWhere((element) => element.containsKey('payload'), orElse: null);
    return payload['payload'];
  }

  List<dynamic> getListMessage() {
    return _queryResult.fulfillmentMessages;
  }

  bool containsFulfillmentMessages() => getListMessage() != null;

  bool containsMultiSelect() {
    var payload = getListMessage().firstWhere(
        (element) => element.containsKey('payload'),
        orElse: () => null);
    return (payload != null &&
        payload['payload'] != null &&
        payload['payload']['payload'] != null &&
        payload['payload']['payload'].containsKey('card'));
  }

  bool containsCard() {
    return getCard() != null;
  }

  bool containsQuickReplies() {
    var payload = getListMessage().firstWhere(
        (element) => element.containsKey('payload'),
        orElse: () => null);
    if (payload != null) {
      return payload['payload'].containsKey('quickReplies');
    }
    return false;
  }

  bool containsPayload() {
    var payload = getListMessage().firstWhere(
        (element) => element.containsKey('payload'),
        orElse: () => null);
    if (payload != null) {
      return payload.containsKey('payload');
    }
    return false;
  }

  bool containsCarousel() {
    if (containsPayload()) {
      var payload = getPayload();
      return payload['carouselSelect'] != null;
    }
    return false;
  }

  bool containsMovieOrTvRecommendationsActions() =>
      getAction() == ACTION_MOVIE_RECOMMENDATIONS ||
      getAction() == ACTION_TV_RECOMMENDATIONS;

  bool containsMovieDetails() => getMovieDetails() != null;

  List<String> getDefaultOrChatMessage() {
    List<String> list = [];
    if (getListMessage() != null && getListMessage().length > 0) {
      getListMessage().forEach((element) {
        if (element['text'] != null && element['text']['text'] != null) {
          var listMessage = element['text']['text'];
          if (listMessage != null &&
              listMessage[0] != null &&
              listMessage[0].toString().isNotEmpty) {
            list.add(listMessage[0]);
          }
        }
      });
    }
    if (list.isEmpty) {
      var message = getMessage() != null && getMessage() != ""
          ? getMessage()
          : DEFAULT_RESPONSE;
      list.add(message);
    }
    return list;
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

  dynamic getMovieDetails() {
    if (_webhookPayload != null &&
        _webhookPayload['type'] == MULTI_SELECT_TYPE_MOVIE_DETAILS) {
      return _webhookPayload['details'];
    }
    return null;
  }

  dynamic getOldMultiSelectResponse() {
    if (_webhookPayload != null &&
        (_webhookPayload['type'] == MULTI_SELECT_TYPE_WATCH_PROVIDERS ||
            _webhookPayload['type'] == MULTI_SELECT_TYPE_GENRES)) {
      return _webhookPayload;
    }
    return null;
  }

  dynamic getMultiSelectResponse() {
    return getPayload()['payload'];
  }

  dynamic getCard() {
    return getListMessage().firstWhere((element) => element.containsKey('card'),
        orElse: () => null);
  }

  bool containsHelpContent() {
    var payload = getListMessage().firstWhere(
        (element) => element.containsKey('payload'),
        orElse: () => null);
    var hasHelpContentKey = (payload != null &&
        payload['payload'] != null &&
        payload['payload']['payload'] != null &&
        payload['payload']['payload'].containsKey('helpContent'));

    return hasHelpContentKey &&
        payload['payload']['payload']['helpContent'] != null &&
        payload['payload']['payload']['helpContent'].length > 0;
  }

  List<dynamic> helpContent() {
    var payload = getListMessage().firstWhere(
        (element) => element.containsKey('payload'),
        orElse: () => null);
    return payload['payload']['payload']['helpContent'];
  }

  bool isHelpContentClickable() {
    var payload = getListMessage().firstWhere(
        (element) => element.containsKey('payload'),
        orElse: () => null);
    return payload['payload']['payload']['helpContentClickable'];
  }

  bool isTextFieldEnabled() {
    if (containsPayload())
      return getPayload()['enableTextField'] ?? false;

    return true;
  }
}

enum EntertainmentType { MOVIE, TV }
