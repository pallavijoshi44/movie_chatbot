import 'package:flutter_app/src/models/tmdb/moviedetails/movie_details_model.dart';

import 'api_provider.dart';

class Repository {
  ApiProvider appApiProvider = ApiProvider();

  Future<MovieDetailsModel> fetchMovieDetails() => appApiProvider.fetchMovieDetails();
}