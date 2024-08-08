import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ry_chat/entity/chat_message.dart';
import 'package:uuid/uuid.dart';
import '../../data/database/hive_db.dart';
import '../../entity/chat_session.dart';
import '../../state/chat_state.dart';
import '../../state/session_list_state.dart';
import 'components/chat_main.dart';
import 'components/chat_session_list.dart';
import 'components/input_section.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatPage extends ConsumerStatefulWidget {
  const ChatPage({super.key});

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final ValueNotifier<int> _buttonType = ValueNotifier<int>(0);
  final ValueNotifier<bool> _isStreaming = ValueNotifier<bool>(false);
  final ScrollController _scrollController = ScrollController();

  void _sendMessage(ChatSession chatSession) {
    if (_controller.text.isNotEmpty) {
      ref
          .read(chatProvider.notifier)
          .addMessage(messageText: _controller.text, sessionID: chatSession.id);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 50),
            curve: Curves.easeOut,
          );
        }
      });

      // Create a new StreamController for the response
      final responseController = StreamController<String>.broadcast();
      ref
          .read(chatProvider.notifier)
          .addMessageStream(const Uuid().v1(), responseController.stream);

      // Fetch API response
      _buttonType.value = 2;
      _isStreaming.value = true;
      if (chatSession.messages.isEmpty) {
        ref
            .read(chatProvider.notifier)
            .generationSessionTitle(_controller.text, chatSession);
      }

      ref.read(chatProvider.notifier).sendMessage(
          controller: responseController,
          userMessage: _controller.text,
          chatSession: chatSession,
          onStreamingCallback: () {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (_scrollController.hasClients) {
                _scrollController.animateTo(
                  _scrollController.position.maxScrollExtent,
                  duration: const Duration(milliseconds: 50),
                  curve: Curves.easeOut,
                );
              }
            });
          },
          onStreamStopWidgetCallback: () {
            _buttonType.value = 0;
            _isStreaming.value = false;
          });
      _controller.clear();
    }
  }

  void _handleTextChange() {
    if (_controller.text.isNotEmpty) {
      _buttonType.value = 1;
    } else {
      if (!_isStreaming.value) {
        _buttonType.value = 0;
      }
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_handleTextChange);
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(_handleTextChange);
    Future.microtask(
        () => ref.read(sessionListProvider.notifier).loadSessions());
  }

  @override
  Widget build(BuildContext context) {
    final sessionListSession = ref.watch(sessionListProvider);
    final chatSession = ref.watch(chatProvider);
    return Scaffold(
      drawer: ChatSessionList(sessionListSession),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Stack(
                children: [
                  ChatList(_scrollController), // Mock chat list
                  Align(
                      alignment: Alignment.topCenter,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0),
                        ),
                        child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                            child: Container(
                              padding: const EdgeInsets.only(left: 16),
                              height: 80,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 1.sw * 2 / 3,
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          'assets/icons/chatbot.png',
                                          width: 40, // Image width
                                          height: 40, // Image height
                                          fit: BoxFit.cover, // Cover fit
                                          key: const ValueKey('text'),
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          chatSession.title ?? "default title",
                                          style: const TextStyle(
                                              color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ),
                                  chatSession.messages.isNotEmpty
                                      ? GestureDetector(
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(right: 8),
                                            child: Image.asset(
                                              'assets/icons/plus_border.png',
                                              width: 48, // Image width
                                              height: 48, // Image height
                                              fit: BoxFit.cover, // Cover fit
                                              key: const ValueKey('text'),
                                            ),
                                          ),
                                          onTap: () {
                                            Future.microtask(() => ref
                                                .read(chatProvider.notifier)
                                                .setCurrentSession());
                                          },
                                        )
                                      : Container()
                                ],
                              ),
                            )),
                      )),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: InputSection(
                      buttonType: _buttonType,
                      controller: _controller,
                      onSendMessage: () => _sendMessage(chatSession),
                    ),
                  ),
                ],
              ), // Placeholder to ensure TextField and ListView are at the bottom
            ),
          ],
        ),
      ),
    );
  }
}
