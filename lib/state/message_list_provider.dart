import 'package:flutter_riverpod/flutter_riverpod.dart';

class Message {
  final String text;
  final bool isUserMessage;
  final Stream<String>? stream;

  Message({required this.text, required this.isUserMessage, this.stream});
}

final messageListProvider =
    StateNotifierProvider<MessageListNotifier, List<Message>>((ref) {
  return MessageListNotifier();
});

class MessageListNotifier extends StateNotifier<List<Message>> {
  MessageListNotifier() : super([]);

  void addMessage(String text, bool isUserMessage) {
    state = [
      ...state,
      Message(text: text, isUserMessage: isUserMessage),
    ];
  }

  void addStreamMessage(Stream<String> stream) {
    state = [
      ...state,
      Message(text: '', isUserMessage: false, stream: stream),
    ];
  }
}
