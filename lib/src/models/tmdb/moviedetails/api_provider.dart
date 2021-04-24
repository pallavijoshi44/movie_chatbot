import 'dart:convert';

import 'package:flutter_app/src/models/tmdb/moviedetails/movie_details_model.dart';
import 'package:http/http.dart' show Client;

import '../api_key.dart';

class ApiProvider {
  Client client = Client();

  final _baseUrl =
  "https://api.themoviedb.org/3/movie/560144?api_key=$API_KEY&append_to_response=videos,watch/providers";

  Future<MovieDetailsModel> fetchMovieDetails() async {
    final response = await client.get("$_baseUrl"); // Make the network call asynchronously to fetch the London weather data.
    print(response.body.toString());

    if (response.statusCode == 200) {
      return MovieDetailsModel.fromJson(json.decode(response.body)); //Return decoded response
    } else {
      throw Exception('Failed to load weather');
    }
  }
}