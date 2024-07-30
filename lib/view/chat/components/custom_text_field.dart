import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class CustomTextField extends StatelessWidget {
  final ValueNotifier<int> buttonType;
  final TextEditingController controller;

  const CustomTextField(
      {super.key, required this.buttonType, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
        valueListenable: buttonType,
        builder: (context, buttonType, child) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: () {
              switch (buttonType) {
                case 0:
                case 1:
                  return TextField(
                    onTapOutside: (event) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    onTap: () {},
                    style: const TextStyle(color: Colors.black),
                    minLines: 1,
                    maxLines: null,
                    textAlignVertical: TextAlignVertical.top,
                    controller: controller,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide:
                              const BorderSide(color: Colors.black, width: 2.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide:
                              const BorderSide(color: Colors.black, width: 2.0),
                        ),
                        hintText: "Message"),
                  );
                // case 0:
                // case 1:
                case 2:
                  return Center(
                    child: SizedBox(
                      height: 40,
                      child: LoadingAnimationWidget.horizontalRotatingDots(
                        color: Colors.black,
                        size: 120,
                      ),
                    ),
                  );
              }
            }(),
          );
        });
    //
    //
  }
}
