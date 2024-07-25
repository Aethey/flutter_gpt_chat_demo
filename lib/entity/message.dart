import 'package:hive/hive.dart';

part 'message.g.dart'; // Hive生成的适配器文件

@HiveType(typeId: 0) // 注册Hive类型ID
class Message extends HiveObject {
  @HiveField(0)
  final String documentID;

  @HiveField(1)
  final String answer;

  @HiveField(2)
  final String conversationId;

  @HiveField(3)
  final DateTime createdAt;

  @HiveField(4)
  final String id;

  @HiveField(5)
  final String question;

  Message(
      {required this.documentID,
      required this.answer,
      required this.conversationId,
      required this.createdAt,
      required this.id,
      required this.question});
}
