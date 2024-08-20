import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';
import 'package:ry_chat/data/database/hive_db.dart';
import 'package:uuid/uuid.dart';
import '../data/repository/chat_repository.dart';
import '../entity/chat_message.dart';
import '../entity/chat_session.dart';

final chatProvider = StateNotifierProvider<ChatNotifier, ChatSession>((ref) {
  return ChatNotifier(ChatSession(
      // recent message?
      id: const Uuid().v1(),
      createTimestamp: DateTime.now(),
      updateTimestamp: DateTime.now(), //
      messages: []));
});

class ChatNotifier extends StateNotifier<ChatSession> {
  ChatNotifier(super.state);

  void addMessage(
      {required String messageText,
      String? sessionID,
      String? messageID,
      bool? isFromAI,
      bool? temporary}) {
    var tmpMsg = ChatMessage(
        id: messageID ?? const Uuid().v1(),
        content: messageText,
        isFromAI: isFromAI ?? false,
        temporary: temporary ?? false,
        timestamp: DateTime.now());

    state = state.copyWith(
        messages: [...state.messages, tmpMsg], updateTimestamp: DateTime.now());
    if (sessionID != null) {
      HiveDB().addMessageToSession(sessionID, tmpMsg);
    }
  }

  ChatMessage? findMessageById(String id) {
    return state.messages.firstWhereOrNull((message) => message.id == id);
  }

  void setCurrentSession({String? id}) async {
    if (id == null) {
      state = ChatSession(
          // recent message?
          id: const Uuid().v1(),
          createTimestamp: DateTime.now(),
          updateTimestamp: DateTime.now(),
          messages: []);
    } else {
      ChatSession? currentChatSession = await HiveDB().readChatSessionById(id);
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
      state = state.copyWith(
          messages: updatedMessages, updateTimestamp: DateTime.now());
    }
  }

  List<ChatMessage> getRecentMessages(DateTime fromTime) {
    return state.messages
        .where((message) => message.timestamp.isAfter(fromTime))
        .toList();
  }

  void addMessageStream(String id, Stream<String> stream) async {
    await for (final content in stream) {
      // Check if the message already exists
      var existingMessage = findMessageById(id);
      if (existingMessage != null) {
        // Update existing message
        updateMessage(id, content);
      } else {
        // Add new message if not found (for initial case)
        addMessage(
            messageID: id,
            messageText: content,
            isFromAI: true,
            temporary: true);
      }
    }
  }

  void generationSessionTitle(String message, ChatSession chatSession) {
    ChatRepository().generateSessionTitle(
        userMessage: message,
        chatSession: chatSession,
        onUpdateSessionTitle: (String title) {
          state = state.copyWith(title: title);
        });
  }

  void sendMessage(
      {required StreamController<String> controller,
      required String userMessage,
      required ChatSession chatSession,
      required OnStreamingCallback onStreamingCallback,
      required OnStreamStopWidgetCallback onStreamStopWidgetCallback}) {
    ChatRepository().fetchStreamResponse(
        controller: controller,
        userMessage: userMessage,
        chatSession: chatSession,
        onStreamingCallback: onStreamingCallback,
        onStreamStopCallback: (totalMessage) {
          onStreamStopWidgetCallback();
          var tmpMsg = ChatMessage(
              id: const Uuid().v1(),
              content: totalMessage,
              isFromAI: true,
              temporary: false,
              timestamp: DateTime.now());
          HiveDB().addMessageToSession(chatSession.id, tmpMsg);
        });
  }
}
