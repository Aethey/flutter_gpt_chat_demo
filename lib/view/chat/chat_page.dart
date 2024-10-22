import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:uuid/uuid.dart';
import '../../data/database/hive_db.dart';
import '../../entity/chat_session.dart';
import '../../state/chat_state.dart';
import '../../state/image_generation_state.dart';
import '../../state/session_list_state.dart';
import '../../state/speech_recognition_state.dart';
import 'components/chat_main.dart';
import 'components/chat_session_list.dart';
import 'components/custom_header_dialog.dart';
import 'components/input_section.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'components/speech_recognition_dialog.dart';

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
  late TutorialCoachMark tutorialCoachMark;
  GlobalKey keyOne = GlobalKey();

  Future<void> _sendMessage(ChatSession chatSession) async {
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
    } else {
      if (Platform.isAndroid) {
        if (mounted) {
          _showSpeechDialog(context, () async {
            ref.read(speechRecognitionProvider.notifier).startRecording();
          }, () async {
            ref.read(speechRecognitionProvider.notifier).stopRecording();
          });
        }
      } else {
        debugPrint(".....");
      }
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
    ref.read(sessionListProvider.notifier).loadSessions();
    _initializeTutorial();
  }

  Future<void> _initializeTutorial() async {
    bool needShowcase = await HiveDB().getNeedShowcase();
    if (needShowcase) {
      createTutorial();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showTutorial();
      });
    }
  }

  // Function to show a custom dialog
  Future<void> _showMyDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // Dialog is not dismissible by tapping outside
      builder: (BuildContext context) {
        return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            clipBehavior: Clip.hardEdge,
            child: CustomHeaderDialog(
              onFirstAction: () {
                ref.read(imageGenerationProvider.notifier).generateImage();
              },
              onSecondAction: () {
                Navigator.of(context).pop();
              },
            ));
      },
    );
  }

  Future<void> _showSpeechDialog(BuildContext context,
      OnFirstAction onFirstAction, OnSecondAction onSecondAction) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // Dialog is not dismissible by tapping outside
      builder: (BuildContext context) {
        return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            clipBehavior: Clip.hardEdge,
            child: SpeechRecognitionDialog(
              onFirstAction: onFirstAction,
              onSecondAction: () {
                onSecondAction();
                Navigator.of(context).pop();
              },
            ));
      },
    );
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
                              padding: const EdgeInsets.only(left: 8),
                              height: 50,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 1.sw * 2 / 3,
                                    child: Row(
                                      children: [
                                        GestureDetector(
                                          key: keyOne,
                                          child: Image.asset(
                                            'assets/icons/robot1.png',
                                            width: 45, // Image width
                                            height: 45, // Image height
                                            fit: BoxFit.cover, // Cover fit
                                            key: const ValueKey('text'),
                                          ),
                                          onLongPress: () {
                                            _showMyDialog(context);
                                          },
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          chatSession.title ?? "New Chat",
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
                                            ref
                                                .read(chatProvider.notifier)
                                                .setCurrentSession();
                                          },
                                        )
                                      : const SizedBox()
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

  void showTutorial() {
    tutorialCoachMark.show(context: context);
  }

  void createTutorial() {
    tutorialCoachMark = TutorialCoachMark(
      targets: _createTargets(),
      colorShadow: Colors.grey,
      textSkip: "SKIP",
      paddingFocus: 10,
      opacityShadow: 0.5,
      imageFilter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
      onFinish: () async {
        await HiveDB().setNeedShowcase(false);
      },
      onSkip: () {
        return true;
      },
    );
  }

  List<TargetFocus> _createTargets() {
    List<TargetFocus> targets = [];
    targets.add(
      TargetFocus(
        identify: "keyOne",
        keyTarget: keyOne,
        alignSkip: Alignment.topRight,
        enableOverlayTab: true,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Long press to generate an image",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
    return targets;
  }
}
