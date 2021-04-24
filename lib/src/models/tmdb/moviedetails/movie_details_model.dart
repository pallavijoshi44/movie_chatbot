import 'package:intl/intl.dart';


class MovieDetailsModel {
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

  MovieDetailsModel(Map item) {
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
      this.lastAirDate = _parseDate(item['lastAirDate']);
      this.nextEpisodeAirDate = _parseDate(item['nextEpisodeAirDate']);
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

  String _parseDate(String date) {
    if (date != null && date.isNotEmpty) {
      return DateFormat.yMMMd().format(DateTime.parse(date));
    }
    return null;
  }

  MovieDetailsModel.fromJson(Map<String, dynamic> parsedJson) {
    id = parsedJson['id'];
    title = parsedJson['title'];
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

/*
{
    "adult": false,
    "backdrop_path": "/3ombg55JQiIpoPnXYb2oYdr6DtP.jpg",
    "belongs_to_collection": {
        "id": 484312,
        "name": "Skyline Collection",
        "poster_path": "/jaWM0xXSLeb1O2lpfQ9kI0WiGOu.jpg",
        "backdrop_path": "/b2JplRt6qfZKkupnoxl57n3r46y.jpg"
    },
    "budget": 0,
    "genres": [
        {
            "id": 878,
            "name": "Science Fiction"
        },
        {
            "id": 28,
            "name": "Action"
        }
    ],
    "homepage": "",
    "id": 560144,
    "imdb_id": "tt9387250",
    "original_language": "en",
    "original_title": "Skylines",
    "overview": "When a virus threatens to turn the now earth-dwelling friendly alien hybrids against humans, Captain Rose Corley must lead a team of elite mercenaries on a mission to the alien world in order to save what's left of humanity.",
    "popularity": 452.751,
    "poster_path": "/2W4ZvACURDyhiNnSIaFPHfNbny3.jpg",
    "production_companies": [
        {
            "id": 66497,
            "logo_path": null,
            "name": "Mirabelle Pictures Productions",
            "origin_country": ""
        },
        {
            "id": 27758,
            "logo_path": null,
            "name": "Artbox",
            "origin_country": ""
        },
        {
            "id": 146052,
            "logo_path": null,
            "name": "Fasten Films",
            "origin_country": ""
        },
        {
            "id": 117747,
            "logo_path": null,
            "name": "Media Finance Capital",
            "origin_country": "GB"
        },
        {
            "id": 99449,
            "logo_path": null,
            "name": "M45 Productions",
            "origin_country": ""
        },
        {
            "id": 10936,
            "logo_path": null,
            "name": "Hydraulx",
            "origin_country": ""
        },
        {
            "id": 150079,
            "logo_path": null,
            "name": "Gifflar Films Limited",
            "origin_country": ""
        },
        {
            "id": 9987,
            "logo_path": "/o5OTKAw7Acl5fTZYPyl8M8D9570.png",
            "name": "Lipsync Productions",
            "origin_country": "GB"
        }
    ],
    "production_countries": [
        {
            "iso_3166_1": "FR",
            "name": "France"
        },
        {
            "iso_3166_1": "LT",
            "name": "Lithuania"
        },
        {
            "iso_3166_1": "GB",
            "name": "United Kingdom"
        }
    ],
    "release_date": "2020-10-25",
    "revenue": 0,
    "runtime": 113,
    "spoken_languages": [
        {
            "english_name": "English",
            "iso_639_1": "en",
            "name": "English"
        }
    ],
    "status": "Released",
    "tagline": "To save our world she must invade theirs.",
    "title": "Skylines",
    "video": false,
    "vote_average": 5.9,
    "vote_count": 259,
    "videos": {
        "results": [
            {
                "id": "5fdccb84d4653700404bba2f",
                "iso_639_1": "en",
                "iso_3166_1": "US",
                "key": "MuuqzLwgMhY",
                "name": "Skylines | Official Trailer (HD) | Vertical Entertainment",
                "site": "YouTube",
                "size": 1080,
                "type": "Trailer"
            }
        ]
    },
    "watch/providers": {
        "results": {
            "AU": {
                "link": "https://www.themoviedb.org/movie/560144-skylines/watch?locale=AU",
                "buy": [
                    {
                        "display_priority": 3,
                        "logo_path": "/p3Z12gKq2qvJaUOMeKNU2mzKVI9.jpg",
                        "provider_id": 3,
                        "provider_name": "Google Play Movies"
                    },
                    {
                        "display_priority": 12,
                        "logo_path": "/vDCcryHD32b0yMeSCgBhuYavsmx.jpg",
                        "provider_id": 192,
                        "provider_name": "YouTube"
                    },
                    {
                        "display_priority": 30,
                        "logo_path": "/3EYDWWnkfNZO6ciRVWjv1cxnT3h.jpg",
                        "provider_id": 429,
                        "provider_name": "Telstra TV"
                    },
                    {
                        "display_priority": 33,
                        "logo_path": "/43Ykyf69e9Ca3jmTtefhINkw6PN.jpg",
                        "provider_id": 436,
                        "provider_name": "Fetch TV"
                    }
                ],
                "rent": [
                    {
                        "display_priority": 3,
                        "logo_path": "/p3Z12gKq2qvJaUOMeKNU2mzKVI9.jpg",
                        "provider_id": 3,
                        "provider_name": "Google Play Movies"
                    },
                    {
                        "display_priority": 12,
                        "logo_path": "/vDCcryHD32b0yMeSCgBhuYavsmx.jpg",
                        "provider_id": 192,
                        "provider_name": "YouTube"
                    },
                    {
                        "display_priority": 30,
                        "logo_path": "/3EYDWWnkfNZO6ciRVWjv1cxnT3h.jpg",
                        "provider_id": 429,
                        "provider_name": "Telstra TV"
                    },
                    {
                        "display_priority": 33,
                        "logo_path": "/43Ykyf69e9Ca3jmTtefhINkw6PN.jpg",
                        "provider_id": 436,
                        "provider_name": "Fetch TV"
                    }
                ],
                "flatrate": [
                    {
                        "display_priority": 0,
                        "logo_path": "/9A1JSVmSxsyaBK4SUFsYVqbAYfW.jpg",
                        "provider_id": 8,
                        "provider_name": "Netflix"
                    }
                ]
            },
            "BE": {
                "link": "https://www.themoviedb.org/movie/560144-skylines/watch?locale=BE",
                "flatrate": [
                    {
                        "display_priority": 10,
                        "logo_path": "/g3rPUj7XIHYvC2LHSG439Q7iJET.jpg",
                        "provider_id": 313,
                        "provider_name": "Yelo Play"
                    }
                ],
                "rent": [
                    {
                        "display_priority": 3,
                        "logo_path": "/p3Z12gKq2qvJaUOMeKNU2mzKVI9.jpg",
                        "provider_id": 3,
                        "provider_name": "Google Play Movies"
                    },
                    {
                        "display_priority": 18,
                        "logo_path": "/wuViyDkbFp4r7VqI0efPW5hFfQj.jpg",
                        "provider_id": 35,
                        "provider_name": "Rakuten TV"
                    }
                ],
                "buy": [
                    {
                        "display_priority": 3,
                        "logo_path": "/p3Z12gKq2qvJaUOMeKNU2mzKVI9.jpg",
                        "provider_id": 3,
                        "provider_name": "Google Play Movies"
                    },
                    {
                        "display_priority": 18,
                        "logo_path": "/wuViyDkbFp4r7VqI0efPW5hFfQj.jpg",
                        "provider_id": 35,
                        "provider_name": "Rakuten TV"
                    }
                ]
            },
            "CA": {
                "link": "https://www.themoviedb.org/movie/560144-skylines/watch?locale=CA",
                "flatrate": [
                    {
                        "display_priority": 0,
                        "logo_path": "/9A1JSVmSxsyaBK4SUFsYVqbAYfW.jpg",
                        "provider_id": 8,
                        "provider_name": "Netflix"
                    }
                ],
                "rent": [
                    {
                        "display_priority": 2,
                        "logo_path": "/q6tl6Ib6X5FT80RMlcDbexIo4St.jpg",
                        "provider_id": 2,
                        "provider_name": "Apple iTunes"
                    },
                    {
                        "display_priority": 3,
                        "logo_path": "/p3Z12gKq2qvJaUOMeKNU2mzKVI9.jpg",
                        "provider_id": 3,
                        "provider_name": "Google Play Movies"
                    },
                    {
                        "display_priority": 12,
                        "logo_path": "/vDCcryHD32b0yMeSCgBhuYavsmx.jpg",
                        "provider_id": 192,
                        "provider_name": "YouTube"
                    },
                    {
                        "display_priority": 35,
                        "logo_path": "/paq2o2dIfQnxcERsVoq7Ys8KYz8.jpg",
                        "provider_id": 68,
                        "provider_name": "Microsoft Store"
                    }
                ],
                "buy": [
                    {
                        "display_priority": 2,
                        "logo_path": "/q6tl6Ib6X5FT80RMlcDbexIo4St.jpg",
                        "provider_id": 2,
                        "provider_name": "Apple iTunes"
                    },
                    {
                        "display_priority": 3,
                        "logo_path": "/p3Z12gKq2qvJaUOMeKNU2mzKVI9.jpg",
                        "provider_id": 3,
                        "provider_name": "Google Play Movies"
                    },
                    {
                        "display_priority": 12,
                        "logo_path": "/vDCcryHD32b0yMeSCgBhuYavsmx.jpg",
                        "provider_id": 192,
                        "provider_name": "YouTube"
                    },
                    {
                        "display_priority": 35,
                        "logo_path": "/paq2o2dIfQnxcERsVoq7Ys8KYz8.jpg",
                        "provider_id": 68,
                        "provider_name": "Microsoft Store"
                    }
                ]
            },
            "DK": {
                "link": "https://www.themoviedb.org/movie/560144-skylines/watch?locale=DK",
                "rent": [
                    {
                        "display_priority": 2,
                        "logo_path": "/q6tl6Ib6X5FT80RMlcDbexIo4St.jpg",
                        "provider_id": 2,
                        "provider_name": "Apple iTunes"
                    },
                    {
                        "display_priority": 3,
                        "logo_path": "/p3Z12gKq2qvJaUOMeKNU2mzKVI9.jpg",
                        "provider_id": 3,
                        "provider_name": "Google Play Movies"
                    }
                ],
                "buy": [
                    {
                        "display_priority": 2,
                        "logo_path": "/q6tl6Ib6X5FT80RMlcDbexIo4St.jpg",
                        "provider_id": 2,
                        "provider_name": "Apple iTunes"
                    },
                    {
                        "display_priority": 3,
                        "logo_path": "/p3Z12gKq2qvJaUOMeKNU2mzKVI9.jpg",
                        "provider_id": 3,
                        "provider_name": "Google Play Movies"
                    }
                ]
            },
            "EE": {
                "link": "https://www.themoviedb.org/movie/560144-skylines/watch?locale=EE",
                "buy": [
                    {
                        "display_priority": 2,
                        "logo_path": "/q6tl6Ib6X5FT80RMlcDbexIo4St.jpg",
                        "provider_id": 2,
                        "provider_name": "Apple iTunes"
                    }
                ]
            },
            "FI": {
                "link": "https://www.themoviedb.org/movie/560144-skylines/watch?locale=FI",
                "buy": [
                    {
                        "display_priority": 2,
                        "logo_path": "/q6tl6Ib6X5FT80RMlcDbexIo4St.jpg",
                        "provider_id": 2,
                        "provider_name": "Apple iTunes"
                    },
                    {
                        "display_priority": 3,
                        "logo_path": "/p3Z12gKq2qvJaUOMeKNU2mzKVI9.jpg",
                        "provider_id": 3,
                        "provider_name": "Google Play Movies"
                    },
                    {
                        "display_priority": 19,
                        "logo_path": "/oEntjkQyz84qo1C4FZK9jW1qznl.jpg",
                        "provider_id": 423,
                        "provider_name": "Blockbuster"
                    }
                ],
                "rent": [
                    {
                        "display_priority": 2,
                        "logo_path": "/q6tl6Ib6X5FT80RMlcDbexIo4St.jpg",
                        "provider_id": 2,
                        "provider_name": "Apple iTunes"
                    },
                    {
                        "display_priority": 3,
                        "logo_path": "/p3Z12gKq2qvJaUOMeKNU2mzKVI9.jpg",
                        "provider_id": 3,
                        "provider_name": "Google Play Movies"
                    },
                    {
                        "display_priority": 19,
                        "logo_path": "/oEntjkQyz84qo1C4FZK9jW1qznl.jpg",
                        "provider_id": 423,
                        "provider_name": "Blockbuster"
                    }
                ]
            },
            "GB": {
                "link": "https://www.themoviedb.org/movie/560144-skylines/watch?locale=GB",
                "flatrate": [
                    {
                        "display_priority": 0,
                        "logo_path": "/9A1JSVmSxsyaBK4SUFsYVqbAYfW.jpg",
                        "provider_id": 8,
                        "provider_name": "Netflix"
                    }
                ],
                "rent": [
                    {
                        "display_priority": 2,
                        "logo_path": "/q6tl6Ib6X5FT80RMlcDbexIo4St.jpg",
                        "provider_id": 2,
                        "provider_name": "Apple iTunes"
                    },
                    {
                        "display_priority": 3,
                        "logo_path": "/p3Z12gKq2qvJaUOMeKNU2mzKVI9.jpg",
                        "provider_id": 3,
                        "provider_name": "Google Play Movies"
                    },
                    {
                        "display_priority": 8,
                        "logo_path": "/pZgeSWpfvD59x6sY6stT5c6uc2h.jpg",
                        "provider_id": 130,
                        "provider_name": "Sky Store"
                    },
                    {
                        "display_priority": 10,
                        "logo_path": "/sVBEF7q7LqjHAWSnKwDbzmr2EMY.jpg",
                        "provider_id": 10,
                        "provider_name": "Amazon Video"
                    },
                    {
                        "display_priority": 11,
                        "logo_path": "/vjKeS7Y9fNyqNtvp2ROCc71iu1u.jpg",
                        "provider_id": 40,
                        "provider_name": "Chili"
                    },
                    {
                        "display_priority": 12,
                        "logo_path": "/vDCcryHD32b0yMeSCgBhuYavsmx.jpg",
                        "provider_id": 192,
                        "provider_name": "YouTube"
                    },
                    {
                        "display_priority": 18,
                        "logo_path": "/wuViyDkbFp4r7VqI0efPW5hFfQj.jpg",
                        "provider_id": 35,
                        "provider_name": "Rakuten TV"
                    },
                    {
                        "display_priority": 35,
                        "logo_path": "/paq2o2dIfQnxcERsVoq7Ys8KYz8.jpg",
                        "provider_id": 68,
                        "provider_name": "Microsoft Store"
                    }
                ],
                "buy": [
                    {
                        "display_priority": 2,
                        "logo_path": "/q6tl6Ib6X5FT80RMlcDbexIo4St.jpg",
                        "provider_id": 2,
                        "provider_name": "Apple iTunes"
                    },
                    {
                        "display_priority": 3,
                        "logo_path": "/p3Z12gKq2qvJaUOMeKNU2mzKVI9.jpg",
                        "provider_id": 3,
                        "provider_name": "Google Play Movies"
                    },
                    {
                        "display_priority": 8,
                        "logo_path": "/pZgeSWpfvD59x6sY6stT5c6uc2h.jpg",
                        "provider_id": 130,
                        "provider_name": "Sky Store"
                    },
                    {
                        "display_priority": 10,
                        "logo_path": "/sVBEF7q7LqjHAWSnKwDbzmr2EMY.jpg",
                        "provider_id": 10,
                        "provider_name": "Amazon Video"
                    },
                    {
                        "display_priority": 11,
                        "logo_path": "/vjKeS7Y9fNyqNtvp2ROCc71iu1u.jpg",
                        "provider_id": 40,
                        "provider_name": "Chili"
                    },
                    {
                        "display_priority": 12,
                        "logo_path": "/vDCcryHD32b0yMeSCgBhuYavsmx.jpg",
                        "provider_id": 192,
                        "provider_name": "YouTube"
                    },
                    {
                        "display_priority": 18,
                        "logo_path": "/wuViyDkbFp4r7VqI0efPW5hFfQj.jpg",
                        "provider_id": 35,
                        "provider_name": "Rakuten TV"
                    },
                    {
                        "display_priority": 35,
                        "logo_path": "/paq2o2dIfQnxcERsVoq7Ys8KYz8.jpg",
                        "provider_id": 68,
                        "provider_name": "Microsoft Store"
                    }
                ]
            },
            "IE": {
                "link": "https://www.themoviedb.org/movie/560144-skylines/watch?locale=IE",
                "buy": [
                    {
                        "display_priority": 2,
                        "logo_path": "/q6tl6Ib6X5FT80RMlcDbexIo4St.jpg",
                        "provider_id": 2,
                        "provider_name": "Apple iTunes"
                    },
                    {
                        "display_priority": 3,
                        "logo_path": "/p3Z12gKq2qvJaUOMeKNU2mzKVI9.jpg",
                        "provider_id": 3,
                        "provider_name": "Google Play Movies"
                    },
                    {
                        "display_priority": 8,
                        "logo_path": "/pZgeSWpfvD59x6sY6stT5c6uc2h.jpg",
                        "provider_id": 130,
                        "provider_name": "Sky Store"
                    },
                    {
                        "display_priority": 18,
                        "logo_path": "/wuViyDkbFp4r7VqI0efPW5hFfQj.jpg",
                        "provider_id": 35,
                        "provider_name": "Rakuten TV"
                    }
                ],
                "rent": [
                    {
                        "display_priority": 2,
                        "logo_path": "/q6tl6Ib6X5FT80RMlcDbexIo4St.jpg",
                        "provider_id": 2,
                        "provider_name": "Apple iTunes"
                    },
                    {
                        "display_priority": 3,
                        "logo_path": "/p3Z12gKq2qvJaUOMeKNU2mzKVI9.jpg",
                        "provider_id": 3,
                        "provider_name": "Google Play Movies"
                    },
                    {
                        "display_priority": 8,
                        "logo_path": "/pZgeSWpfvD59x6sY6stT5c6uc2h.jpg",
                        "provider_id": 130,
                        "provider_name": "Sky Store"
                    },
                    {
                        "display_priority": 18,
                        "logo_path": "/wuViyDkbFp4r7VqI0efPW5hFfQj.jpg",
                        "provider_id": 35,
                        "provider_name": "Rakuten TV"
                    }
                ],
                "flatrate": [
                    {
                        "display_priority": 0,
                        "logo_path": "/9A1JSVmSxsyaBK4SUFsYVqbAYfW.jpg",
                        "provider_id": 8,
                        "provider_name": "Netflix"
                    }
                ]
            },
            "KR": {
                "link": "https://www.themoviedb.org/movie/560144-skylines/watch?locale=KR",
                "rent": [
                    {
                        "display_priority": 2,
                        "logo_path": "/8N0DNa4BO3lH24KWv1EjJh4TxoD.jpg",
                        "provider_id": 356,
                        "provider_name": "wavve"
                    },
                    {
                        "display_priority": 3,
                        "logo_path": "/p3Z12gKq2qvJaUOMeKNU2mzKVI9.jpg",
                        "provider_id": 3,
                        "provider_name": "Google Play Movies"
                    }
                ],
                "buy": [
                    {
                        "display_priority": 3,
                        "logo_path": "/p3Z12gKq2qvJaUOMeKNU2mzKVI9.jpg",
                        "provider_id": 3,
                        "provider_name": "Google Play Movies"
                    },
                    {
                        "display_priority": 4,
                        "logo_path": "/gvykO994iHcqL1Cgpii4RJCtDud.jpg",
                        "provider_id": 96,
                        "provider_name": "Naver Store"
                    }
                ]
            },
            "NL": {
                "link": "https://www.themoviedb.org/movie/560144-skylines/watch?locale=NL",
                "buy": [
                    {
                        "display_priority": 2,
                        "logo_path": "/q6tl6Ib6X5FT80RMlcDbexIo4St.jpg",
                        "provider_id": 2,
                        "provider_name": "Apple iTunes"
                    },
                    {
                        "display_priority": 3,
                        "logo_path": "/p3Z12gKq2qvJaUOMeKNU2mzKVI9.jpg",
                        "provider_id": 3,
                        "provider_name": "Google Play Movies"
                    },
                    {
                        "display_priority": 6,
                        "logo_path": "/j7qnV5qyzWDB0uOdhe5PzQh71Th.jpg",
                        "provider_id": 71,
                        "provider_name": "Pathé Thuis"
                    },
                    {
                        "display_priority": 18,
                        "logo_path": "/wuViyDkbFp4r7VqI0efPW5hFfQj.jpg",
                        "provider_id": 35,
                        "provider_name": "Rakuten TV"
                    }
                ],
                "flatrate": [
                    {
                        "display_priority": 35,
                        "logo_path": "/9sOKDL0W3HeUFAY8kCJGz9kadhC.jpg",
                        "provider_id": 563,
                        "provider_name": "KPN"
                    }
                ],
                "rent": [
                    {
                        "display_priority": 2,
                        "logo_path": "/q6tl6Ib6X5FT80RMlcDbexIo4St.jpg",
                        "provider_id": 2,
                        "provider_name": "Apple iTunes"
                    },
                    {
                        "display_priority": 3,
                        "logo_path": "/p3Z12gKq2qvJaUOMeKNU2mzKVI9.jpg",
                        "provider_id": 3,
                        "provider_name": "Google Play Movies"
                    },
                    {
                        "display_priority": 6,
                        "logo_path": "/j7qnV5qyzWDB0uOdhe5PzQh71Th.jpg",
                        "provider_id": 71,
                        "provider_name": "Pathé Thuis"
                    },
                    {
                        "display_priority": 18,
                        "logo_path": "/wuViyDkbFp4r7VqI0efPW5hFfQj.jpg",
                        "provider_id": 35,
                        "provider_name": "Rakuten TV"
                    }
                ]
            },
            "NO": {
                "link": "https://www.themoviedb.org/movie/560144-skylines/watch?locale=NO",
                "rent": [
                    {
                        "display_priority": 2,
                        "logo_path": "/q6tl6Ib6X5FT80RMlcDbexIo4St.jpg",
                        "provider_id": 2,
                        "provider_name": "Apple iTunes"
                    },
                    {
                        "display_priority": 3,
                        "logo_path": "/p3Z12gKq2qvJaUOMeKNU2mzKVI9.jpg",
                        "provider_id": 3,
                        "provider_name": "Google Play Movies"
                    },
                    {
                        "display_priority": 19,
                        "logo_path": "/oEntjkQyz84qo1C4FZK9jW1qznl.jpg",
                        "provider_id": 423,
                        "provider_name": "Blockbuster"
                    }
                ],
                "buy": [
                    {
                        "display_priority": 2,
                        "logo_path": "/q6tl6Ib6X5FT80RMlcDbexIo4St.jpg",
                        "provider_id": 2,
                        "provider_name": "Apple iTunes"
                    },
                    {
                        "display_priority": 3,
                        "logo_path": "/p3Z12gKq2qvJaUOMeKNU2mzKVI9.jpg",
                        "provider_id": 3,
                        "provider_name": "Google Play Movies"
                    },
                    {
                        "display_priority": 19,
                        "logo_path": "/oEntjkQyz84qo1C4FZK9jW1qznl.jpg",
                        "provider_id": 423,
                        "provider_name": "Blockbuster"
                    }
                ]
            },
            "NZ": {
                "link": "https://www.themoviedb.org/movie/560144-skylines/watch?locale=NZ",
                "flatrate": [
                    {
                        "display_priority": 0,
                        "logo_path": "/9A1JSVmSxsyaBK4SUFsYVqbAYfW.jpg",
                        "provider_id": 8,
                        "provider_name": "Netflix"
                    }
                ],
                "rent": [
                    {
                        "display_priority": 2,
                        "logo_path": "/q6tl6Ib6X5FT80RMlcDbexIo4St.jpg",
                        "provider_id": 2,
                        "provider_name": "Apple iTunes"
                    },
                    {
                        "display_priority": 3,
                        "logo_path": "/p3Z12gKq2qvJaUOMeKNU2mzKVI9.jpg",
                        "provider_id": 3,
                        "provider_name": "Google Play Movies"
                    }
                ],
                "buy": [
                    {
                        "display_priority": 2,
                        "logo_path": "/q6tl6Ib6X5FT80RMlcDbexIo4St.jpg",
                        "provider_id": 2,
                        "provider_name": "Apple iTunes"
                    },
                    {
                        "display_priority": 3,
                        "logo_path": "/p3Z12gKq2qvJaUOMeKNU2mzKVI9.jpg",
                        "provider_id": 3,
                        "provider_name": "Google Play Movies"
                    }
                ]
            },
            "RU": {
                "link": "https://www.themoviedb.org/movie/560144-skylines/watch?locale=RU",
                "buy": [
                    {
                        "display_priority": 2,
                        "logo_path": "/2DpMZHxP9jzu3v70bph1UD3LLv3.jpg",
                        "provider_id": 113,
                        "provider_name": "Ivi"
                    },
                    {
                        "display_priority": 3,
                        "logo_path": "/p3Z12gKq2qvJaUOMeKNU2mzKVI9.jpg",
                        "provider_id": 3,
                        "provider_name": "Google Play Movies"
                    },
                    {
                        "display_priority": 17,
                        "logo_path": "/4AWMLvjQUQNmU3CkpLp7FSSIyZX.jpg",
                        "provider_id": 501,
                        "provider_name": "Wink"
                    }
                ]
            },
            "SE": {
                "link": "https://www.themoviedb.org/movie/560144-skylines/watch?locale=SE",
                "rent": [
                    {
                        "display_priority": 2,
                        "logo_path": "/q6tl6Ib6X5FT80RMlcDbexIo4St.jpg",
                        "provider_id": 2,
                        "provider_name": "Apple iTunes"
                    },
                    {
                        "display_priority": 3,
                        "logo_path": "/p3Z12gKq2qvJaUOMeKNU2mzKVI9.jpg",
                        "provider_id": 3,
                        "provider_name": "Google Play Movies"
                    },
                    {
                        "display_priority": 19,
                        "logo_path": "/oEntjkQyz84qo1C4FZK9jW1qznl.jpg",
                        "provider_id": 423,
                        "provider_name": "Blockbuster"
                    }
                ],
                "buy": [
                    {
                        "display_priority": 2,
                        "logo_path": "/q6tl6Ib6X5FT80RMlcDbexIo4St.jpg",
                        "provider_id": 2,
                        "provider_name": "Apple iTunes"
                    },
                    {
                        "display_priority": 3,
                        "logo_path": "/p3Z12gKq2qvJaUOMeKNU2mzKVI9.jpg",
                        "provider_id": 3,
                        "provider_name": "Google Play Movies"
                    },
                    {
                        "display_priority": 19,
                        "logo_path": "/oEntjkQyz84qo1C4FZK9jW1qznl.jpg",
                        "provider_id": 423,
                        "provider_name": "Blockbuster"
                    }
                ]
            },
            "TR": {
                "link": "https://www.themoviedb.org/movie/560144-skylines/watch?locale=TR",
                "ads": [
                    {
                        "display_priority": 3,
                        "logo_path": "/hX78iJ8Mk1rEaEHolUbJ0WcZclr.jpg",
                        "provider_id": 342,
                        "provider_name": "puhutv"
                    }
                ]
            },
            "US": {
                "link": "https://www.themoviedb.org/movie/560144-skylines/watch?locale=US",
                "buy": [
                    {
                        "display_priority": 2,
                        "logo_path": "/q6tl6Ib6X5FT80RMlcDbexIo4St.jpg",
                        "provider_id": 2,
                        "provider_name": "Apple iTunes"
                    },
                    {
                        "display_priority": 3,
                        "logo_path": "/p3Z12gKq2qvJaUOMeKNU2mzKVI9.jpg",
                        "provider_id": 3,
                        "provider_name": "Google Play Movies"
                    },
                    {
                        "display_priority": 10,
                        "logo_path": "/sVBEF7q7LqjHAWSnKwDbzmr2EMY.jpg",
                        "provider_id": 10,
                        "provider_name": "Amazon Video"
                    },
                    {
                        "display_priority": 12,
                        "logo_path": "/vDCcryHD32b0yMeSCgBhuYavsmx.jpg",
                        "provider_id": 192,
                        "provider_name": "YouTube"
                    },
                    {
                        "display_priority": 18,
                        "logo_path": "/eqr1RvnDiHcM7UxmaZOIjdTmyx3.jpg",
                        "provider_id": 105,
                        "provider_name": "FandangoNOW"
                    },
                    {
                        "display_priority": 24,
                        "logo_path": "/pgaPsqgFh2grkcr7ROkoBajHJnf.jpg",
                        "provider_id": 7,
                        "provider_name": "Vudu"
                    },
                    {
                        "display_priority": 35,
                        "logo_path": "/paq2o2dIfQnxcERsVoq7Ys8KYz8.jpg",
                        "provider_id": 68,
                        "provider_name": "Microsoft Store"
                    },
                    {
                        "display_priority": 37,
                        "logo_path": "/nSr2IQSwc5C2QrttIWen8s06ofe.jpg",
                        "provider_id": 279,
                        "provider_name": "Redbox"
                    }
                ],
                "flatrate": [
                    {
                        "display_priority": 0,
                        "logo_path": "/9A1JSVmSxsyaBK4SUFsYVqbAYfW.jpg",
                        "provider_id": 8,
                        "provider_name": "Netflix"
                    },
                    {
                        "display_priority": 164,
                        "logo_path": "/xiUQmGI2bi8Rn6C5u2bArB4YHMp.jpg",
                        "provider_id": 486,
                        "provider_name": "Spectrum On Demand"
                    }
                ],
                "rent": [
                    {
                        "display_priority": 2,
                        "logo_path": "/q6tl6Ib6X5FT80RMlcDbexIo4St.jpg",
                        "provider_id": 2,
                        "provider_name": "Apple iTunes"
                    },
                    {
                        "display_priority": 3,
                        "logo_path": "/p3Z12gKq2qvJaUOMeKNU2mzKVI9.jpg",
                        "provider_id": 3,
                        "provider_name": "Google Play Movies"
                    },
                    {
                        "display_priority": 10,
                        "logo_path": "/sVBEF7q7LqjHAWSnKwDbzmr2EMY.jpg",
                        "provider_id": 10,
                        "provider_name": "Amazon Video"
                    },
                    {
                        "display_priority": 12,
                        "logo_path": "/vDCcryHD32b0yMeSCgBhuYavsmx.jpg",
                        "provider_id": 192,
                        "provider_name": "YouTube"
                    },
                    {
                        "display_priority": 18,
                        "logo_path": "/eqr1RvnDiHcM7UxmaZOIjdTmyx3.jpg",
                        "provider_id": 105,
                        "provider_name": "FandangoNOW"
                    },
                    {
                        "display_priority": 24,
                        "logo_path": "/pgaPsqgFh2grkcr7ROkoBajHJnf.jpg",
                        "provider_id": 7,
                        "provider_name": "Vudu"
                    },
                    {
                        "display_priority": 35,
                        "logo_path": "/paq2o2dIfQnxcERsVoq7Ys8KYz8.jpg",
                        "provider_id": 68,
                        "provider_name": "Microsoft Store"
                    },
                    {
                        "display_priority": 37,
                        "logo_path": "/nSr2IQSwc5C2QrttIWen8s06ofe.jpg",
                        "provider_id": 279,
                        "provider_name": "Redbox"
                    }
                ]
            },
            "ZA": {
                "link": "https://www.themoviedb.org/movie/560144-skylines/watch?locale=ZA",
                "flatrate": [
                    {
                        "display_priority": 0,
                        "logo_path": "/9A1JSVmSxsyaBK4SUFsYVqbAYfW.jpg",
                        "provider_id": 8,
                        "provider_name": "Netflix"
                    }
                ]
            }
        }
    }
}
 */