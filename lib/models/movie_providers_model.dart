import 'package:flutter_app/models/message_model.dart';

class MovieProvidersAndVideoModel extends MessageModel {
  String title;
  List<dynamic> providers = [];
  String urlTitle;
  String urlLink;
  String videoUrl;
  String videoThumbnail;

  MovieProvidersAndVideoModel(Map item, Map videos) {
    this.title = item['title'];
    List<dynamic> providers = item['providers'];
    providers.forEach((element) {
      Provider provider = new Provider(element);
      this.providers.add(provider);
    });
    this.urlTitle = item['urlTitle'];
    this.urlLink = item['urlLink'];
    this.videoUrl = videos['videoUrl'];
    this.videoThumbnail = videos['videoThumbnail'];
  }
}

class Provider {
  String title;
  List<dynamic> logos = [];

  Provider(Map response) {
    this.title = response['title'];
    List<dynamic> logos = response['logos'];
    if (logos != null ) {
      logos.forEach((element) {
        this.logos.add(element);
      });
    }
  }
}
