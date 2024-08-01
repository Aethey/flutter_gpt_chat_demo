import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ry_chat/view/chat/components/user_message_bubble.dart';

import '../../../state/chat_state.dart';
import 'ai_message_bubble.dart';

class ChatList extends ConsumerWidget {
  const ChatList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatSession = ref.watch(chatProvider);
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 80, top: 80),
      itemCount: chatSession.messages.length,
      itemBuilder: (context, index) {
        final message = chatSession.messages[index];
        return message.isFromAI
            ? AIMessageBubble(message: message)
            : UserMessageBubble(message: message);
      },
    );
  }
}
