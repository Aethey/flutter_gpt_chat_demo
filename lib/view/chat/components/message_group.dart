import 'package:flutter/cupertino.dart';
import 'package:ry_chat/view/chat/components/reply_message_bubble.dart';
import 'package:ry_chat/view/chat/components/user_message_bubble.dart';

import '../../../entity/message_entity.dart';
//
// class MessageGroup extends StatelessWidget {
//   final MessageEntity messageEntity;
//   const MessageGroup({super.key, required this.messageEntity});
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [UserMessageBubble(message: messageEntity), _buildReplyItem()],
//     );
//   }
//
//   Widget _buildReplyItem() {
//     if (messageEntity.stream != null) {
//       return ReplyMessageBubble(
//         messageStream: messageEntity.stream!,
//       );
//     } else {
//       return ReplyMessageBubble(
//         messageStream: Stream.value(messageEntity.answer),
//       );
//     }
//   }
// }
