import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:ry_chat/view/chat/components/toggle_button.dart';
import 'custom_text_field.dart';

typedef SendMessageCallback = void Function();

class InputSection extends StatelessWidget {
  final ValueNotifier<int> buttonType;
  final TextEditingController controller;
  final SendMessageCallback onSendMessage;

  const InputSection(
      {super.key,
      required this.buttonType,
      required this.onSendMessage,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(10.0),
        topRight: Radius.circular(10.0),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
        child: Container(
            height: 80,
            color: Colors.white
                .withOpacity(0.6), // Semi-transparent white background
            padding: const EdgeInsets.all(8.0),
            child: ValueListenableBuilder<int>(
                valueListenable: buttonType,
                builder: (context, type, child) {
                  return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      transitionBuilder:
                          (Widget child, Animation<double> animation) {
                        return ScaleTransition(scale: animation, child: child);
                      },
                      child: () {
                        switch (type) {
                          case 0:
                          case 1:
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const MenuButton(),
                                Expanded(
                                  child: CustomTextField(
                                    buttonType: buttonType,
                                    controller: controller,
                                  ),
                                ),
                                ToggleButton(
                                  buttonType: buttonType,
                                  onSendMessage: onSendMessage,
                                ),
                              ],
                            );
                          case 2:
                            return Center(
                              child: SizedBox(
                                height: 25,
                                child: LoadingAnimationWidget.waveDots(
                                  color: Colors.black,
                                  size: 60,
                                ),
                              ),
                            );
                        }
                        return Container();
                      }());
                })),
      ),
    );
  }
}

class MenuButton extends StatelessWidget {
  const MenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => GestureDetector(
        onTap: () {
          Scaffold.of(context).openDrawer();
        },
        child: const Padding(
          padding: EdgeInsets.only(top: 8.0, bottom: 8.0, right: 8.0),
          child: Icon(
            Icons.menu,
            size: 36,
          ),
        ),
      ),
    );
  }
}
