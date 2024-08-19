import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../config_dev.dart';
import '../../../entity/chat_session.dart';
import '../../../state/chat_state.dart';
import '../../../state/session_list_state.dart';
import 'conversion_item_widget.dart';
import 'filter_tags.dart';
import 'menu_item_widget.dart';

typedef OnItemClick = void Function();

class ChatSessionList extends ConsumerStatefulWidget {
  const ChatSessionList(this.sessionList, {super.key});

  final List<ChatSession> sessionList;
  @override
  ChatSessionListState createState() => ChatSessionListState();
}

class ChatSessionListState extends ConsumerState<ChatSessionList> {
  @override
  void initState() {
    ref.read(sessionListProvider.notifier).loadSessions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
              child: widget.sessionList.isEmpty
                  ? const Center(
                      child: Text(
                        "No chats available",
                        style: TextStyle(color: Colors.black),
                      ),
                    )
                  : ListView.builder(
                      // itemExtent: XX,
                      itemCount: widget.sessionList.length,
                      itemBuilder: (context, index) {
                        return ConversionItemWidget(
                            index: index,
                            onTap: () {
                              ref.read(chatProvider.notifier).setCurrentSession(
                                  id: widget.sessionList[index].id);
                              Navigator.pop(context);
                            },
                            onLongPress: () {
                              ref
                                  .read(sessionListProvider.notifier)
                                  .deleteSession(widget.sessionList[index].id);
                            },
                            sessionList: widget.sessionList);
                      })),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8.0),
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FilterTags(
                  onSelectionChanged: (selectedTags) {
                    if (selectedTags.isNotEmpty) {
                      ref
                          .read(sessionListProvider.notifier)
                          .filterSessionsByDateLabel(
                              AppConfig.filterMap[selectedTags.reduce(max)]!);
                    } else {
                      ref
                          .read(sessionListProvider.notifier)
                          .filterSessionsByDateLabel("all");
                    }
                  },
                ),
                const SizedBox(
                  height: 12,
                ),
                MenuItemWidget(
                    iconPath: 'assets/icons/broom.png',
                    onItemClick: () {
                      ref.read(sessionListProvider.notifier).clearSessions();
                    },
                    title: "clear history"),
                // _buildMenuItem('assets/icons/resume.png', () {}, "edit prompt"),
                // _buildMenuItem('assets/icons/setting.png', () {}, "setting"),
              ],
            ),
          )
          // Add more list tiles for more users
        ],
      ),
    );
  }
}
