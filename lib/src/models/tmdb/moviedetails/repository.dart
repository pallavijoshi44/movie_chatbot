
import '../../movie_providers_model.dart';
import 'api_provider.dart';

class Repository {
  ApiProvider appApiProvider = ApiProvider();

  Future<MovieProvidersAndVideoModel> fetchMovieDetails() => appApiProvider.fetchMovieDetails();
}