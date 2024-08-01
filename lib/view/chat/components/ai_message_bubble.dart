import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../../entity/chat_message.dart';
import 'markdown_part.dart';

class AIMessageBubble extends StatefulWidget {
  final ChatMessage message;

  const AIMessageBubble({super.key, required this.message});

  @override
  State<AIMessageBubble> createState() => _ReplyMessageBubbleState();
}

class _ReplyMessageBubbleState extends State<AIMessageBubble>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true; // keep list item state

  @override
  Widget build(BuildContext context) {
    super.build(context); // AutomaticKeepAliveClientMixin，so super.build

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Align(
        alignment: Alignment.topLeft,
        child: Container(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.9),
            padding: const EdgeInsets.all(2),
            child: MarkdownPart(
              message: widget.message,
            )),
      ),
    );
  }
}
