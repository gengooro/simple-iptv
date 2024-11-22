// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vod.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VodStreamModelAdapter extends TypeAdapter<VodStreamModel> {
  @override
  final int typeId = 6;

  @override
  VodStreamModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VodStreamModel(
      num: fields[0] as int?,
      name: fields[1] as String?,
      streamId: fields[2] as String?,
      streamIcon: fields[3] as String?,
      rating: fields[4] as String?,
      rating5based: fields[5] as String?,
      tmdb: fields[6] as String?,
      trailer: fields[7] as String?,
      added: fields[8] as String?,
      isAdult: fields[9] as int?,
      categoryId: fields[10] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, VodStreamModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.num)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.streamId)
      ..writeByte(3)
      ..write(obj.streamIcon)
      ..writeByte(4)
      ..write(obj.rating)
      ..writeByte(5)
      ..write(obj.rating5based)
      ..writeByte(6)
      ..write(obj.tmdb)
      ..writeByte(7)
      ..write(obj.trailer)
      ..writeByte(8)
      ..write(obj.added)
      ..writeByte(9)
      ..write(obj.isAdult)
      ..writeByte(10)
      ..write(obj.categoryId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VodStreamModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
