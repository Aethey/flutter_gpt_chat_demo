import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'chat_message.freezed.dart';
part 'chat_message.g.dart';

@freezed
class ChatMessage with _$ChatMessage {
  @HiveType(typeId: 0, adapterName: 'ChatMessageAdapter')
  const factory ChatMessage({
    @HiveField(0) required String id,
    @HiveField(1) required String content,
    @HiveField(2) required bool isFromAI,
    @HiveField(3) required bool temporary,
    @HiveField(4) required DateTime timestamp,
  }) = _ChatMessage;

  factory ChatMessage.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageFromJson(json);
}
