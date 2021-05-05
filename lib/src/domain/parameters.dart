import 'dart:convert';

import 'constants.dart';

class Parameters {
  List<dynamic> genres;
  int pageNumber;
  String likePhrases;
  String datePeriodOriginal;
  Map<String, dynamic> datePeriod;
  String customDatePeriod;
  List<dynamic> watchProviders;
  List<dynamic> watchProviderOriginal;
  List<dynamic> musicArtists;
  String countryCode;
  String sortBy;
  String countryName;
  List<dynamic> languages;
  List<dynamic> searchKeywords;
  List<dynamic> searchKeywordsOriginal;
  String movieOrTvId;
  String shortMovie;

  Parameters(
      {this.genres,
      this.pageNumber,
      this.likePhrases,
      this.datePeriodOriginal,
      this.datePeriod,
      this.customDatePeriod,
      this.watchProviders,
      this.watchProviderOriginal,
      this.musicArtists,
      this.countryCode,
      this.countryName,
      this.sortBy,
      this.movieOrTvId,
      this.searchKeywords,
      this.searchKeywordsOriginal,
      this.languages,
      this.shortMovie});

  factory Parameters.fromJson(dynamic json) {
    return Parameters(
      genres: json[KEY_GENRES] as List<dynamic>,
      pageNumber: json[KEY_PAGE_NUMBER] as int,
      likePhrases: json[KEY_LIKE_PHRASES] as String,
      datePeriodOriginal: json[KEY_DATE_PERIOD_ORIGINAL] as String,
      datePeriod: json[KEY_DATE_PERIOD] as Map<String, dynamic>,
      customDatePeriod: json[KEY_CUSTOM_DATE_PERIOD] as String,
      watchProviders: json[KEY_WATCH_PROVIDER] as List<dynamic>,
      watchProviderOriginal: json[KEY_WATCH_PROVIDER_ORIGINAL] as List<dynamic>,
      countryCode: json[KEY_COUNTRY_CODE] as String,
      sortBy: json[KEY_SORT_BY] as String,
      countryName: json[KEY_COUNTRY_NAME] as String,
      languages: json[KEY_LANGUAGE] as List<dynamic>,
      searchKeywords: json[KEY_SEARCH_KEYWORD] as List<dynamic>,
      searchKeywordsOriginal: json[KEY_SEARCH_KEYWORD_ORIGINAL] as List<dynamic>,
      movieOrTvId: json[KEY_MOVIE_OR_TV_ID] as String,
      shortMovie: json[KEY_SHORT_MOVIE] as String,
      musicArtists: json[KEY_MUSIC_ARTIST] as List<dynamic>,
    );
  }

  void setPageNumber(int pageNumber) {
    this.pageNumber = pageNumber;
  }

  @override
  String toString() {
    return "'parameters' : { "
        "${jsonEncode(KEY_GENRES)} :  ${jsonEncode(this.genres)}, "
        "${jsonEncode(KEY_MUSIC_ARTIST)} : ${jsonEncode(this.musicArtists)},"
        "${jsonEncode(KEY_WATCH_PROVIDER)} : ${jsonEncode(this.watchProviders)},"
        "${jsonEncode(KEY_WATCH_PROVIDER_ORIGINAL)} : ${jsonEncode(this.watchProviderOriginal)},"
        "${jsonEncode(KEY_LANGUAGE)} : ${jsonEncode(this.languages)},"
        "${jsonEncode(KEY_DATE_PERIOD_ORIGINAL)} : ${jsonEncode(this.datePeriodOriginal)},"
        "${jsonEncode(KEY_DATE_PERIOD)} : ${jsonEncode(this.datePeriod ?? "")},"
        "${jsonEncode(KEY_CUSTOM_DATE_PERIOD)} : ${jsonEncode(this.customDatePeriod)},"
        "${jsonEncode(KEY_SEARCH_KEYWORD)} : ${jsonEncode(this.searchKeywords)},"
        "${jsonEncode(KEY_SEARCH_KEYWORD_ORIGINAL)} : ${jsonEncode(this.searchKeywordsOriginal)},"
        "${jsonEncode(KEY_SHORT_MOVIE)} : ${jsonEncode(this.shortMovie)},"
        "${jsonEncode(KEY_PAGE_NUMBER)} : ${jsonEncode(this.pageNumber)},"
        "${jsonEncode(KEY_LIKE_PHRASES)} : ${jsonEncode(this.likePhrases)},"
        "${jsonEncode(KEY_SORT_BY)} : ${jsonEncode(this.sortBy)},"
        "${jsonEncode(KEY_COUNTRY_NAME)} : ${jsonEncode(this.countryName)},"
        "${jsonEncode(KEY_MOVIE_OR_TV_ID)} : ${jsonEncode(this.movieOrTvId)},"
        "}";
  }
}
