const String ADDITIONAL_FILTERS = "ask-additional-filters";
const String MOVIE_TAPPED_EVENT = "MOVIE_CARD_TAPPED";
const String WELCOME_EVENT = "Welcome";
const String APP_TITLE = "Movie Chatbot";
const String HINT_TEXT = "Send a message";
const String GENRES_SELECTED_OR_IGNORED = "GENRES_SELECTED_OR_IGNORED";
const String QUERY_TIPS_EVENT = "TRIGGER_QUERY_TIP";
const String POST_RECOMMENDATION_TIPS_EVENT = "TRIGGER_POST_RECOMMENDATION_TIP";
const String POST_ERROR_TIPS_EVENT = "TRIGGER_POST_ERROR_TIP";
const int TIPS_DURATION = 7;
const int ABSOLUTE_DURATION = 15;
const String DEFAULT_PARAMETERS_FOR_EVENT = "'parameters' : {}";
const String SHOW_GENRES = "yes, show genres";
const String IGNORE_GENRES = "no, all genres";
const String SAME_CRITERIA = "same criteria";
const String RANDOM = "Random";
const String ACTION_START_OVER = "startOver";
const String ACTION_TRIGGER_TIPS = "triggerTips";
const String ACTION_MOVIE_RECOMMENDATIONS = "fetchMovieRecommendations";
const String ACTION_MOVIE_TRAILER_VIDEOS = "fetchMovieWatchProvidersAndVideos";
const String ACTION_UNKNOWN = "input.unknown";
const String ACTION_ADDITIONAL_FILTERS_PROMPTED = "additionalFiltersPrompted";
const String START_OVER_EVENT = "START_OVER";
const String SAME_CRITERIA_EVENT = "SAME_CRITERIA";
const String NO_NETWORK_MESSAGE =
    "There seems to be no internet connection on your device. Please enable the connection to continue";
const double BOTTOM_PADDING_PIP = 16;
const double VIDEO_HEIGHT_PIP = 200;
const double VIDEO_TITLE_HEIGHT_PIP = 70;
const String DEFAULT_RESPONSE =
    "Oops, I am sorry, something went wrong. Please try one more time or  ask me to 'Start Over' all again";
const String MOVIE_RESPONSE =
    "I am about to show you my recommendations. You can tap on any of the movie cards to check how you can watch that movie in your location and possibly watch a trailer.";
const String ASK_FOR_MORE =
    "If you want more recommendations, just ask me to 'show more'";
const String BOT_PREFIX = 'B';
const String TIP_TEXT = 'Tip';
const String EXPAND_TEXT = 'more';
const String COLLAPSE_TEXT = 'less';
const String JUST_WATCH_TEXT = 'These results are powered by ';
const String ABOUT_APP = 'About';
const String TMDB_CONTENT =
    'This product uses the TMDb API but is not endorsed or certified by TMDb.';
const String POWERED_BY_TMDB = 'The movie recommendations are powered by TMDb.';
const String POWERED_BY_JUST_WATCH =
    'The watch providers data is powered by JustWatch.';
const String SETTINGS = 'Settings';
const String RECEIVE_TIPS = 'Receive tips';
const String UNREAD_MESSAGE = 'UNREAD MESSAGES';
const String SHARE_APP = 'Checkout my app here: ';
const String RECEIVE_TIPS_CONTENT = 'Select whether you want to receive tips';
const String HELP = 'Help';
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
        '\n\nOnce I have looked for the most relevant movies for you, I will show you what I found. You can just tap on the movie that you want to watch and I will look for the best ways to watch that movie in your location. At this stage, I will need your permission to know your location. I hope you will allow me that. :) I will look for means to buy, rent, stream it on a subscription based service like Netflix, etc.' +
        '\n\nOf course, it is likely that you don\'t like any of my recommendations, or that you have watched all those movies. If this is the case, I will still stand by your side. You can just ask me to \'Show more\'. I will give you two simple choices. One will be to show more recommendations on the same criteria that you previously chose. The other will be to start over the search with new criteria.' +
        '\n\nI hope that I am able to provide you with awesome recommendations and you enjoy every movie you watch.' +
        '\n\nHappy binging!;';
