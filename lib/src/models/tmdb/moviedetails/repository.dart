import 'package:flutter_app/src/domain/ai_response.dart';

import 'api_provider.dart';
import 'movie_tv_details.dart';

class Repository {
  ApiProvider appApiProvider = ApiProvider();

  Future<MovieTvDetailsModel> fetchMovieDetails(
          String id, String countryCode, EntertainmentType entertainmentType) =>
      appApiProvider.fetchMovieDetails(id, countryCode, entertainmentType);
}
