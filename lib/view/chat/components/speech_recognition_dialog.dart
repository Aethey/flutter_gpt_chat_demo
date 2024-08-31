import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../state/speech_recognition_state.dart';
import 'custom_dialog_button.dart';
import 'custom_header_dialog.dart';

class SpeechRecognitionDialog extends ConsumerWidget {
  final OnFirstAction onFirstAction;
  final OnSecondAction onSecondAction;
  const SpeechRecognitionDialog(
      {super.key, required this.onFirstAction, required this.onSecondAction});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(speechRecognitionProvider);
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.5,
      height: MediaQuery.of(context).size.height * 0.5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            child: _buildContent(state),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CustomDialogButton(
                title: "Start",
                onTap: onFirstAction,
              ),
              CustomDialogButton(
                title: "Stop",
                onTap: onSecondAction,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContent(SpeechRecognitionState state) {
    return AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return ScaleTransition(scale: animation, child: child);
        },
        child: () {
          switch (state.state) {
            case RecognitionState.initial:
              return const Center(
                child: Text(
                  "Test Whisper Local",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.w500),
                ),
              );
            case RecognitionState.analysing:
              return SingleChildScrollView(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: state.content ?? "",
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 24,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 4.0), // 通过padding微调位置
                              child: LoadingAnimationWidget.bouncingBall(
                                color: Colors.black,
                                size: 36,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            case RecognitionState.error:
              return Center(
                child: Text(
                  state.errorMessage ?? 'Unknown error',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            case RecognitionState.stop:
            default:
              return const Center(
                child: Text(
                  "Stop Test",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.w300),
                ),
              );
          }
        }());
  }
}
