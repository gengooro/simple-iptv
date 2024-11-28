import 'package:hive_flutter/hive_flutter.dart';

part 'series.g.dart';

@HiveType(typeId: 7)
class SeriesStreamModel extends HiveObject {
  @HiveField(0)
  int? num;

  @HiveField(1)
  String? name;

  @HiveField(2)
  String? seriesId;

  @HiveField(3)
  String? cover;

  @HiveField(4)
  String? plot;

  @HiveField(5)
  String? cast;

  @HiveField(6)
  String? director;

  @HiveField(7)
  String? genre;

  @HiveField(8)
  String? releaseDate;

  @HiveField(9)
  String? lastModified;

  @HiveField(10)
  String? rating;

  @HiveField(11)
  String? rating5based;

  @HiveField(12)
  List<String>? backdropPath;

  @HiveField(13)
  String? youtubeTrailer;

  @HiveField(14)
  String? tmdb;

  @HiveField(15)
  String? episodeRunTime;

  @HiveField(16)
  String? categoryId;

  SeriesStreamModel({
    this.num,
    this.name,
    this.seriesId,
    this.cover,
    this.plot,
    this.cast,
    this.director,
    this.genre,
    this.releaseDate,
    this.lastModified,
    this.rating,
    this.rating5based,
    this.backdropPath,
    this.youtubeTrailer,
    this.tmdb,
    this.episodeRunTime,
    this.categoryId,
  });

  factory SeriesStreamModel.fromJson(Map<String, dynamic> json) {
    return SeriesStreamModel(
      num: json['num'] is String ? int.tryParse(json['num']) : json['num'],
      name: json['name'] is int ? json['name'].toString() : json['name'],
      seriesId: json['series_id'] is int
          ? json['series_id'].toString()
          : json['series_id'],
      cover: json['cover'] is int ? json['cover'].toString() : json['cover'],
      plot: json['plot'] is int ? json['plot'].toString() : json['plot'],
      cast: json['cast'] is int ? json['cast'].toString() : json['cast'],
      director: json['director'] is int
          ? json['director'].toString()
          : json['director'],
      genre: json['genre'] is int ? json['genre'].toString() : json['genre'],
      releaseDate: json['releaseDate'] is int
          ? json['releaseDate'].toString()
          : json['releaseDate'],
      lastModified: json['last_modified'] is int
          ? json['last_modified'].toString()
          : json['last_modified'],
      rating: json['rating'] is double || json['rating'] is int
          ? json['rating'].toString()
          : json['rating'],
      rating5based:
          json['rating_5based'] is double || json['rating_5based'] is int
              ? json['rating_5based'].toString()
              : json['rating_5based'],
      backdropPath: json['backdrop_path'] is List
          ? List<String>.from(
              json['backdrop_path'].map((item) => item.toString()),
            )
          : null,
      youtubeTrailer: json['youtube_trailer'] is int
          ? json['youtube_trailer'].toString()
          : json['youtube_trailer'],
      tmdb: json['tmdb'] is int ? json['tmdb'].toString() : json['tmdb'],
      episodeRunTime: json['episode_run_time'] is int
          ? json['episode_run_time'].toString()
          : json['episode_run_time'],
      categoryId: json['category_id'] is int
          ? json['category_id'].toString()
          : json['category_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['num'] = num;
    data['name'] = name;
    data['series_id'] = seriesId;
    data['cover'] = cover;
    data['plot'] = plot;
    data['cast'] = cast;
    data['director'] = director;
    data['genre'] = genre;
    data['releaseDate'] = releaseDate;
    data['last_modified'] = lastModified;
    data['rating'] = rating;
    data['rating_5based'] = rating5based;
    data['backdrop_path'] = backdropPath;
    data['youtube_trailer'] = youtubeTrailer;
    data['tmdb'] = tmdb;
    data['episode_run_time'] = episodeRunTime;
    data['category_id'] = categoryId;
    return data;
  }

  @override
  String toString() {
    return 'Series{num: $num, name: $name, seriesId: $seriesId, cover: $cover, plot: $plot, cast: $cast, director: $director, genre: $genre, releaseDate: $releaseDate, lastModified: $lastModified, rating: $rating, rating5based: $rating5based, backdropPath: $backdropPath, youtubeTrailer: $youtubeTrailer, tmdb: $tmdb, episodeRunTime: $episodeRunTime, categoryId: $categoryId}';
  }
}
