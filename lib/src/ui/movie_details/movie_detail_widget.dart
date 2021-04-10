import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/src/domain/constants.dart';
import 'package:flutter_app/src/models/movie_providers_model.dart';
import 'package:flutter_app/src/ui/country/country_list_pick.dart';
import 'package:flutter_app/src/ui/movie_details/movie_information.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../movie_just_watch.dart';
import 'movie_description.dart';
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
              image: model.imagePath,
              year: model.releaseYear,
              rating: model.rating,
              duration: model.duration),
          if (model.providers != null && model.providers.length > 0)
            _buildCountryWidget(context, model, prefs,
                model.isMovie ? MOVIE_WATCH_TEXT : TV_WATCH_TEXT)
          else
            _buildCountryWidget(context, model, prefs,
                model.isMovie ? NO_MOVIE_WATCH_TEXT : NO_TV_WATCH_TEXT),
          if (model.providers != null)
            ...model.providers
                .map((provider) => MovieProvider(
                      title: provider.title,
                      logos: provider.logos,
                      watchProviderLink: model.watchProviderLink,
                    ))
                .toList(),
          MovieDescriptionWidget(
            title: model.isMovie ? "About Movie" : "About TV Show",
            description: model.description,
          ),
          MovieJustWatch(
            title: JUST_WATCH_TEXT,
          )
        ],
      ),
    );
  }

  Widget _buildCountryWidget(BuildContext context,
      MovieProvidersAndVideoModel model, SharedPreferences prefs, String text) {
    return Container(
      margin: EdgeInsets.only(left: 15.0, right: 15.0),
      child: Row(
        children: [
          Text(text,
              style: Platform.isIOS
                  ? CupertinoTheme.of(context).textTheme.navTitleTextStyle
                  : Theme.of(context).textTheme.title),
          Expanded(
            child: CountryListPick(
              appBar: Platform.isIOS
                  ? CupertinoNavigationBar(
                      leading: new CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: new Icon(CupertinoIcons.back, color: Colors.white),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      middle: Text('Choose Country',
                          style: CupertinoTheme.of(context)
                              .textTheme
                              .navTitleTextStyle),
                    )
                  : AppBar(title: Text('Choose Country')),
              theme: CountryTheme(
                isShowFlag: true,
                isShowTitle: true,
                isShowCode: false,
                isDownIcon: false,
                showEnglishName: true,
              ),
              initialSelection: prefs.getString(COUNTRY_CODE),
              onChanged: (CountryCode code) async {
                await prefs.setString(COUNTRY_CODE, code.code);
                onCountryChanged.call(model.id, code.code);
              },
            ),
          )
        ],
      ),
    );
  }
}
