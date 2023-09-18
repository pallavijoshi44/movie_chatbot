import 'package:flutter_app/src/models/message_model.dart';
import 'package:intl/intl.dart';


class MovieTvDetailsModel extends MessageModel {
  String id = "";
  String? title = "";
  String? countryName = "";
  String? imagePath = "";
  String? releaseYear = "";
  String? rating = "";
  String? description = "";
  List<dynamic>? providers = [];
  String? videoUrl = "";
  String? videoThumbnail = "";
  String? duration = "";
  String? watchProviderLink = "";
  bool isMovie = false;
  String? homePage = "";
  String? lastAirDate = "";
  String? nextEpisodeAirDate = "";
  int? numberOfSeasons;
  String? tagline = "";
  List<dynamic> cast = [];

  MovieTvDetailsModel(Map item) {
    if (item.isNotEmpty) {
      this.id = item['id'].toString();
      this.title = item['title'];
      this.countryName = item['countryName'];
      this.imagePath = item['imagePath'];
      this.releaseYear =
          item['releaseYear'] != null ? item['releaseYear'].toString() : "";
      this.rating = item['rating'] != null ? item['rating'].toString() : "";
      this.description = item['description'] != null ?  item['description'] : "";
      this.duration = item['duration'];
      this.watchProviderLink = item['watchProviderLink'];
      this.isMovie = item['isMovie'] ?? true;
      this.homePage = item['homePage'] ?? "";
      this.lastAirDate = _parseDate(item['lastAirDate']);
      this.nextEpisodeAirDate = _parseDate(item['nextEpisodeAirDate']);
      this.numberOfSeasons = item['numberOfSeasons'];
      this.tagline = item['tagline'];
      List<dynamic>? providers = item['providers'];
      if (providers != null && providers.length > 0) {
        providers.forEach((element) {
          Provider provider = new Provider(element);
          this.providers?.add(provider);
        });
      }
    }
    List<dynamic>? casts = item['cast'];
    if (casts != null && casts.length > 0) {
      casts.forEach((element) {
        Cast cast = new Cast(element);
        this.cast?.add(cast);
      });
    }
    var videos = item['videos'];
    if (videos != null && videos.isNotEmpty) {
      this.videoUrl = videos['videoUrl'];
      this.videoThumbnail = videos['videoThumbnail'];
    }
  }

  String? _parseDate(String? date) {
    if (date != null && date.isNotEmpty) {
      return DateFormat.yMMMd().format(DateTime.parse(date));
    }
    return null;
  }
}

class Provider {
  String? title;
  List<dynamic> logos = [];

  Provider(Map response) {
    this.title = response['title'];
    List<dynamic>? logos = response['logos'];
    if (logos != null) {
      logos.forEach((element) {
        this.logos.add(element);
      });
    }
  }
}

class Cast {
  String? name;
  String? profile;

  Cast(Map response) {
    this.name = response['title'];
    this.profile = response['profile'];
  }
}
