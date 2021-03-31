import 'package:flutter_app/src/models/message_model.dart';

class MovieProvidersAndVideoModel extends MessageModel {
  String title;
  String countryName;
  String imagePath;
  String releaseYear;
  String rating;
  String description;
  List<dynamic> providers = [];
  String videoUrl;
  String videoThumbnail;

  MovieProvidersAndVideoModel(Map item, Map videos) {
    if (item != null && item.isNotEmpty) {
      this.title = item['title'];
      this.countryName = item['countryName'];
      this.imagePath = item['imagePath'];
      this.releaseYear = item['releaseYear'];
      this.rating = item['rating'];
      this.description = item['description'];
      List<dynamic> providers = item['providers'];
      if (providers != null && providers.length > 0) {
        providers.forEach((element) {
          Provider provider = new Provider(element);
          this.providers.add(provider);
        });
      }
    }
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
