// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'apidata.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ApiDataAdapter extends TypeAdapter<ApiData> {
  @override
  final int typeId = 0;

  @override
  ApiData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ApiData(
      userId: fields[0] as int,
      id: fields[1] as int,
      body: fields[3] as String,
      title: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ApiData obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.body);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ApiDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
