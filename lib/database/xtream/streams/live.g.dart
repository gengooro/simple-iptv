// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'live.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LiveStreamModelAdapter extends TypeAdapter<LiveStreamModel> {
  @override
  final int typeId = 5;

  @override
  LiveStreamModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LiveStreamModel(
      num: fields[0] as int?,
      name: fields[1] as String?,
      streamType: fields[2] as String?,
      streamId: fields[3] as int?,
      streamIcon: fields[4] as String?,
      epgChannelId: fields[5] as String?,
      added: fields[6] as String?,
      isAdult: fields[7] as int?,
      categoryId: fields[8] as String?,
      tvArchive: fields[9] as int?,
      directSource: fields[10] as String?,
      tvArchiveDuration: fields[11] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, LiveStreamModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.num)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.streamType)
      ..writeByte(3)
      ..write(obj.streamId)
      ..writeByte(4)
      ..write(obj.streamIcon)
      ..writeByte(5)
      ..write(obj.epgChannelId)
      ..writeByte(6)
      ..write(obj.added)
      ..writeByte(7)
      ..write(obj.isAdult)
      ..writeByte(8)
      ..write(obj.categoryId)
      ..writeByte(9)
      ..write(obj.tvArchive)
      ..writeByte(10)
      ..write(obj.directSource)
      ..writeByte(11)
      ..write(obj.tvArchiveDuration);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LiveStreamModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
