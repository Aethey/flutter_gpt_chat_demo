import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../state/image_generation_state.dart';
import 'custom_dialog_button.dart';

typedef OnFirstAction = void Function();
typedef OnSecondAction = void Function();

class CustomHeaderDialog extends ConsumerWidget {
  final OnFirstAction onFirstAction;
  final OnSecondAction onSecondAction;
  const CustomHeaderDialog(
      {super.key, required this.onFirstAction, required this.onSecondAction});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageState = ref.watch(imageGenerationProvider);
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.5,
      height: MediaQuery.of(context).size.height * 0.5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            child: _buildContent(imageState),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CustomDialogButton(
                title: "Generate",
                onTap: onFirstAction,
              ),
              CustomDialogButton(
                title: "Cancel",
                onTap: onSecondAction,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContent(ImageGenerationState imageState) {
    return AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return ScaleTransition(scale: animation, child: child);
        },
        child: () {
          switch (imageState.state) {
            case RequestState.loading:
              return LoadingAnimationWidget.inkDrop(
                color: Colors.black,
                size: 60,
              );
            case RequestState.success:
              return Image.network(
                imageState.imageUrl!,
                fit: BoxFit.cover,
              );
            case RequestState.error:
              return Center(
                child: Text(
                  imageState.errorMessage ?? 'Unknown error',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            case RequestState.initial:
            default:
              return Center(
                child: Text(
                  "Generate Image by OpenAI".replaceAll(' ', '\n\n'),
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.w300),
                ),
              );
          }
        }());
  }
}
