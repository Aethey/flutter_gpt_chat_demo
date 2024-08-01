import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../entity/chat_session.dart';
import '../../../state/chat_state.dart';
import '../../../state/session_list_state.dart';

class SessionList extends ConsumerWidget {
  const SessionList(this.sessionList, {super.key});
  final List<ChatSession> sessionList;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future.microtask(
        () => ref.read(sessionListProvider.notifier).loadSessions());
    return Drawer(
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
                    'Your Conversations',
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
                              .setCurrentSession(sessionList[index].id));
                          Navigator.pop(context);
                        });
                      })),
          Container(
            height: 200,
          )
          // Add more list tiles for more users
        ],
      ),
    );
  }

  Widget _buildConversionItem(
      ChatSession chatSession, int index, GestureTapCallback onTap) {
    return ListTile(
      title: SizedBox(
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Icon(Icons.ac_unit),
            const SizedBox(width: 4), // Add space between items
            Text("chat$index"),
            const SizedBox(width: 12), // Add space between items
            Expanded(
              child: Text(
                chatSession.messages[0].content ?? "",
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                softWrap: false,
              ),
            ),
          ],
        ),
      ),
      onTap: onTap,
    );
  }
}
