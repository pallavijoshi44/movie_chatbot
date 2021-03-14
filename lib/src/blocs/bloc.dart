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
    switch (event) {
      case DialogFlowEvents.fetchAIResponseForQuery:
        try {
          yield DialogFlowLoading();
          response = await dialogFlowRepo.getAIResponseForQuery("query");
          yield DialogFlowLoaded(response: response);
        } catch (error) {
          yield DialogFlowError(error: error);
        }
        break;

      case DialogFlowEvents.fetchAIResponseForEvents:
        try {
          yield DialogFlowLoading();
          response = await dialogFlowRepo.getAIResponseFoEvent(
              "eventName", "parameters");
          yield DialogFlowLoaded(response: response);
        } catch (error) {
          yield DialogFlowError(error: error);
        }
        break;
    }
  }
}
