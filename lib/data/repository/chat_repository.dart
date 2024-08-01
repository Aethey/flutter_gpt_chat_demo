import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ry_chat/data/api/dio_manager.dart';
import 'package:ry_chat/entity/chat_session.dart';

import '../../config_dev.dart';
import '../../entity/chat_message.dart';

typedef OnStreamStopCallback = void Function(String totalMessage);
typedef OnStreamingCallback = void Function();

class ChatRepository {
  Future<void> fetchStreamResponse(
      {required StreamController<String> controller,
      required String userMessage,
      required ChatSession chatSession,
      required OnStreamingCallback onStreamingCallback,
      required OnStreamStopCallback onStreamStopCallback}) async {}

  List<Map<String, String>> _createHistoryMessage(
      ChatSession chatSession, String userMessage) {
    int maxHistoryCount = 10; // max history
    List<ChatMessage> allMessages =
        List<ChatMessage>.from(chatSession.messages ?? []);
    allMessages.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    int messagesCount = allMessages.length; // chat history count
// if not 10
    List<Map<String, String>> historyMessages = allMessages
        .sublist(0,
            messagesCount < maxHistoryCount ? messagesCount : maxHistoryCount)
        .reversed // recently message，maybe need
        .map((m) {
      return {"role": m.isFromAI ? "assistant" : "user", "content": m.content};
    }).toList();
    historyMessages.add({"role": "user", "content": userMessage});
    return historyMessages;
  }

  Map<String, dynamic> _createRequestBody(
      ChatSession chatSession, String userMessage) {
    return {
      "model": AppConfig.commonModel,
      "messages": _createHistoryMessage(chatSession, userMessage),
      "stream": true
    };
  }
}
