class TmdbSeries {
  bool? adult;
  String? firstAirDate;
  String? name;
  int? numberOfEpisodes;
  int? numberOfSeasons;
  String? originalName;
  double? popularity;
  List<ProductionCompanies>? productionCompanies;
  List<Seasons>? seasons;
  String? type;
  double? voteAverage;
  int? voteCount;

  TmdbSeries(
      {this.adult,
      this.firstAirDate,
      this.name,
      this.numberOfEpisodes,
      this.numberOfSeasons,
      this.originalName,
      this.popularity,
      this.productionCompanies,
      this.seasons,
      this.type,
      this.voteAverage,
      this.voteCount});

  TmdbSeries.fromJson(Map<String, dynamic> json) {
    adult = json['adult'];
    firstAirDate = json['first_air_date'];
    name = json['name'];
    numberOfEpisodes = json['number_of_episodes'];
    numberOfSeasons = json['number_of_seasons'];
    originalName = json['original_name'];
    popularity = json['popularity'];
    if (json['production_companies'] != null) {
      productionCompanies = <ProductionCompanies>[];
      json['production_companies'].forEach((v) {
        productionCompanies!.add(ProductionCompanies.fromJson(v));
      });
    }
    if (json['seasons'] != null) {
      seasons = <Seasons>[];
      json['seasons'].forEach((v) {
        seasons!.add(Seasons.fromJson(v));
      });
    }
    type = json['type'];
    voteAverage = json['vote_average'];
    voteCount = json['vote_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['adult'] = adult;
    data['first_air_date'] = firstAirDate;
    data['name'] = name;
    data['number_of_episodes'] = numberOfEpisodes;
    data['number_of_seasons'] = numberOfSeasons;
    data['original_name'] = originalName;
    data['popularity'] = popularity;
    if (productionCompanies != null) {
      data['production_companies'] =
          productionCompanies!.map((v) => v.toJson()).toList();
    }
    if (seasons != null) {
      data['seasons'] = seasons!.map((v) => v.toJson()).toList();
    }
    data['type'] = type;
    data['vote_average'] = voteAverage;
    data['vote_count'] = voteCount;
    return data;
  }

  @override
  String toString() {
    return 'TmdbSeries{adult: $adult, firstAirDate: $firstAirDate, name: $name, numberOfEpisodes: $numberOfEpisodes, numberOfSeasons: $numberOfSeasons, originalName: $originalName, popularity: $popularity, productionCompanies: $productionCompanies, seasons: $seasons, type: $type, voteAverage: $voteAverage, voteCount: $voteCount}';
  }
}

class ProductionCompanies {
  int? id;
  String? logoPath;
  String? name;
  String? originCountry;

  ProductionCompanies({this.id, this.logoPath, this.name, this.originCountry});

  ProductionCompanies.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    logoPath = json['logo_path'];
    name = json['name'];
    originCountry = json['origin_country'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['logo_path'] = logoPath;
    data['name'] = name;
    data['origin_country'] = originCountry;
    return data;
  }
}

class Seasons {
  String? airDate;
  int? episodeCount;
  int? id;
  String? name;
  String? overview;
  String? posterPath;
  int? seasonNumber;
  double? voteAverage;

  Seasons(
      {this.airDate,
      this.episodeCount,
      this.id,
      this.name,
      this.overview,
      this.posterPath,
      this.seasonNumber,
      this.voteAverage});

  Seasons.fromJson(Map<String, dynamic> json) {
    airDate = json['air_date'];
    episodeCount = json['episode_count'];
    id = json['id'];
    name = json['name'];
    overview = json['overview'];
    posterPath = json['poster_path'];
    seasonNumber = json['season_number'];
    voteAverage = json['vote_average'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['air_date'] = airDate;
    data['episode_count'] = episodeCount;
    data['id'] = id;
    data['name'] = name;
    data['overview'] = overview;
    data['poster_path'] = posterPath;
    data['season_number'] = seasonNumber;
    data['vote_average'] = voteAverage;
    return data;
  }
}
