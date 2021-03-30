import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/src/models/movie_providers_model.dart';
import 'package:flutter_app/src/ui/movie_details/movie_information.dart';
import 'movie_description.dart';
import 'movie_provider.dart';
import 'movie_thumbnail.dart';

class MovieDetailWidget extends StatelessWidget {
  static const routeName = '/movie-detail';

  @override
  Widget build(BuildContext context) {
    final routeArgs = ModalRoute.of(context).settings.arguments
        as Map<String, MovieProvidersAndVideoModel>;
    final model = routeArgs['movieDetails'];

    return Scaffold(
      backgroundColor: Color.fromRGBO(249, 248, 235, 1),
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
              title: Text("MOVIE_DETAILS", style:  Theme.of(context).appBarTheme.textTheme.title),
            ),
      body: Container(
        margin: EdgeInsets.only(bottom: 15),
        padding: EdgeInsets.only(bottom: 15),
        child: Platform.isIOS
            ? CupertinoScrollbar(
                isAlwaysShown: true,
                radiusWhileDragging: Radius.circular(15),
                thicknessWhileDragging: 2,
                child: _buildSingleChildScrollView(model),
              )
            : Scrollbar(
                child: _buildSingleChildScrollView(model),
                isAlwaysShown: true,
                showTrackOnHover: true,
                radius: Radius.circular(15),
                thickness: 5,
              ),
      ),
    );
  }

  SingleChildScrollView _buildSingleChildScrollView(
      MovieProvidersAndVideoModel model) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MovieThumbnail(url: model.videoUrl, thumbNail: model.videoThumbnail),
          MovieInformationWidget(),
          MovieDescriptionWidget(),
          ...model.providers
              .map((provider) => MovieProvider(
                    title: provider.title,
                    logos: provider.logos,
                  ))
              .toList(),
        ],
      ),
    );
  }
}
