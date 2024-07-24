import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';

import '../../data/api/http_manager.dart';
import '../../data/api/dio_manager.dart';
import '../../state/message_list_provider.dart';
import 'components/chat_main.dart';
import 'components/custom_drawer.dart';
import 'components/input_section.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatPage extends ConsumerStatefulWidget {
  const ChatPage({super.key});

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final ValueNotifier<bool> _isVoice = ValueNotifier<bool>(true);

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      ref.read(messageListProvider.notifier).addMessage(_controller.text, true);

      // Create a new StreamController for the response
      final responseController = StreamController<String>.broadcast();
      ref
          .read(messageListProvider.notifier)
          .addStreamMessage(responseController.stream);

      // Fetch API response
      // fetchApiResponse(responseController, _controller.text);
      DioManager().fetchStreamResponse(
          controller: responseController, userMessage: _controller.text);

      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Stack(
                children: [
                  const ChatList(), // Mock chat list
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
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/icons/chatbot.png',
                                    width: 48, // Image width
                                    height: 48, // Image height
                                    fit: BoxFit.cover, // Cover fit
                                    key: const ValueKey('text'),
                                  ),
                                  const SizedBox(width: 4),
                                  const Text(
                                    "Joi",
                                    style: TextStyle(color: Colors.black),
                                  )
                                ],
                              ),
                            )),
                      )),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: InputSection(
                      isVoice: _isVoice,
                      controller: _controller,
                      onSendMessage: () => _sendMessage(),
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
