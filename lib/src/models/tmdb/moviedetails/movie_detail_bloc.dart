
import 'package:equatable/equatable.dart';
import 'package:flutter_app/src/models/tmdb/moviedetails/movie_details_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'repository.dart';

class MovieDetailsBloc extends Bloc<MovieDetailsEvent, MovieDetailsState> {
  Repository _repository = Repository();

  MovieDetailsBloc() : super(MovieDetailsInitStateState());

  @override
  Stream<MovieDetailsState> mapEventToState(MovieDetailsEvent event) async* {
    switch (event) {
      case MovieDetailsEvent.fetchMovieDetails:
        yield MovieDetailsLoading();
        try {
          MovieDetailsModel response = await _repository.fetchMovieDetails();
          yield MovieDetailsLoaded(response);
        } catch (error) {
          yield MovieDetailsError();
        }
        break;
    }
  }
}

enum MovieDetailsEvent { fetchMovieDetails }

abstract class MovieDetailsState extends Equatable {
  @override
  List<Object> get props => [];
}

class MovieDetailsInitStateState extends MovieDetailsState {}

class MovieDetailsLoading extends MovieDetailsState {
  MovieDetailsLoading();
}

class MovieDetailsLoaded extends MovieDetailsState {
  final MovieDetailsModel model;

  MovieDetailsLoaded(this.model);
}

class MovieDetailsError extends MovieDetailsState {
  MovieDetailsError();
}
