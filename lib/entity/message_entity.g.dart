// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageEntity _$MessageEntityFromJson(Map<String, dynamic> json) =>
    MessageEntity(
      id: json['id'] as String?,
      conversationId: json['conversationId'] as String? ?? "",
      question: json['question'] as String? ?? "",
      answer: json['answer'] as String? ?? "",
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$MessageEntityToJson(MessageEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'conversationId': instance.conversationId,
      'question': instance.question,
      'answer': instance.answer,
      'createdAt': instance.createdAt.toIso8601String(),
    };
