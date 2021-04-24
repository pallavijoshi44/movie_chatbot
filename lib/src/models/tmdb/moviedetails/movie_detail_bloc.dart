
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../movie_providers_model.dart';
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
          MovieProvidersAndVideoModel response = await _repository.fetchMovieDetails();
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
  final MovieProvidersAndVideoModel model;

  MovieDetailsLoaded(this.model);
}

class MovieDetailsError extends MovieDetailsState {
  MovieDetailsError();
}


