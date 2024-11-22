import 'package:hive/hive.dart';

part 'vod.g.dart';

@HiveType(typeId: 6)
class VodStreamModel extends HiveObject {
  @HiveField(0)
  int? num;

  @HiveField(1)
  String? name;

  @HiveField(2)
  String? streamId;

  @HiveField(3)
  String? streamIcon;

  @HiveField(4)
  String? rating;

  @HiveField(5)
  String? rating5based;

  @HiveField(6)
  String? tmdb;

  @HiveField(7)
  String? trailer;

  @HiveField(8)
  String? added;

  @HiveField(9)
  int? isAdult;

  @HiveField(10)
  String? categoryId;

  VodStreamModel({
    this.num,
    this.name,
    this.streamId,
    this.streamIcon,
    this.rating,
    this.rating5based,
    this.tmdb,
    this.trailer,
    this.added,
    this.isAdult,
    this.categoryId,
  });

  factory VodStreamModel.fromJson(Map<String, dynamic> json) {
    return VodStreamModel(
      num: json['num'] is String ? int.tryParse(json['num']) : json['num'],
      name: json['name'] is int ? json['name'].toString() : json['name'],
      streamId: json['stream_id'] is int
          ? json['stream_id'].toString()
          : json['stream_id'],
      streamIcon: json['stream_icon'] is int
          ? json['stream_icon'].toString()
          : json['stream_icon'],
      rating: json['rating'] is double || json['rating'] is int
          ? json['rating'].toString()
          : json['rating'],
      rating5based:
          json['rating_5based'] is double || json['rating_5based'] is int
              ? json["rating_5based"].toString()
              : json["rating_5based"],
      tmdb: json['tmdb'] is int ? json['tmdb'].toString() : json['tmdb'],
      trailer:
          json['trailer'] is int ? json['trailer'].toString() : json['trailer'],
      added: json['added'] is int ? json['added'].toString() : json['added'],
      isAdult: json['is_adult'] is String
          ? int.tryParse(json['is_adult'])
          : json['is_adult'],
      categoryId: json['category_id'] is int
          ? json['category_id'].toString()
          : json['category_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['num'] = num;
    data['name'] = name;
    data['stream_id'] = streamId;
    data['stream_icon'] = streamIcon;
    data['rating'] = rating;
    data['rating_5based'] = rating5based;
    data['tmdb'] = tmdb;
    data['trailer'] = trailer;
    data['added'] = added;
    data['is_adult'] = isAdult;
    data['category_id'] = categoryId;
    return data;
  }

  @override
  String toString() {
    return 'Vod{  }';
  }
}
