import 'package:iptv/models/tmdb_vod.dart';

class VodDataModel {
  TmdbVod? tmdbVod;
  VodDataServer? vodDataServer;

  VodDataModel({this.tmdbVod, this.vodDataServer});

  VodDataModel.fromJson(Map<String, dynamic> json) {
    tmdbVod =
        json['tmdb_vod'] != null ? TmdbVod.fromJson(json['tmdb_vod']) : null;
    vodDataServer = json['vod_data_server'] != null
        ? VodDataServer.fromJson(json['vod_data_server'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (tmdbVod != null) {
      data['tmdb_vod'] = tmdbVod!.toJson();
    }
    if (vodDataServer != null) {
      data['vod_data_server'] = vodDataServer!.toJson();
    }
    return data;
  }

  @override
  String toString() {
    return 'VodDataModel{tmdbVod: $tmdbVod, vodDataServer: $vodDataServer}';
  }
}

class VodDataServer {
  MovieData? movieData;
  Info? info;

  VodDataServer({this.movieData, this.info});

  VodDataServer.fromJson(Map<String, dynamic> json) {
    info = json['info'] != null ? Info.fromJson(json['info']) : null;

    movieData = json['movie_data'] != null
        ? MovieData.fromJson(json['movie_data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (info != null) {
      data['info'] = info!.toJson();
    }
    if (movieData != null) {
      data['movie_data'] = movieData!.toJson();
    }
    return data;
  }

  @override
  String toString() {
    return 'VodDataServer{movieData: $movieData, info: $info}';
  }
}

class MovieData {
  int? streamId;
  String? name;
  String? added;
  String? categoryId;
  String? containerExtension;

  MovieData(
      {this.streamId,
      this.name,
      this.added,
      this.categoryId,
      this.containerExtension});

  MovieData.fromJson(Map<String, dynamic> json) {
    streamId = json['stream_id'] as int?;
    name = json['name'] as String?;
    added = json['added'] as String?;
    categoryId = json['category_id'] as String?;
    containerExtension = json['container_extension'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['stream_id'] = streamId;
    data['name'] = name;
    data['added'] = added;
    data['category_id'] = categoryId;
    data['container_extension'] = containerExtension;
    return data;
  }

  @override
  String toString() {
    return 'MovieData{streamId: $streamId, name: $name, added: $added, categoryId: $categoryId, containerExtension: $containerExtension}';
  }
}

class Info {
  int? tmdbId; // Changed from String? to int?
  String? name;
  String? oName;
  String? coverBig;
  String? movieImage;
  String? releasedate;
  String? youtubeTrailer;
  String? director;
  String? cast;
  String? plot;
  String? country;
  String? genre;
  List<String>? backdropPath;
  int? durationSecs; // Should be int
  String? duration;
  double? rating; // Should be double since it's 4.3 in the response
  String? runtime;

  Info(
      {this.tmdbId,
      this.name,
      this.oName,
      this.coverBig,
      this.movieImage,
      this.releasedate,
      this.youtubeTrailer,
      this.director,
      this.cast,
      this.plot,
      this.country,
      this.genre,
      this.backdropPath,
      this.duration,
      this.rating,
      this.runtime});

  Info.fromJson(Map<String, dynamic> json) {
    tmdbId = int.tryParse(json['tmdb_id'].toString());
    name = json['name']?.toString();
    oName = json['o_name']?.toString();
    coverBig = json['cover_big']?.toString();
    movieImage = json['movie_image']?.toString();
    releasedate = json['releasedate']?.toString();
    youtubeTrailer = json['youtube_trailer']?.toString();
    director = json['director']?.toString();
    cast = (json['cast'] ?? json['actors'])?.toString();
    plot = json['plot']?.toString();
    country = json['country']?.toString();
    genre = json['genre']?.toString();
    backdropPath =
        (json['backdrop_path'] as List?)?.map((e) => e.toString()).toList();
    durationSecs = int.tryParse(json['duration_secs'].toString());
    duration = json['duration']?.toString();
    rating = double.tryParse(json['rating'].toString());
    runtime = json['runtime']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tmdb_id'] = tmdbId;
    data['name'] = name;
    data['o_name'] = oName;
    data['cover_big'] = coverBig;
    data['movie_image'] = movieImage;
    data['releasedate'] = releasedate;
    data['youtube_trailer'] = youtubeTrailer;
    data['director'] = director;
    data['cast'] = cast;
    data['plot'] = plot;
    data['country'] = country;
    data['genre'] = genre;
    data['backdrop_path'] = backdropPath;
    data['duration'] = duration;
    data['rating'] = rating;
    data['runtime'] = runtime;
    return data;
  }

  @override
  String toString() {
    return 'Info{tmdbId: $tmdbId, name: $name, oName: $oName, coverBig: $coverBig, movieImage: $movieImage, releasedate: $releasedate, youtubeTrailer: $youtubeTrailer, director: $director, cast: $cast, plot: $plot, country: $country, genre: $genre, backdropPath: $backdropPath, duration: $duration, rating: $rating, runtime: $runtime}';
  }
}
