import 'package:flutter_app/src/models/message_model.dart';

class MovieProvidersAndVideoModel extends MessageModel {
  int id;
  String title;
  String countryName;
  String imagePath;
  String releaseYear;
  String rating;
  String description;
  List<dynamic> providers = [];
  String videoUrl;
  String videoThumbnail;
  String duration;
  String watchProviderLink;
  bool isMovie;
  String homePage;
  String lastAirDate;
  String nextEpisodeAirDate;
  int numberOfSeasons;
  String tagline;
  List<dynamic> cast = [];

  MovieProvidersAndVideoModel(Map item) {
    if (item != null && item.isNotEmpty) {
      this.id = item['id'];
      this.title = item['title'];
      this.countryName = item['countryName'];
      this.imagePath = item['imagePath'];
      this.releaseYear =
          item['releaseYear'] != null ? item['releaseYear'].toString() : "";
      this.rating = item['rating'] != null ? item['rating'].toString() : "";
      this.description = item['description'];
      this.duration = item['duration'];
      this.watchProviderLink = item['watchProviderLink'];
      this.isMovie = item['isMovie'] ?? true;
      this.homePage = item['homePage'] ?? "";
      this.lastAirDate = item['lastAirDate'];
      this.nextEpisodeAirDate = item['nextEpisodeAirDate'];
      this.numberOfSeasons = item['numberOfSeasons'];
      this.tagline = item['tagline'];
      List<dynamic> providers = item['providers'];
      if (providers != null && providers.length > 0) {
        providers.forEach((element) {
          Provider provider = new Provider(element);
          this.providers.add(provider);
        });
      }
    }
    List<dynamic> casts = item['cast'];
    if (casts != null && casts.length > 0) {
      casts.forEach((element) {
        Cast cast = new Cast(element);
        this.cast.add(cast);
      });
    }
    var videos = item['videos'];
    if (videos != null && videos.isNotEmpty) {
      this.videoUrl = videos['videoUrl'];
      this.videoThumbnail = videos['videoThumbnail'];
    }
  }
}

class Provider {
  String title;
  List<dynamic> logos = [];

  Provider(Map response) {
    this.title = response['title'];
    List<dynamic> logos = response['logos'];
    if (logos != null) {
      logos.forEach((element) {
        this.logos.add(element);
      });
    }
  }
}

class Cast {
  String name;
  String profile;

  Cast(Map response) {
    this.name = response['title'];
    this.profile = response['profile'];
  }
}
