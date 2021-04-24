import 'dart:convert';
import 'dart:io';

import 'package:flutter_app/src/models/movie_providers_model.dart';
import 'package:http/http.dart' show Client;

class ApiProvider {
  Client client = Client();

  final _baseUrl =
      "https://us-central1-movie-chatbot-api.cloudfunctions.net/dev/get-movie_watch_providers_and_videos";

  //final _baseUrl = "http://localhost:5001/movie-chatbot-api/us-central1/dev";

  Future<MovieProvidersAndVideoModel> fetchMovieDetails() async {
    Map data = {
      'queryResult': {
        'action': 'fetchMovieWatchProvidersAndVideos',
        'parameters': {'id': '466550', 'country_code': 'BE'}
      }
    };
    var body = json.encode(data);
    var response = await client.post(_baseUrl,
        headers: {HttpHeaders.contentTypeHeader: "application/json"},
        body: body);

    print(response.body.toString());

    if (response.statusCode == 200) {
      return MovieProvidersAndVideoModel(json.decode(response.body)['payload']['details']);
    } else {
      throw Exception('Failed to load movie details');
    }
  }
}
