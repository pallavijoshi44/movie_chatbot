import 'package:equatable/equatable.dart';
import 'package:flutter_app/src/domain/ai_response.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'movie_tv_details.dart';
import 'repository.dart';

// abstract class MovieDetailsEventStatus {}
//
// class Loading extends MovieDetailsEventStatus {}
//
// class Success extends MovieDetailsEventStatus {
//   final String countryCode;
//   final String id;
//   final EntertainmentType entertainmentType;
//
//   Success(
//       {required this.countryCode,
//       required this.id,
//       required this.entertainmentType});
// }
//
// class Error extends MovieDetailsEventStatus {}

class MovieDetailsBloc extends Bloc<MovieDetailsEvent, MovieDetailsState> {
  MovieDetailsBloc() : super(MovieDetailsInitStateState()) {

    on<MovieDetailsEvent>((event, emit) async {
      emit(MovieDetailsLoading());
      Repository _repository = Repository();
      try {
        MovieTvDetailsModel response = await _repository.fetchMovieDetails(
            event.id, event.countryCode, event.entertainmentType);
        emit(MovieDetailsLoaded(response));
      } catch (error) {
        emit(MovieDetailsError());
      }
    });
  }
}
//class MovieDetailsBloc extends Bloc<MovieDetailsEventStatus, MovieDetailsState> {

//MovieDetailsBloc() : super(MovieDetailsInitStateState());

// @override
// Stream<MovieDetailsState> mapEventToState(MovieDetailsEvent event) async* {
//   switch (event.eventStatus) {
//     case EventStatus.fetchMovieDetails:
//       yield MovieDetailsLoading();
//       try {
//         MovieTvDetailsModel response = await _repository.fetchMovieDetails(event.id, event.countryCode, event.entertainmentType);
//         yield MovieDetailsLoaded(response);
//       } catch (error) {
//         yield MovieDetailsError();
//       }
//       break;
//   }
// }

class MovieDetailsEvent {
  final String countryCode;
  final String id;
  final EntertainmentType entertainmentType;
  final EventStatus eventStatus;

  MovieDetailsEvent(
      {required this.countryCode,
      required this.id,
      required this.eventStatus,
      required this.entertainmentType});
}

enum EventStatus { fetchMovieDetails }

abstract class MovieDetailsState extends Equatable {
  @override
  List<Object> get props => [];
}

class MovieDetailsInitStateState extends MovieDetailsState {}

class MovieDetailsLoading extends MovieDetailsState {
  MovieDetailsLoading();
}

class MovieDetailsLoaded extends MovieDetailsState {
  final MovieTvDetailsModel model;

  MovieDetailsLoaded(this.model);
}

class MovieDetailsError extends MovieDetailsState {
  MovieDetailsError();
}
