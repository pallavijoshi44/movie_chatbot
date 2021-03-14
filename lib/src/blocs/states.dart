import 'package:equatable/equatable.dart';
import 'package:flutter_app/src/domain/ai_response.dart';
import 'package:flutter_app/src/models/chat_model.dart';
import 'package:flutter_app/src/models/message_model.dart';
import 'package:flutter_app/src/models/reply_model.dart';
import 'package:flutter_app/src/ui/message_layout.dart';

abstract class DialogFlowState extends Equatable {

  @override
  List<Object> get props => [];

}

class DialogFlowInitState extends DialogFlowState {}

class DialogFlowLoading extends DialogFlowState {}

class DialogFlowLoaded extends DialogFlowState {
  final AIResponse response;
  DialogFlowLoaded({this.response});
}

class ChatMessageLoaded extends DialogFlowState {
  final ChatModel message;
  ChatMessageLoaded({this.message});
}

class QuickReplyLoaded extends DialogFlowState {
  final ReplyModel message;
  QuickReplyLoaded({this.message});
}


class DialogFlowError extends DialogFlowState {
  final error;
  DialogFlowError({this.error});
}