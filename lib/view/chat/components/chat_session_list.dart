import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../entity/chat_session.dart';
import '../../../state/chat_state.dart';
import '../../../state/session_list_state.dart';

typedef OnItemClick = void Function();

class ChatSessionList extends ConsumerWidget {
  const ChatSessionList(this.sessionList, {super.key});
  final List<ChatSession> sessionList;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future.microtask(
        () => ref.read(sessionListProvider.notifier).loadSessions());
    return Container(
      color: Colors.white,
      width: 1.sw / 2,
      height: 1.sh,
      child: Column(
        children: <Widget>[
          SizedBox(
            width: double.infinity,
            height: 120,
            child: DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue, // Solid color
                gradient: LinearGradient(
                  colors: [Colors.white, Colors.grey], // Gradient
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/icons/artificial_intelligence.png',
                    width: 48, // Image width
                    height: 48, // Image height
                    fit: BoxFit.cover, // Cover fit
                  ),
                  Text(
                    'Your Chat',
                    style: GoogleFonts.oswald(
                      textStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                          letterSpacing: .5),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
              child: sessionList.isEmpty
                  ? const Center(
                      child: Text(
                        "No chats available",
                        style: TextStyle(color: Colors.black),
                      ),
                    )
                  : ListView.builder(
                      itemCount: sessionList.length,
                      itemBuilder: (context, index) {
                        return _buildConversionItem(sessionList[index], index,
                            () {
                          Future.microtask(() => ref
                              .read(chatProvider.notifier)
                              .setCurrentSession(id: sessionList[index].id));
                          Navigator.pop(context);
                        }, context, ref);
                      })),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8.0),
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildMenuItem('assets/icons/broom.png', () {
                  Future.microtask(() =>
                      ref.read(sessionListProvider.notifier).clearSessions());
                }, "clear all"),
                _buildMenuItem('assets/icons/resume.png', () {}, "edit prompt"),
                _buildMenuItem('assets/icons/setting.png', () {}, "setting"),
              ],
            ),
          )
          // Add more list tiles for more users
        ],
      ),
    );
  }

  Widget _buildMenuItem(
      String iconPath, OnItemClick onItemClick, String title) {
    return Expanded(
      child: Row(
        children: [
          SizedBox(
            height: 36,
            child: GestureDetector(
              onTap: onItemClick,
              child: SizedBox(
                height: 10,
                width: 45,
                child: Image.asset(
                  iconPath,
                  fit: BoxFit.contain, // Cover fit
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          Text(
            title,
            style: const TextStyle(color: Colors.black),
          )
        ],
      ),
    );
  }

  Widget _buildConversionItem(
    ChatSession chatSession,
    int index,
    GestureTapCallback onTap,
    BuildContext context,
    WidgetRef ref,
  ) {
    String formattedDate =
        DateFormat('yyyy-MM-dd').format(sessionList[index].updateTimestamp!);
    bool showHeader = index == 0 ||
        formattedDate !=
            DateFormat('yyyy-MM-dd')
                .format(sessionList[index - 1].updateTimestamp!);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showHeader)
              Container(
                padding: const EdgeInsets.all(8.0),
                // color: Colors.grey[300],
                child: Text(formattedDate,
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
              ),
            GestureDetector(
              onTap: onTap,
              onLongPress: () {
                Future.microtask(() => ref
                    .read(sessionListProvider.notifier)
                    .deleteSession(chatSession.id));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // const Icon(Icons.ac_unit),
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
