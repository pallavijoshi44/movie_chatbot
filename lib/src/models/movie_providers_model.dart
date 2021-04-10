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

  MovieProvidersAndVideoModel(Map item) {
    if (item != null && item.isNotEmpty) {
      this.id = item['id'];
      this.title = item['title'];
      this.countryName = item['countryName'];
      this.imagePath = item['imagePath'];
      this.releaseYear = item['releaseYear'] != null ? item['releaseYear'].toString() : "";
      this.rating = item['rating'] != null ? item['rating'].toString() : "";
      this.description = item['description'];
      this.duration = item['duration'];
      this.watchProviderLink = item['watchProviderLink'];
      this.isMovie = item['isMovie'] ?? true;
      List<dynamic> providers = item['providers'];
      if (providers != null && providers.length > 0) {
        providers.forEach((element) {
          Provider provider = new Provider(element);
          this.providers.add(provider);
        });
      }
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
