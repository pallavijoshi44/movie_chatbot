class GenresContentType {
  static const movieGenresGroup1 = [ACTION, ADVENTURE, CRIME];
  static const tvGenresGroup1 = [TV_ACTION_ADVENTURE_GENRE, CRIME, MYSTERY, TV_SCI_FI_AND_FANTASY];
  static const tvMovieGroup1 = [TV_ACTION_ADVENTURE_GENRE, CRIME,  WAR, MYSTERY];
  static const movieTvGroup1 = [ACTION, ADVENTURE, CRIME,  WAR, MYSTERY];

  static const movieGenresGroup2 = [THRILLER, MYSTERY, HORROR];
  static const tvGenresGroup2 = [MYSTERY, TV_SCI_FI_AND_FANTASY, CRIME];
  static const tvMovieGroup2 = [MYSTERY, SCI_FI, FANTASY];
  static const movieTvGroup2 = [THRILLER, MYSTERY, HORROR];

  static const movieGenresGroup3 = [COMEDY, DRAMA, FAMILY, ROMANCE, MUSIC];
  static const tvGenresGroup3 = [ANIMATION, COMEDY, TV_KIDS_GENRE, FAMILY];
  static const tvMovieGroup3 = [COMEDY, DRAMA, FAMILY];
  static const movieTvGroup3 = [COMEDY, DRAMA, FAMILY, ROMANCE, MUSIC];

  static const movieGenresGroup4 = [FANTASY, SCI_FI, ANIMATION];
  static const tvGenresGroup4 = [DRAMA, TV_SOAP, TV_WAR_POLITICS, WESTERN];
  static const tvMovieGroup4 = [FANTASY, SCI_FI, ANIMATION];
  static const movieTvGroup4 = [FANTASY, SCI_FI, ANIMATION];

  static const movieGenresGroup5 = [DOCUMENTARY, WAR, WESTERN, HISTORY];
  static const tvGenresGroup5 = [DOCUMENTARY, TV_NEWS, TV_REALITY, TV_TALK];
  static const tvMovieGroup5 = [DOCUMENTARY, TV_WAR_POLITICS,WESTERN];
  static const movieTvGroup5 = [DOCUMENTARY, WAR, WESTERN, HISTORY];

  static const movieTvGroup6 = [TV_SOAP, TV_KIDS_GENRE, TV_REALITY, TV_TALK, TV_NEWS];

  final bool selected;
  final String value;

  GenresContentType(this.value, this.selected);
}

const String ACTION = "Action";
const String ADVENTURE = "Adventure";
const String CRIME = "Crime";

const String MYSTERY = "Mystery";
const String HORROR = "Horror";
const String THRILLER = "Thriller";

const String COMEDY = "Comedy";
const String DRAMA = "Drama";
const String FAMILY = "Family";
const String ROMANCE = "Romance";
const String MUSIC = "Music";

const String FANTASY = "Fantasy";
const String SCI_FI = "Science Fiction";
const String ANIMATION = "Animation";

const String DOCUMENTARY = "Documentary";
const String WAR = "War";
const String WESTERN = "Western";
const String HISTORY = "History";

const String TV_ACTION_ADVENTURE_GENRE = "Action & Adventure";
const String TV_KIDS_GENRE = "Kids";
const String TV_NEWS = "News";
const String TV_REALITY = "Reality";
const String TV_TALK = "Talk";
const String TV_SOAP = "Soap";
const String TV_WAR_POLITICS = "War & Politics";
const String TV_SCI_FI_AND_FANTASY = "Sci-Fi & Fantasy";
