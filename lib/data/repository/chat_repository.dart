import 'dart:async';

import 'package:ry_chat/data/api/dio_manager.dart';
import 'package:ry_chat/entity/chat_session.dart';

import '../../config_dev.dart';
import '../../entity/chat_message.dart';

typedef OnStreamStopCallback = void Function(String totalMessage);
typedef OnStreamingCallback = void Function();
typedef OnProcessing = void Function(String content);
typedef OnProcessClose = void Function();
typedef OnProcessError = void Function(Object error);

class ChatRepository {
  static final ChatRepository _singleton = ChatRepository._internal();

  factory ChatRepository() {
    return _singleton;
  }

  ChatRepository._internal();

  Future<void> fetchStreamResponse(
      {required StreamController<String> controller,
      required String userMessage,
      required ChatSession chatSession,
      required OnStreamingCallback onStreamingCallback,
      required OnStreamStopCallback onStreamStopCallback}) async {
    DioManager().fetchStreamResponse(
        body: _createRequestBody(chatSession, userMessage),
        onProcessing: (content) => {controller.add(content)},
        onProcessClose: () => {controller.close()},
        onProcessError: (error) =>
            {controller.addError(error), controller.close()},
        onStreamingCallback: onStreamingCallback,
        onStreamStopCallback: onStreamStopCallback);
  }

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
