class SeriesData {
  List<Season>? seasons;
  Info? info;
  Map<int, List<Episode>>? episodes;

  SeriesData({this.seasons, this.info, this.episodes});

  factory SeriesData.fromJson(Map<String, dynamic> json) {
    return SeriesData(
      seasons: json['seasons'] != null
          ? (json['seasons'] as List).map((e) => Season.fromJson(e)).toList()
          : null,
      info: json['info'] != null ? Info.fromJson(json['info']) : null,
      episodes: json['episodes'] != null
          ? (json['episodes'] as Map<String, dynamic>).map(
              (key, value) => MapEntry(
                int.parse(key),
                (value as List).map((e) => Episode.fromJson(e)).toList(),
              ),
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'seasons': seasons?.map((e) => e.toJson()).toList(),
      'info': info?.toJson(),
      'episodes': episodes?.map((key, value) => MapEntry(
            key.toString(),
            value.map((e) => e.toJson()).toList(),
          )),
    };
  }

  @override
  String toString() {
    return 'SeriesData(seasons: $seasons, info: $info, episodes: $episodes)';
  }
}

class Season {
  String? name;
  String? episodeCount;
  String? overview;
  String? airDate;
  String? cover;
  String? coverTmdb;
  int? seasonNumber;
  String? coverBig;
  String? releaseDate;
  String? duration;

  Season({
    this.name,
    this.episodeCount,
    this.overview,
    this.airDate,
    this.cover,
    this.coverTmdb,
    this.seasonNumber,
    this.coverBig,
    this.releaseDate,
    this.duration,
  });

  factory Season.fromJson(Map<String, dynamic> json) {
    return Season(
      name: json['name'],
      episodeCount: json['episode_count'],
      overview: json['overview'],
      airDate: json['air_date'],
      cover: json['cover'],
      coverTmdb: json['cover_tmdb'],
      seasonNumber: json['season_number'],
      coverBig: json['cover_big'],
      releaseDate: json['releaseDate'],
      duration: json['duration'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'episode_count': episodeCount,
      'overview': overview,
      'air_date': airDate,
      'cover': cover,
      'cover_tmdb': coverTmdb,
      'season_number': seasonNumber,
      'cover_big': coverBig,
      'releaseDate': releaseDate,
      'duration': duration,
    };
  }

  @override
  String toString() {
    return 'Season(name: $name, episodeCount: $episodeCount, overview: $overview, airDate: $airDate, cover: $cover)';
  }
}

class Info {
  String? name;
  String? cover;
  String? plot;
  String? cast;
  String? director;
  String? genre;
  String? releaseDate;
  String? lastModified;
  String? rating;
  String? rating5Based;
  List<String>? backdropPath;
  String? tmdb;
  String? youtubeTrailer;
  String? episodeRunTime;
  String? categoryId;

  Info({
    this.name,
    this.cover,
    this.plot,
    this.cast,
    this.director,
    this.genre,
    this.releaseDate,
    this.lastModified,
    this.rating,
    this.rating5Based,
    this.backdropPath,
    this.tmdb,
    this.youtubeTrailer,
    this.episodeRunTime,
    this.categoryId,
  });

  factory Info.fromJson(Map<String, dynamic> json) {
    return Info(
      name: json['name'],
      cover: json['cover'],
      plot: json['plot'],
      cast: json['cast'],
      director: json['director'],
      genre: json['genre'],
      releaseDate: json['releaseDate'],
      lastModified: json['last_modified'],
      rating: json['rating'],
      rating5Based: json['rating_5based'],
      backdropPath: json['backdrop_path'] != null
          ? List<String>.from(json['backdrop_path'])
          : null,
      tmdb: json['tmdb'],
      youtubeTrailer: json['youtube_trailer'],
      episodeRunTime: json['episode_run_time'],
      categoryId: json['category_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'cover': cover,
      'plot': plot,
      'cast': cast,
      'director': director,
      'genre': genre,
      'releaseDate': releaseDate,
      'last_modified': lastModified,
      'rating': rating,
      'rating_5based': rating5Based,
      'backdrop_path': backdropPath,
      'tmdb': tmdb,
      'youtube_trailer': youtubeTrailer,
      'episode_run_time': episodeRunTime,
      'category_id': categoryId,
    };
  }

  @override
  String toString() {
    return 'Info(name: $name, plot: $plot, genre: $genre, rating: $rating)';
  }
}

class Episode {
  final String id;
  final int episodeNum;
  final String title;
  final String containerExtension;
  final int season;

  Episode({
    required this.id,
    required this.episodeNum,
    required this.title,
    required this.containerExtension,
    required this.season,
  });

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
      id: json['id'],
      episodeNum: json['episode_num'],
      title: json['title'],
      containerExtension: json['container_extension'],
      season: json['season'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'episode_num': episodeNum,
      'title': title,
      'container_extension': containerExtension,
      'season': season,
    };
  }

  @override
  String toString() {
    return 'Episode(id: $id, title: $title, episodeNum: $episodeNum, season: $season, containerExtension: $containerExtension)';
  }
}
