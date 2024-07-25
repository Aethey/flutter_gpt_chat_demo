import 'package:hive_flutter/hive_flutter.dart';

import '../../config_dev.dart';
import '../../entity/conversion.dart';
import '../../entity/message.dart';

class HiveDB {
  static const String _boxName = AppConfig.hiveBaseBoxName;

  static Future<void> initHive() async {
    // final appDocumentDir =
    //     await path_provider.getApplicationDocumentsDirectory();
    // Hive.init(appDocumentDir.path);
    await Hive.initFlutter();
    Hive.registerAdapter(MessageAdapter());
    Hive.registerAdapter(ConversionAdapter());
    await Hive.openBox(_boxName);
  }

  static Box get _box => Hive.box(_boxName);

  static Future<void> putData(String key, dynamic value) async {
    await _box.put(key, value);
  }

  static dynamic getData(String key) {
    return _box.get(key);
  }

  static Future<void> removeData(String key) async {
    await _box.delete(key);
  }
}
