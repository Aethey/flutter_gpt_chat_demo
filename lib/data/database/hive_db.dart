import 'package:hive_flutter/hive_flutter.dart';
import 'package:ry_chat/entity/chat_message.dart';
import 'package:ry_chat/entity/chat_session.dart';
import 'dart:collection';
import '../../config_dev.dart';

class HiveDB {
  static const String _boxName = AppConfig.hiveBaseBoxName;

  static Future<void> initHive() async {
    // final appDocumentDir =
    //     await path_provider.getApplicationDocumentsDirectory();
    // Hive.init(appDocumentDir.path);
    await Hive.initFlutter();
    Hive.registerAdapter(ChatMessageAdapter());
    Hive.registerAdapter(ChatSessionAdapter());
    await Hive.openBox(_boxName);
  }

  static Box get _box => Hive.box(AppConfig.hiveBaseBoxName);

  static Future<void> putData(String key, dynamic value) async {
    await _box.put(key, value);
  }

  static dynamic getData(String key) {
    return _box.get(key);
  }

  static Future<void> removeData(String key) async {
    await _box.delete(key);
  }

  static Future<void> writeChatSession(ChatSession session) async {
    await _box.put(session.id, session);
  }

  static Future<ChatSession?> readChatSessionById(String id) async {
    return _box.get(id) as ChatSession?;
  }

  static Future<void> setCurrentSession(String sessionID) async {
    await _box.put("currentSessionID", sessionID);
  }

  static Future<void> getCurrentSession() async {
    return _box.get("currentSessionID") ?? "";
  }

  static Future<List<ChatSession>> readAllChatSessions() async {
    List<ChatSession> sessions = [];
    DateTime defaultTime = DateTime.now().subtract(Duration(days: 1));
    for (var key in _box.keys) {
      var session = _box.get(key) as ChatSession?;
      if (session != null) {
        session = session.updateTimestamp != null
            ? session
            : session.copyWith(updateTimestamp: defaultTime);
        sessions.add(session);
      }
    }
    sessions.sort((a, b) => b.updateTimestamp!.compareTo(a.updateTimestamp!));
    return sessions;
  }

  static Future<void> addMessageToSession(
      String sessionId, ChatMessage newMessage) async {
    var session = _box.get(sessionId) as ChatSession?;

    if (session != null) {
      // Create a new list of messages with the new message added
      var updatedMessages = List<ChatMessage>.from(session.messages)
        ..add(newMessage);

      // Create a new session object with the updated list of messages
      var updatedSession = session.copyWith(messages: updatedMessages);

      // Put the updated session back into the box
      await _box.put(sessionId, updatedSession);
    } else {
      var newSession = ChatSession(
        id: sessionId,
        messages: [newMessage],
        createTimestamp: DateTime.now(),
        updateTimestamp:
            DateTime.now(), // Start with the new message as the first message
      );
      await _box.put(sessionId, newSession);
      print('New session created with ID $sessionId');
    }
  }

  static Future<void> clearSessions() async {
    await _box.clear(); // This clears all entries in the box.
  }
}
