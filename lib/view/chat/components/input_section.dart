import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ry_chat/view/chat/components/toggle_button.dart';

import '../../../state/message_list_provider.dart';
import 'custom_text_field.dart';

typedef SendMessageCallback = void Function();

class InputSection extends StatelessWidget {
  final ValueNotifier<bool> isVoice;
  final TextEditingController controller;
  final SendMessageCallback onSendMessage;

  InputSection(
      {required this.isVoice,
      required this.onSendMessage,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10.0),
        topRight: Radius.circular(10.0),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
        child: Container(
          height: 80,
          color: Colors.white
              .withOpacity(0.6), // Semi-transparent white background
          padding: EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              MenuButton(),
              Expanded(
                child: CustomTextField(
                  isVoice: isVoice,
                  controller: controller,
                ),
              ),
              ToggleButton(
                isVoice: isVoice,
                onSendMessage: onSendMessage,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MenuButton extends StatelessWidget {
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
