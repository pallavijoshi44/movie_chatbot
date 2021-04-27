import 'dart:convert';
import 'dart:io';

import 'package:flutter_app/src/models/tmdb/moviedetails/movie_tv_details.dart';
import 'package:http/http.dart' show Client;

class ApiProvider {
  Client client = Client();

  final _baseUrl =
      "https://us-central1-movie-chatbot-api.cloudfunctions.net/dev/get-movie_watch_providers_and_videos";

  //final _baseUrl = "http://localhost:5001/movie-chatbot-api/us-central1/dev";

  Future<MovieTvDetailsModel> fetchMovieDetails(String id, String countryCode) async {
    Map data = {
      'queryResult': {
        'action': 'fetchMovieWatchProvidersAndVideos',
        'parameters': {'id': '$id', 'country_code': '$countryCode'}
      }
    };
    var body = json.encode(data);
    var response = await client.post(_baseUrl,
        headers: {HttpHeaders.contentTypeHeader: "application/json"},
        body: body);

    if (response.statusCode == 200) {
      return MovieTvDetailsModel(json.decode(response.body)['payload']['details']);
    } else {
      throw Exception('Failed to load movie details');
    }
  }
}
