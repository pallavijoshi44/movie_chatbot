import 'package:equatable/equatable.dart';
import 'package:flutter_app/src/domain/ai_response.dart';

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

class DialogFlowError extends DialogFlowState {
  final error;
  DialogFlowError({this.error});
}