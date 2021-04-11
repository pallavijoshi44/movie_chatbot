import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/src/domain/constants.dart';
import 'package:flutter_app/src/models/movie_providers_model.dart';
import 'package:flutter_app/src/ui/country/country_list_pick.dart';
import 'package:flutter_app/src/ui/movie_details/cast_details.dart';
import 'package:flutter_app/src/ui/movie_details/country_picker_widget.dart';
import 'package:flutter_app/src/ui/movie_details/movie_information.dart';
import 'package:flutter_app/src/ui/movie_details/tv_details.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'movie_description.dart';
import 'movie_just_watch.dart';
import 'movie_provider.dart';
import 'movie_thumbnail.dart';

class MovieDetailWidget extends StatelessWidget {
  static const routeName = '/movie-detail';
  final MovieProvidersAndVideoModel model;
  final SharedPreferences prefs;
  final Function onCountryChanged;

  MovieDetailWidget(this.model, this.prefs, this.onCountryChanged);

  @override
  Widget build(BuildContext context) {
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
              middle: FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(model.title,
                    style:
                        CupertinoTheme.of(context).textTheme.navTitleTextStyle),
              ),
            )
          : AppBar(
              title: FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(model.title,
                    style: Theme.of(context).appBarTheme.textTheme.title),
              ),
            ),
      body: Container(
        margin: EdgeInsets.only(bottom: 15),
        padding: EdgeInsets.only(bottom: 15),
        child: Platform.isIOS
            ? CupertinoScrollbar(
                isAlwaysShown: true,
                radiusWhileDragging: Radius.circular(15),
                thicknessWhileDragging: 2,
                child: _buildSingleChildScrollView(context, model, prefs),
              )
            : Scrollbar(
                child: _buildSingleChildScrollView(context, model, prefs),
                isAlwaysShown: true,
                showTrackOnHover: true,
                radius: Radius.circular(15),
                thickness: 5,
              ),
      ),
    );
  }

  SingleChildScrollView _buildSingleChildScrollView(BuildContext context,
      MovieProvidersAndVideoModel model, SharedPreferences prefs) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (model.videoUrl != null && model.videoThumbnail != null)
            MovieThumbnail(
                url: model.videoUrl, thumbNail: model.videoThumbnail),
          MovieInformationWidget(
            title: model.title,
            tagline: model.tagline,
            image: model.imagePath,
            year: model.releaseYear,
            rating: model.rating,
            duration: model.duration,
            homePage: model.homePage,
          ),
          if (!model.isMovie)
            TvDetailsWidget(
              nextEpisodeAirDate: model.nextEpisodeAirDate,
              lastAirDate: model.lastAirDate,
              numberOfSeasons: model.numberOfSeasons,
            ),
          if (model.providers != null && model.providers.length > 0)
            CountryPickerWidget(
              id: model.id,
              prefs: prefs,
              text: model.isMovie ? MOVIE_WATCH_TEXT : TV_WATCH_TEXT,
              onCountryChanged: onCountryChanged,
            )
          else
            CountryPickerWidget(
              id: model.id,
              prefs: prefs,
              text:  model.isMovie ? NO_MOVIE_WATCH_TEXT : NO_TV_WATCH_TEXT,
              onCountryChanged: onCountryChanged,
            ),
          if (model.providers != null)
            ...model.providers
                .map((provider) => MovieProvider(
                      title: provider.title,
                      logos: provider.logos,
                      watchProviderLink: model.watchProviderLink,
                    ))
                .toList(),
          MovieJustWatch(
            title: JUST_WATCH_TEXT,
          ),
          MovieDescriptionWidget(
            title: model.isMovie ? "About Movie" : "About TV Show",
            description: model.description,
          ),
          CastDetails(cast: model.cast)
        ],
      ),
    );
  }
}
