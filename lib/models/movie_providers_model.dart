import 'package:flutter_app/models/message_model.dart';

class MovieProvidersModel extends MessageModel {
  String title;
  List<dynamic> providers = [];
  String urlTitle;
  String urlLink;

  MovieProvidersModel(Map item) {
    this.title = item['title'];
    List<dynamic> providers = item['providers'];
    providers.forEach((element) {
      Provider provider = new Provider(element);
      this.providers.add(provider);
    });
    this.urlTitle = item['urlTitle'];
    this.urlLink = item['urlLink'];
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
