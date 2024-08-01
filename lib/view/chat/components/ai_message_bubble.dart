import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../entity/chat_message.dart';

class AIMessageBubble extends StatefulWidget {
  final ChatMessage message;

  const AIMessageBubble({super.key, required this.message});

  @override
  State<AIMessageBubble> createState() => _ReplyMessageBubbleState();
}

class _ReplyMessageBubbleState extends State<AIMessageBubble>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true; // 保持widget活动

  @override
  Widget build(BuildContext context) {
    super.build(context); // AutomaticKeepAliveClientMixin，so super.build

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Align(
        alignment: Alignment.topLeft,
        child: Container(
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75),
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
          child: Text(
            widget.message.content,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
