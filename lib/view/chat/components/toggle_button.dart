import 'package:flutter/cupertino.dart';

import 'input_section.dart';

class ToggleButton extends StatelessWidget {
  final ValueNotifier<bool> isVoice;
  final SendMessageCallback onSendMessage;

  const ToggleButton(
      {super.key, required this.isVoice, required this.onSendMessage});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSendMessage,
      child: Padding(
        padding:
            const EdgeInsets.only(top: 8.0, bottom: 8.0, right: 8.0, left: 8.0),
        child: ValueListenableBuilder<bool>(
          valueListenable: isVoice,
          builder: (context, firstImage, child) {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: firstImage
                  ? Image.asset(
                      'assets/icons/microphone_black.png',
                      width: 36, // Image width
                      height: 36, // Image height
                      fit: BoxFit.cover, // Cover fit
                      key: const ValueKey('microphone'),
                    )
                  : Image.asset(
                      'assets/icons/send_black.png',
                      width: 36, // Image width
                      height: 36, // Image height
                      fit: BoxFit.cover, // Cover fit
                      key: const ValueKey('text'),
                    ),
            );
          },
        ),
      ),
    );
  }
}
