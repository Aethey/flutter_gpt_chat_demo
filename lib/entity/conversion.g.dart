// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversion.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ConversionAdapter extends TypeAdapter<Conversion> {
  @override
  final int typeId = 1;

  @override
  Conversion read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Conversion(
      documentID: fields[0] as String,
      createdAt: fields[1] as DateTime,
      id: fields[2] as String,
      title: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Conversion obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.documentID)
      ..writeByte(1)
      ..write(obj.createdAt)
      ..writeByte(2)
      ..write(obj.id)
      ..writeByte(3)
      ..write(obj.title);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConversionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
