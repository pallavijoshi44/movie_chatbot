import 'package:bloc/bloc.dart';
import 'package:flutter_app/src/api/services.dart';
import 'package:flutter_app/src/blocs/events.dart';
import 'package:flutter_app/src/blocs/states.dart';
import 'package:flutter_app/src/domain/ai_response.dart';
import 'package:flutter_app/src/models/chat_model.dart';
import 'package:flutter_app/src/models/message_model.dart';
import 'package:flutter_app/src/models/reply_model.dart';
import 'package:flutter_dialogflow/v2/message.dart';

class DialogFlowBloc extends Bloc<DialogFlowEvents, DialogFlowState> {
  final DialogFlowRepo dialogFlowRepo;
  AIResponse response;

  DialogFlowBloc({this.dialogFlowRepo}) : super(DialogFlowInitState());

  @override
  Stream<DialogFlowState> mapEventToState(DialogFlowEvents event) async* {
    switch (event.eventStatus) {
      case EventStatus.fetchAIResponseForQuery:
        try {
          yield DialogFlowLoading();
          response = await dialogFlowRepo.getAIResponseForQuery(event.query);
          yield DialogFlowLoaded(response: response);
        } catch (error) {
          yield DialogFlowError(error: error);
        }
        break;

      case EventStatus.fetchAIResponseForEvents:
        try {
          yield DialogFlowLoading();
          response = await dialogFlowRepo.getAIResponseFoEvent(
              event.eventName, event.parameters);
          yield* name();
        } catch (error) {
          yield DialogFlowError(error: error);
        }
        break;
    }
  }

  Stream<DialogFlowState> name() async* {
    if (response.quickReplies != null) {
      QuickReplies replies = new QuickReplies(response.quickReplies);
      yield ChatMessageLoaded(
          message: new ChatModel(
              type: MessageType.CHAT_MESSAGE,
              text: replies.title,
              chatType: false));
      yield QuickReplyLoaded(
          message: ReplyModel(
        text: replies.title,
        quickReplies: replies.quickReplies,
        type: MessageType.QUICK_REPLY,
      ));
    }
  }
}
