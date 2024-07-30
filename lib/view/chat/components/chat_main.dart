import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ry_chat/view/chat/components/reply_message_bubble.dart';
import 'package:ry_chat/view/chat/components/user_message_bubble.dart';

import '../../../state/message_list_provider.dart';
import 'message_group.dart';

class ChatList extends ConsumerWidget {
  const ChatList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messages = ref.watch(messageListProvider);
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 80, top: 80),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        if (message.stream != null) {
          return ReplyMessageBubble(
            messageStream: message.stream!,
          );
        } else {
          return message.isUserMessage
              ? UserMessageBubble(message: message)
              : ReplyMessageBubble(
                  messageStream: Stream.value(message.text),
                );
        }
      },
    );
  }
}
