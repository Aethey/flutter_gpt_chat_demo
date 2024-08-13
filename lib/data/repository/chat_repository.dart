import 'dart:async';
import 'dart:ffi';

import 'package:ry_chat/data/api/dio_manager.dart';
import 'package:ry_chat/entity/chat_session.dart';

import '../../config_dev.dart';
import '../../entity/chat_message.dart';
import '../../prompt.dart';

typedef OnStreamStopCallback = void Function(String totalMessage);
typedef OnStreamingCallback = void Function();
typedef OnProcessing = void Function(String content);
typedef OnProcessClose = void Function();
typedef OnProcessError = void Function(Object error);
typedef OnUpdateSessionTitle = void Function(String sessionTitle);
typedef OnStreamStopWidgetCallback = void Function();

class ChatRepository {
  static final ChatRepository _singleton = ChatRepository._internal();

  factory ChatRepository() {
    return _singleton;
  }

  ChatRepository._internal();

  Future<void> generateSessionTitle({
    required String userMessage,
    required ChatSession chatSession,
    required OnUpdateSessionTitle onUpdateSessionTitle,
  }) async {
    String tmp = "this is first message from user and "
        "you will give an answer,you analysis there info then named this chat return the name to me, just give me the name without anymore"
        "and this is first message $userMessage";
    DioManager().fetchRegularResponse(
        body: _createRequestBody(
            chatSession,
            [
              {"role": "user", "content": tmp}
            ],
            false),
        onUpdateSessionTitle: onUpdateSessionTitle);
  }

  Future<void> fetchStreamResponse(
      {required StreamController<String> controller,
      required String userMessage,
      required ChatSession chatSession,
      required OnStreamingCallback onStreamingCallback,
      required OnStreamStopCallback onStreamStopCallback}) async {
    DioManager().fetchStreamResponse(
        body: _createRequestBody(
            chatSession, _createHistoryMessage(chatSession, userMessage), true),
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

    // Check if it's the first interaction
    bool isFirstInteraction = messagesCount == 0;

    // Default prompt for the first interaction
    List<Map<String, String>> historyMessages = allMessages
        .sublist(0,
            messagesCount < maxHistoryCount ? messagesCount : maxHistoryCount)
        .reversed // recently message，maybe need
        .map((m) {
      return {"role": m.isFromAI ? "assistant" : "user", "content": m.content};
    }).toList();

    // Add the user message
    historyMessages.add({"role": "user", "content": userMessage});

    // Add the default prompt if it's the first interaction
    if (isFirstInteraction) {
      historyMessages
          .insert(0, {"role": "assistant", "content": defaultPrompt});
    }

    return historyMessages;
  }

  Map<String, dynamic> _createRequestBody(
      ChatSession chatSession, List<Map<String, String>> body, bool isStream) {
    return {
      "model": AppConfig.commonModel,
      "messages": body,
      "stream": isStream
    };
  }
}
