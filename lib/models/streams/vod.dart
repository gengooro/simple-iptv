import 'package:iptv/models/tmdb_vod.dart';

class VodData {
  TmdbVod? tmdbVod;
  MovieData? movieData;

  VodData({this.tmdbVod, this.movieData});
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
    streamId = json['stream_id'];
    name = json['name'];
    added = json['added'];
    categoryId = json['category_id'];
    containerExtension = json['container_extension'];
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
