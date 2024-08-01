import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../../entity/chat_message.dart';

class MarkdownPart extends StatelessWidget {
  const MarkdownPart({super.key, required this.message});
  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: MarkdownBody(
        data: message.content,
        styleSheet: MarkdownStyleSheet(
          p: const TextStyle(fontSize: 16.0, color: Colors.black),
          code: const TextStyle(
            color: Colors.black,
            backgroundColor: Colors.transparent,
            fontFamily: 'monospace',
            fontSize: 14.0,
          ),
        ),
      ),
    );
  }
}
