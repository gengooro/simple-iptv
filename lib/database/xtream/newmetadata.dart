import 'package:hive/hive.dart';

part 'newmetadata.g.dart'; // Generated file for Hive type adapters

@HiveType(typeId: 8)
class NewMetaData {
  @HiveField(0)
  final String tvgId;

  @HiveField(1)
  final String tvgName;

  @HiveField(2)
  final String tvgLogo;

  @HiveField(3)
  final String groupTitle;

  @HiveField(4)
  final String streamUrl;

  NewMetaData({
    required this.tvgId,
    required this.tvgName,
    required this.tvgLogo,
    required this.groupTitle,
    required this.streamUrl,
  });

  factory NewMetaData.fromJson(Map<String, dynamic> json) {
    return NewMetaData(
      tvgId: json['tvg_id'] as String,
      tvgName: json['tvg_name'] as String,
      tvgLogo: json['tvg_logo'] as String,
      groupTitle: json['group_title'] as String,
      streamUrl: json['stream_url'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tvg_id': tvgId,
      'tvg_name': tvgName,
      'tvg_logo': tvgLogo,
      'group_title': groupTitle,
      'stream_url': streamUrl,
    };
  }

  @override
  String toString() {
    return 'NewMetaData{tvgId: $tvgId, tvgName: $tvgName, tvgLogo: $tvgLogo, groupTitle: $groupTitle, streamUrl: $streamUrl}';
  }
}
