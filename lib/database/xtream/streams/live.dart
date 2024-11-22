import 'package:hive_flutter/hive_flutter.dart';

part 'live.g.dart';

@HiveType(typeId: 5)
class LiveStreamModel extends HiveObject {
  @HiveField(0)
  int? num;

  @HiveField(1)
  String? name;

  @HiveField(2)
  String? streamType;

  @HiveField(3)
  int? streamId;

  @HiveField(4)
  String? streamIcon;

  @HiveField(5)
  String? epgChannelId;

  @HiveField(6)
  String? added;

  @HiveField(7)
  int? isAdult;

  @HiveField(8)
  String? categoryId;

  @HiveField(9)
  int? tvArchive;

  @HiveField(10)
  String? directSource;

  @HiveField(11)
  int? tvArchiveDuration;

  LiveStreamModel(
      {this.num,
      this.name,
      this.streamType,
      this.streamId,
      this.streamIcon,
      this.epgChannelId,
      this.added,
      this.isAdult,
      this.categoryId,
      this.tvArchive,
      this.directSource,
      this.tvArchiveDuration});

  factory LiveStreamModel.fromJson(Map<String, dynamic> json) {
    return LiveStreamModel(
      num: json['num'] is String ? int.tryParse(json['num']) : json['num'],
      streamId: json['stream_id'] is String
          ? int.tryParse(json['stream_id'])
          : json['stream_id'],
      name: json['name'],
      streamType: json['stream_type'],
      streamIcon: json['stream_icon'],
      epgChannelId: json['epg_channel_id'],
      added:
          json['added'], // You can leave it as String, since it's a timestamp
      isAdult: json['is_adult'] is String
          ? int.tryParse(json['is_adult'])
          : json['is_adult'],
      categoryId: json['category_id'],
      tvArchive: json['tv_archive'] is String
          ? int.tryParse(json['tv_archive'])
          : json['tv_archive'],
      directSource: json['direct_source'],
      tvArchiveDuration: json['tv_archive_duration'] is String
          ? int.tryParse(json['tv_archive_duration'])
          : json['tv_archive_duration'],
    );
  }

  // toJson method to convert the model back into a Map<String, dynamic>
  Map<String, dynamic> toJson() {
    return {
      'stream_id': streamId,
      'name': name,
      'stream_type': streamType,
      'stream_icon': streamIcon,
      'epg_channel_id': epgChannelId,
      'added': added,
      'is_adult': isAdult,
      'category_id': categoryId,
      'tv_archive': tvArchive,
      'direct_source': directSource,
      'tv_archive_duration': tvArchiveDuration,
    };
  }

  @override
  String toString() {
    return 'LiveStreamModel{num: $num, name: $name, epgChannelId: $epgChannelId, added: $added, isAdult: $isAdult, categoryId: $categoryId, tvArchive: $tvArchive, directSource: $directSource, tvArchiveDuration: $tvArchiveDuration}';
  }
}
