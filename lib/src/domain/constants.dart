const String ADDITIONAL_FILTERS = "ask-additional-filters";
const String MOVIE_TAPPED_EVENT = "MOVIE_CARD_TAPPED";
const String WELCOME_EVENT = "Welcome";
const String APP_TITLE = "Mobo - The Movie Chatbot";
const String HINT_TEXT = "Send a message";
const String GENRES_SELECTED_OR_IGNORED = "GENRES_SELECTED_OR_IGNORED";
const String POST_WATCH_PROVIDERS_TIPS_EVENT = "TRIGGER_POST_WATCH_PROVIDERS_TIP";
const String POST_RECOMMENDATION_TIPS_EVENT = "TRIGGER_POST_RECOMMENDATION_TIP";
const String POST_ERROR_TIPS_EVENT = "TRIGGER_POST_ERROR_TIP";
const int TIPS_DURATION = 15;
const int ABSOLUTE_DURATION = 45;
const String DEFAULT_PARAMETERS_FOR_EVENT = "'parameters' : {}";
const String SHOW_GENRES = "yes, show genres";
const String IGNORE_GENRES = "no, all genres";
const String SAME_CRITERIA = "same criteria";
const String ACTION_START_OVER = "startOver";
const String ACTION_TRIGGER_TIPS = "triggerTips";
const String ACTION_MOVIE_RECOMMENDATIONS = "fetchMovieRecommendations";
const String ACTION_MORE_MOVIE_RECOMMENDATIONS = "fetchAdditionalMovieRecommendations";
const String ACTION_MOVIE_WATCH_PROVIDERS_TRAILER_VIDEOS = "fetchMovieWatchProvidersAndVideos";
const String ACTION_LOCATION_DETERMINED = "userCountryDetermined";
const String ACTION_UNKNOWN = "input.unknown";
const String ACTION_ADDITIONAL_FILTERS_PROMPTED = "additionalFiltersPrompted";
const String START_OVER_EVENT = "START_OVER";
const String SAME_CRITERIA_EVENT = "SAME_CRITERIA";
const String NO_NETWORK_MESSAGE =
    "I am facing an issue in connecting to the internet. Please check your internet connection.";
const double BOTTOM_PADDING_PIP = 16;
const double VIDEO_HEIGHT_PIP = 200;
const double VIDEO_TITLE_HEIGHT_PIP = 70;
const String DEFAULT_RESPONSE =
    "Oops, I am sorry. There seems to be some problem. Please try again or ask me to 'start over'.";
const String WAITING_MESSAGE = "Mobo is typing...";
const String ALL_GENRES_TEXT = "I want to get recommendations for all genres";
const String SELECTED_GENRES_TEXT = "I want to get recommendations for these genres: \n - ";
const String MOVIE_RESPONSE =
    "I am looking for the best recommendations for you. You can tap on any of the movie cards to look for the legal means to watch that movie in your location. I will also try to show you the trailer.";
const String ASK_FOR_MORE =
    "If you want more recommendations, just ask me to 'show more'";
const String KEY_COUNTRY_CODE = 'key_country_code';
const String TIP_TEXT = 'Tip';
const String EXPAND_TEXT = 'more';
const String COLLAPSE_TEXT = 'less';
const String JUST_WATCH_TEXT = 'This search is powered by ';
const String ABOUT_APP = 'About';
const String TMDB_CONTENT =
    'This product uses the TMDb API but is not endorsed or certified by TMDb.';
const String POWERED_BY_TMDB = 'The movie recommendations are powered by TMDb.';
const String POWERED_BY_JUST_WATCH =
    'The watch providers data is powered by JustWatch.';
const String SETTINGS = 'Settings';
const String CANCEL = 'Cancel';
const String RECEIVE_TIPS = 'Receive tips';
const String UNREAD_MESSAGE = 'UNREAD MESSAGES';
const String SHARE_APP = 'Do you sometimes struggle to select which movie to watch? Not any more. Mobo - the movie chatbot is here to help you. Download now!';
const String RECEIVE_TIPS_CONTENT = 'Select whether you want to get occasional tips';
const String SET_COUNTRY = 'Set country';
const String MOVIE_WATCH_TEXT = 'Ways to watch in';
const String TV_WATCH_TEXT = 'Ways to watch in';
const String NO_MOVIE_WATCH_TEXT = 'No ways to watch this movie in';
const String NO_TV_WATCH_TEXT = 'No ways to watch this tv show in';
const String SET_COUNTRY_LOCATION_CONTENT = 'Country to search for movie availability in';
const String HELP = 'Help';
const LOCATION_PERMISSION_TEXT = "Turn on Location Services to allow Mobo to recommend ways to watch movies in your location";
const PHONE_SETTINGS = 'Go to Phone Settings';
const CHANGE_LOCATION_FROM_APP = 'Change location from app';
const String DEFAULT_HELP_CONTENT =
    'I would love to help you out. Let me tell you how to make use of my ability to recommend the best movies for you to watch.' +
        '\n\n When you ask me to give you some movie recommendations, I always ask if you are interested in some specific genres. You can select one or more genres from the list of genres that I present. If you are not picky on genres, you can just tell me and I will not bother you with this list. Easy-peasy.' +
        '\n\nAfter this, I ask if you have any other preference. Here you are free to tell me your choices. I will try my best to look for movies based on what you ask for. For now, I am trained to look for movies based on:' +
        '\n- Actors' +
        '\n- Directors' +
        '\n- Producers' +
        '\n- Music Directors' +
        '\n- Singers' +
        '\n- Language' +
        '\n- Year or decade of release of the movie' +
        '\n\nHere are some examples of what you can ask me for:' +
        '\n\"Movies of Jack Nicholson\"' +
        '\n\"Movies of Brad Pitt and Angelina Jolie\"' +
        '\n\"Hindi movies from the 70s\"' +
        '\n\"Movies of Leonardo Dicaprio from 1997\"' +
        '\n\"Movies directed by either Martin Scorsese or Steven Spielberg\"' +
        '\n\"Movies in which Lata Mangeshkar is a singer\"' +
        '\n\"Movies having the music of Hans Zimmer\"' +
        '\n....' +
        '\n\nOnce I have looked for the most relevant movies for you, I will show you what I found. You can just tap on the movie that you want to watch and I will look for the best ways to watch that movie in your location. If available, I will also show you a trailer of the movie. At this stage, I will need your permission to know your location. I hope you will allow me that. :) I will look for means to buy, rent or stream it on a subscription based service like Netflix, etc. In case you choose not to allow me to access your location, I will show the options to watch the movie based on the country that is configured in the Settings screen of the app. You can change the default country at any time from the Settings screen.' +
        '\n\nOf course, it is likely that you don\'t like any of my recommendations, or that you have watched all those movies. If this is the case, I will still stand by your side. You can just ask me to \'Show more\'. I will give you two simple choices. One will be to show more recommendations on the same criteria that you previously chose. The other will be to start over the search with new criteria.' +
        '\n\nI hope that I am able to provide you with awesome recommendations and you enjoy every movie you watch.' +
        '\n\nHappy binging!;';
