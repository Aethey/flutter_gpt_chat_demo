// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChatMessageAdapter extends TypeAdapter<_$ChatMessageImpl> {
  @override
  final int typeId = 0;

  @override
  _$ChatMessageImpl read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return _$ChatMessageImpl(
      id: fields[0] as String,
      content: fields[1] as String,
      isFromAI: fields[2] as bool,
      temporary: fields[3] as bool,
      timestamp: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, _$ChatMessageImpl obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.content)
      ..writeByte(2)
      ..write(obj.isFromAI)
      ..writeByte(3)
      ..write(obj.temporary)
      ..writeByte(4)
      ..write(obj.timestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatMessageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChatMessageImpl _$$ChatMessageImplFromJson(Map<String, dynamic> json) =>
    _$ChatMessageImpl(
      id: json['id'] as String,
      content: json['content'] as String,
      isFromAI: json['isFromAI'] as bool,
      temporary: json['temporary'] as bool,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$$ChatMessageImplToJson(_$ChatMessageImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'isFromAI': instance.isFromAI,
      'temporary': instance.temporary,
      'timestamp': instance.timestamp.toIso8601String(),
    };
