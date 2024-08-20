import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:ry_chat/data/database/hive_db.dart';
import 'package:ry_chat/entity/chat_session.dart';
import 'package:ry_chat/state/session_list_state.dart';

import 'session_list_notifier_test.mocks.dart';

void main() {
  late MockHiveDB mockHiveDB;
  late SessionListNotifier notifier;

  setUp(() {
    mockHiveDB = MockHiveDB();
    notifier = SessionListNotifier();
  });
}
