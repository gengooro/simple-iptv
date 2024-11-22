// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'series.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SeriesStreamModelAdapter extends TypeAdapter<SeriesStreamModel> {
  @override
  final int typeId = 7;

  @override
  SeriesStreamModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SeriesStreamModel(
      num: fields[0] as int?,
      name: fields[1] as String?,
      seriesId: fields[2] as String?,
      cover: fields[3] as String?,
      plot: fields[4] as String?,
      cast: fields[5] as String?,
      director: fields[6] as String?,
      genre: fields[7] as String?,
      releaseDate: fields[8] as String?,
      lastModified: fields[9] as String?,
      rating: fields[10] as String?,
      rating5based: fields[11] as String?,
      backdropPath: (fields[12] as List?)?.cast<String>(),
      youtubeTrailer: fields[13] as String?,
      tmdb: fields[14] as String?,
      episodeRunTime: fields[15] as String?,
      categoryId: fields[16] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, SeriesStreamModel obj) {
    writer
      ..writeByte(17)
      ..writeByte(0)
      ..write(obj.num)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.seriesId)
      ..writeByte(3)
      ..write(obj.cover)
      ..writeByte(4)
      ..write(obj.plot)
      ..writeByte(5)
      ..write(obj.cast)
      ..writeByte(6)
      ..write(obj.director)
      ..writeByte(7)
      ..write(obj.genre)
      ..writeByte(8)
      ..write(obj.releaseDate)
      ..writeByte(9)
      ..write(obj.lastModified)
      ..writeByte(10)
      ..write(obj.rating)
      ..writeByte(11)
      ..write(obj.rating5based)
      ..writeByte(12)
      ..write(obj.backdropPath)
      ..writeByte(13)
      ..write(obj.youtubeTrailer)
      ..writeByte(14)
      ..write(obj.tmdb)
      ..writeByte(15)
      ..write(obj.episodeRunTime)
      ..writeByte(16)
      ..write(obj.categoryId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SeriesStreamModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
