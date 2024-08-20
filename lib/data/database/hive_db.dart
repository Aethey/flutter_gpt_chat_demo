import 'package:hive_flutter/hive_flutter.dart';
import 'package:ry_chat/entity/chat_message.dart';
import 'package:ry_chat/entity/chat_session.dart';
import '../../config_dev.dart';

class HiveDB {
  // Private constructor
  HiveDB._internal();

  // Singleton instance
  static final HiveDB _instance = HiveDB._internal();

  // Factory constructor to return the singleton instance
  factory HiveDB() {
    return _instance;
  }

  static const String _boxName = AppConfig.hiveBaseBoxName;

  // Initialize Hive
  Future<void> initHive() async {
    await Hive.initFlutter();
    Hive.registerAdapter(ChatMessageAdapter());
    Hive.registerAdapter(ChatSessionAdapter());
    await Hive.openBox(_boxName);
  }

  // Get the Box object
  Box get _box => Hive.box(_boxName);

  // Store data
  Future<void> putData(String key, dynamic value) async {
    await _box.put(key, value);
  }

  // Retrieve data
  dynamic getData(String key) {
    return _box.get(key);
  }

  // Remove data
  Future<void> removeData(String key) async {
    await _box.delete(key);
  }

  // Write a chat session to Hive
  Future<void> writeChatSession(ChatSession session) async {
    await _box.put(session.id, session);
  }

  // Read a chat session by ID
  Future<ChatSession?> readChatSessionById(String id) async {
    return _box.get(id) as ChatSession?;
  }

  // Set whether the showcase tutorial needs to be displayed
  Future<void> setNeedShowcase(bool needShowcase) async {
    await _box.put("needShowcase", needShowcase);
  }

  // Get whether the showcase tutorial needs to be displayed
  Future<bool> getNeedShowcase() async {
    return _box.get("needShowcase") ?? true;
  }

  // Set the current session ID
  Future<void> setCurrentSession(String sessionID) async {
    await _box.put("currentSessionID", sessionID);
  }

  // Get the current session ID
  Future<String> getCurrentSession() async {
    return _box.get("currentSessionID") ?? "";
  }

  // Read all chat sessions from Hive
  Future<List<ChatSession>> readAllChatSessions() async {
    List<ChatSession> sessions = [];
    for (var key in _box.keys) {
      dynamic session = _box.get(key);
      if (session is ChatSession) {
        session = session.updateTimestamp != null
            ? session
            : session.copyWith(updateTimestamp: DateTime.now());
        sessions.add(session);
      }
    }
    sessions.sort((a, b) => b.updateTimestamp!.compareTo(a.updateTimestamp!));
    return sessions;
  }

  // Add a message to a specific session
  Future<void> addMessageToSession(
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
      // Create a new session if it does not exist
      var newSession = ChatSession(
        id: sessionId,
        messages: [newMessage],
        createTimestamp: DateTime.now(),
        updateTimestamp: DateTime.now(),
      );
      await _box.put(sessionId, newSession);
    }
  }

  // Delete a session by ID
  Future<void> deleteSession(String sessionId) async {
    await _box.delete(sessionId); // Delete session by ID
  }

  // Clear all sessions from the box
  Future<void> clearSessions() async {
    await _box.clear(); // Clear all entries in the box
  }
}
