
import '../../movie_providers_model.dart';
import 'api_provider.dart';

class Repository {
  ApiProvider appApiProvider = ApiProvider();

  Future<MovieProvidersAndVideoModel> fetchMovieDetails(String id, String countryCode) => appApiProvider.fetchMovieDetails(id, countryCode);
}