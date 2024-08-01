import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';
import 'package:ry_chat/data/database/hive_db.dart';
import 'package:uuid/uuid.dart';
import '../entity/chat_message.dart';
import '../entity/chat_session.dart';

final chatProvider = StateNotifierProvider<ChatNotifier, ChatSession>((ref) {
  return ChatNotifier(ChatSession(
      // recent message?
      id: const Uuid().v1(),
      messages: []));
});

class ChatNotifier extends StateNotifier<ChatSession> {
  ChatNotifier(super.state);

  void addMessage(ChatMessage message) {
    state = state.copyWith(messages: [...state.messages, message]);
  }

  ChatMessage? findMessageById(String id) {
    return state.messages.firstWhereOrNull((message) => message.id == id);
  }

  void setCurrentSession(String? id) async {
    if (id == null) {
    } else {
      ChatSession? currentChatSession = await HiveDB.readChatSessionById(id);
      if (currentChatSession != null) {
        state = currentChatSession;
      }
    }
  }

  void updateMessage(String id, String content, {bool temporary = false}) {
    final updatedMessages = state.messages.map((message) {
      if (message.id == id &&
          (message.content != content || message.temporary != temporary)) {
        // Only update if there's a change
        return message.copyWith(content: content, temporary: temporary);
      }
      return message;
    }).toList();

    if (updatedMessages != state.messages) {
      state = state.copyWith(messages: updatedMessages);
    }
  }

  List<ChatMessage> getRecentMessages(DateTime fromTime) {
    return state.messages
        .where((message) => message.timestamp.isAfter(fromTime))
        .toList();
  }

  void addMessageStream(String id, Stream<String> stream) async {
    String tmp = "";
    await for (final content in stream) {
      // Check if the message already exists
      var existingMessage = findMessageById(id);
      if (existingMessage != null) {
        // Update existing message
        updateMessage(id, content);
      } else {
        // Add new message if not found (for initial case)
        addMessage(ChatMessage(
          id: id,
          content: content,
          isFromAI: true,
          temporary: true,
          timestamp: DateTime.now(),
        ));
      }
    }
  }
}
