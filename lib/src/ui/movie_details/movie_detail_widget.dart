import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/src/models/movie_providers_model.dart';

import '../movie_provider.dart';
import 'movie_thumbnail.dart';

class MovieDetailWidget extends StatelessWidget {
  static const routeName = '/movie-detail';

  @override
  Widget build(BuildContext context) {
    final routeArgs = ModalRoute.of(context).settings.arguments
        as Map<String, MovieProvidersAndVideoModel>;
    final model = routeArgs['movieDetails'];

    return Scaffold(
      appBar: Platform.isIOS
          ? CupertinoNavigationBar(
        leading: CupertinoButton(
          child: Text("Back",
              textScaleFactor: 1.0,
              style:
              CupertinoTheme.of(context).textTheme.actionTextStyle),
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.of(context).pop(),
        ),
        middle: Text("MOVIE_DETAILS",
            style:
            CupertinoTheme.of(context).textTheme.navTitleTextStyle),
      )
          : AppBar(
        title: Text("MOVIE_DETAILS"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MovieThumbnailDetail(url: model.videoUrl, thumbNail: model.videoThumbnail),
          ...model.providers.map((provider) =>  MovieProvider(
                title: provider.title,
                logos: provider.logos,
              )).toList(),
        ],
      ),
    );
  }
}
