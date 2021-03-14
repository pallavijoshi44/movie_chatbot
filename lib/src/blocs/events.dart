enum EventStatus { fetchAIResponseForQuery, fetchAIResponseForEvents }

class DialogFlowEvents {
  final String eventName;
  final String parameters;
  final String query;
  final EventStatus eventStatus;

  DialogFlowEvents(
      {this.query, this.eventName, this.parameters, this.eventStatus});
}
