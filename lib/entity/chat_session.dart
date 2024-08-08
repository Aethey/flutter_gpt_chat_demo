import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'chat_message.dart';

part 'chat_session.freezed.dart';
part 'chat_session.g.dart';

@freezed
class ChatSession with _$ChatSession {
  @HiveType(typeId: 1, adapterName: 'ChatSessionAdapter')
  const factory ChatSession({
    @HiveField(0) required String id,
    @HiveField(1) required List<ChatMessage> messages,
    @HiveField(2) DateTime? updateTimestamp,
    @HiveField(3) DateTime? createTimestamp,
    @HiveField(4) String? title,
  }) = _ChatSession;

  factory ChatSession.fromJson(Map<String, dynamic> json) =>
      _$ChatSessionFromJson(json);
}
