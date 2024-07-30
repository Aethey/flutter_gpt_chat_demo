import 'package:json_annotation/json_annotation.dart';

part 'message_entity.g.dart';

@JsonSerializable()
class MessageEntity {
  String id;
  String conversationId;
  String question;
  String answer;
  DateTime createdAt;
  Stream<String>? stream;

  MessageEntity({
    String? id,
    this.conversationId = "",
    this.question = "",
    this.answer = "",
    Stream<String>? stream,
    DateTime? createdAt,
  })  : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        createdAt = createdAt ?? DateTime.now();

  factory MessageEntity.fromJson(Map<String, dynamic> json) =>
      _$MessageEntityFromJson(json);
  Map<String, dynamic> toJson() => _$MessageEntityToJson(this);
}
