// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cached_image.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CachedImageAdapter extends TypeAdapter<CachedImage> {
  @override
  final int typeId = 0;

  @override
  CachedImage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CachedImage(
      key: fields[0] as String,
      bytes: (fields[1] as List).cast<int>(),
    );
  }

  @override
  void write(BinaryWriter writer, CachedImage obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.key)
      ..writeByte(1)
      ..write(obj.bytes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CachedImageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
