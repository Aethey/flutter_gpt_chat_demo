import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../../entity/chat_message.dart';
import '../../../utils/code_element_builder.dart';
import '../../theme.dart';

class MarkdownPart extends StatelessWidget {
  const MarkdownPart({super.key, required this.message});
  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: MarkdownBody(
        data: message.content,
        styleSheet: customMarkdownStyleSheet(context),
        builders: {
          'code': CodeElementBuilder(),
        },
      ),
    );
  }
}
