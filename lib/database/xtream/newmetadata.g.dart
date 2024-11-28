// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'newmetadata.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NewMetaDataAdapter extends TypeAdapter<NewMetaData> {
  @override
  final int typeId = 8;

  @override
  NewMetaData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NewMetaData(
      tvgId: fields[0] as String,
      tvgName: fields[1] as String,
      tvgLogo: fields[2] as String,
      groupTitle: fields[3] as String,
      streamUrl: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, NewMetaData obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.tvgId)
      ..writeByte(1)
      ..write(obj.tvgName)
      ..writeByte(2)
      ..write(obj.tvgLogo)
      ..writeByte(3)
      ..write(obj.groupTitle)
      ..writeByte(4)
      ..write(obj.streamUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NewMetaDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
