import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:ry_chat/data/database/hive_db.dart';

import '../app_utils.dart';
import '../entity/chat_session.dart';

// final sessionListProvider =
//     StateNotifierProvider<SessionListNotifier, List<ChatSession>>((ref) {
//   return SessionListNotifier();
// });

final sessionListProvider =
    StateNotifierProvider.autoDispose<SessionListNotifier, List<ChatSession>>(
        (ref) {
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

  void deleteSession(String sessionId) async {
    await HiveDB.deleteSession(sessionId); // 删除数据库中的会话
    state = state.where((session) => session.id != sessionId).toList(); //
  }

  Future<void> loadSessions() async {
    List<ChatSession> sessions = await HiveDB.readAllChatSessions();
    state = sessions; // Update state with the loaded sessions
  }

  Future<void> filterSessionsByDateLabel(String dateLabel) async {
    List<ChatSession> sessions = await HiveDB.readAllChatSessions();
    if (dateLabel == "all") {
      state = sessions;
    } else {
      final dateRange = AppUtils.instance.getDateRangeForLabel(dateLabel);
      final startDate = dateRange['startDate']!;
      final endDate = dateRange['endDate']!;

      final filteredSessions = sessions.where((session) {
        // Adjust this based on how `date` is stored in `ChatSession`
        final sessionDate = session.updateTimestamp;
        return sessionDate!
                .isAfter(startDate.subtract(const Duration(days: 1))) &&
            sessionDate.isBefore(endDate.add(const Duration(days: 1)));
      }).toList();

      state = filteredSessions;
    }
  }

  void clearSessions() async {
    await HiveDB.clearSessions();
    state = []; // Update state to empty list.
  }
}
