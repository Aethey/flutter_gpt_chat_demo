import 'package:hive/hive.dart';

part 'conversion.g.dart'; // Hive生成的适配器文件

@HiveType(typeId: 1) // 注册Hive类型ID
class Conversion extends HiveObject {
  @HiveField(0)
  final String documentID;

  @HiveField(1)
  final DateTime createdAt;

  @HiveField(2)
  final String id;

  @HiveField(3)
  final String title;

  Conversion(
      {required this.documentID,
      required this.createdAt,
      required this.id,
      required this.title});
}
