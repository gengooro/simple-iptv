class TmdbVod {
  bool? adult;
  String? backdropPath;
  List<Genres>? genres;
  String? imdbId;
  String? originalTitle;
  String? overview;
  double? popularity;
  String? releaseDate;
  int? runtime;
  String? status;
  String? tagline;
  String? title;
  double? voteAverage;

  TmdbVod(
      {this.adult,
      this.backdropPath,
      this.genres,
      this.imdbId,
      this.originalTitle,
      this.overview,
      this.popularity,
      this.releaseDate,
      this.runtime,
      this.status,
      this.tagline,
      this.title,
      this.voteAverage});

  TmdbVod.fromJson(Map<String, dynamic> json) {
    adult = json['adult'];
    backdropPath = json['backdrop_path'];
    if (json['genres'] != null) {
      genres = <Genres>[];
      json['genres'].forEach((v) {
        genres!.add(Genres.fromJson(v));
      });
    }
    imdbId = json['imdb_id'];
    originalTitle = json['original_title'];
    overview = json['overview'];
    popularity = json['popularity'];
    releaseDate = json['release_date'];
    runtime = json['runtime'];
    status = json['status'];
    tagline = json['tagline'];
    title = json['title'];
    voteAverage = json['vote_average'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['adult'] = adult;
    data['backdrop_path'] = backdropPath;
    if (genres != null) {
      data['genres'] = genres!.map((v) => v.toJson()).toList();
    }
    data['imdb_id'] = imdbId;
    data['original_title'] = originalTitle;
    data['overview'] = overview;
    data['popularity'] = popularity;
    data['release_date'] = releaseDate;
    data['runtime'] = runtime;
    data['status'] = status;
    data['tagline'] = tagline;
    data['title'] = title;
    data['vote_average'] = voteAverage;
    return data;
  }

  @override
  String toString() {
    return 'TmdbVod{adult: $adult, backdropPath: $backdropPath, genres: $genres, imdbId: $imdbId, originalTitle: $originalTitle, overview: $overview, popularity: $popularity, releaseDate: $releaseDate, runtime: $runtime, status: $status, tagline: $tagline, title: $title, voteAverage: $voteAverage}';
  }
}

class Genres {
  int? id;
  String? name;

  Genres({this.id, this.name});

  Genres.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
