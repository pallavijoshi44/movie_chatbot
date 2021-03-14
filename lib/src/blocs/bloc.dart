import 'package:bloc/bloc.dart';
import 'package:flutter_app/src/api/services.dart';
import 'package:flutter_app/src/blocs/events.dart';
import 'package:flutter_app/src/blocs/states.dart';
import 'package:flutter_app/src/domain/ai_response.dart';

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
          yield DialogFlowLoaded(response: response);
        } catch (error) {
          yield DialogFlowError(error: error);
        }
        break;
    }
  }
}
