import 'dart:convert';
import 'dart:io';

import 'package:flutter_app/src/domain/ai_response.dart';
import 'package:flutter_app/src/models/tmdb/moviedetails/movie_tv_details.dart';
import 'package:http/http.dart' show Client;

class ApiProvider {
  Client client = Client();

  //final _baseUrl = "http://localhost:5001/movie-chatbot-api/us-central1/dev";

  Future<MovieTvDetailsModel> fetchMovieDetails(String id, String countryCode,
      EntertainmentType entertainmentType) async {
    Map data = entertainmentType == EntertainmentType.MOVIE
        ? {
            'queryResult': {
              'action': 'fetchMovieWatchProvidersAndVideos',
              'parameters': {'id': '$id', 'country_code': '$countryCode'}
            }
          }
        : {
            'queryResult': {
              'action': 'fetchTVWatchProvidersAndVideos',
              'parameters': {'id': '$id', 'country_code': '$countryCode'}
            }
          };
    var body = json.encode(data);
    final _baseUrl = entertainmentType == EntertainmentType.MOVIE
        ? "https://us-central1-movie-chatbot-api.cloudfunctions.net/dev/get-movie_watch_providers_and_videos"
        : "https://us-central1-movie-chatbot-api.cloudfunctions.net/dev/get-tv_watch_providers_and_videos";

    var response = await client.post(_baseUrl,
        headers: {HttpHeaders.contentTypeHeader: "application/json"},
        body: body);

    if (response.statusCode == 200) {
      return MovieTvDetailsModel(
          json.decode(response.body)['payload']['details']);
    } else {
      throw Exception('Failed to load movie details');
    }
  }
}
