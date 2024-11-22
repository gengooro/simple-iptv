class StreamModel {
  int? num;
  String? name;
  String? streamType;
  int? streamId;
  String? streamIcon;
  String? epgChannelId;
  String? added;
  int? isAdult;
  String? categoryId;
  List<int>? categoryIds;
  int? tvArchive;
  int? tvArchiveDuration;

  StreamModel(
      {this.num,
      this.name,
      this.streamType,
      this.streamId,
      this.streamIcon,
      this.epgChannelId,
      this.added,
      this.isAdult,
      this.categoryId,
      this.categoryIds,
      this.tvArchive,
      this.tvArchiveDuration});

  StreamModel.fromJson(Map<String, dynamic> json) {
    num = json['num'];
    name = json['name'];
    streamType = json['stream_type'];
    streamId = json['stream_id'];
    streamIcon = json['stream_icon'];
    epgChannelId = json['epg_channel_id'];
    added = json['added'];
    isAdult = json['is_adult'];
    categoryId = json['category_id'];
    categoryIds = json['category_ids'].cast<int>();
    tvArchive = json['tv_archive'];
    tvArchiveDuration = json['tv_archive_duration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['num'] = num;
    data['name'] = name;
    data['stream_type'] = streamType;
    data['stream_id'] = streamId;
    data['stream_icon'] = streamIcon;
    data['epg_channel_id'] = epgChannelId;
    data['added'] = added;
    data['is_adult'] = isAdult;
    data['category_id'] = categoryId;
    data['category_ids'] = categoryIds;
    data['tv_archive'] = tvArchive;
    data['tv_archive_duration'] = tvArchiveDuration;
    return data;
  }

  @override
  String toString() {
    return 'Stream{num: $num, name: $name, streamType: $streamType, streamId: $streamId, streamIcon: $streamIcon, epgChannelId: $epgChannelId, added: $added, isAdult: $isAdult, categoryId: $categoryId, categoryIds: $categoryIds, tvArchive: $tvArchive, tvArchiveDuration: $tvArchiveDuration}';
  }
}
