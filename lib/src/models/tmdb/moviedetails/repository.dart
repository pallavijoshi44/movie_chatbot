
import 'api_provider.dart';
import 'movie_tv_details.dart';

class Repository {
  ApiProvider appApiProvider = ApiProvider();

  Future<MovieTvDetailsModel> fetchMovieDetails(String id, String countryCode) => appApiProvider.fetchMovieDetails(id, countryCode);
}