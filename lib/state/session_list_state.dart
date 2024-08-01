import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:ry_chat/data/database/hive_db.dart';

import '../entity/chat_session.dart';

final sessionListProvider =
    StateNotifierProvider<SessionListNotifier, List<ChatSession>>((ref) {
  return SessionListNotifier();
});

class SessionListNotifier extends StateNotifier<List<ChatSession>> {
  SessionListNotifier() : super([]);

  void addSession(ChatSession chatSession) {
    state = [
      ...state,
      chatSession,
    ];
  }

  Future<void> loadSessions() async {
    List<ChatSession> sessions = await HiveDB.readAllChatSessions();
    state = sessions; // Update state with the loaded sessions
  }

  void clearSessions() async {
    await HiveDB.clearSessions();
    state = []; // Update state to empty list.
  }
}