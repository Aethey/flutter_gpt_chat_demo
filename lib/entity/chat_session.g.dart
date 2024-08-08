// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_session.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChatSessionAdapter extends TypeAdapter<_$ChatSessionImpl> {
  @override
  final int typeId = 1;

  @override
  _$ChatSessionImpl read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return _$ChatSessionImpl(
      id: fields[0] as String,
      messages: (fields[1] as List).cast<ChatMessage>(),
      updateTimestamp: fields[2] as DateTime?,
      createTimestamp: fields[3] as DateTime?,
      title: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, _$ChatSessionImpl obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.updateTimestamp)
      ..writeByte(3)
      ..write(obj.createTimestamp)
      ..writeByte(4)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.messages);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatSessionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChatSessionImpl _$$ChatSessionImplFromJson(Map<String, dynamic> json) =>
    _$ChatSessionImpl(
      id: json['id'] as String,
      messages: (json['messages'] as List<dynamic>)
          .map((e) => ChatMessage.fromJson(e as Map<String, dynamic>))
          .toList(),
      updateTimestamp: json['updateTimestamp'] == null
          ? null
          : DateTime.parse(json['updateTimestamp'] as String),
      createTimestamp: json['createTimestamp'] == null
          ? null
          : DateTime.parse(json['createTimestamp'] as String),
      title: json['title'] as String?,
    );

Map<String, dynamic> _$$ChatSessionImplToJson(_$ChatSessionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'messages': instance.messages,
      'updateTimestamp': instance.updateTimestamp?.toIso8601String(),
      'createTimestamp': instance.createTimestamp?.toIso8601String(),
      'title': instance.title,
    };
