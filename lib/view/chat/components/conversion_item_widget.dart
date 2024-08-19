import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../entity/chat_session.dart';

class ConversionItemWidget extends StatelessWidget {
  final int index;
  final GestureTapCallback onTap;
  final GestureTapCallback onLongPress;
  final List<ChatSession> sessionList;
  late final ChatSession chatSession;

  ConversionItemWidget({
    super.key,
    required this.index,
    required this.onTap,
    required this.onLongPress,
    required this.sessionList,
  }) : chatSession = sessionList[index];

  @override
  Widget build(BuildContext context) {
    String formattedDate =
        DateFormat('yyyy-MM-dd').format(chatSession.updateTimestamp!);
    bool showHeader = index == 0 ||
        formattedDate !=
            DateFormat('yyyy-MM-dd')
                .format(sessionList[index - 1].updateTimestamp!);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showHeader)
              Container(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  formattedDate,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            GestureDetector(
              onTap: onTap,
              onLongPress: onLongPress,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(width: 12), // Add space between items
                  Expanded(
                    child: Text(
                      chatSession.title ?? chatSession.messages[0].content,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      softWrap: false,
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
