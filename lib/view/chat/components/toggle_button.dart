import 'package:flutter/cupertino.dart';
import 'input_section.dart';

class ToggleButton extends StatelessWidget {
  final ValueNotifier<int> buttonType;
  final SendMessageCallback onSendMessage;

  const ToggleButton(
      {super.key, required this.buttonType, required this.onSendMessage});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSendMessage,
      child: Padding(
        padding:
            const EdgeInsets.only(top: 8.0, bottom: 8.0, right: 8.0, left: 8.0),
        child: ValueListenableBuilder<int>(
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
                      // common state  no word no streaming
                      return Image.asset(
                        'assets/icons/microphone_black.png',
                        width: 36, // Image width
                        height: 36, // Image height
                        fit: BoxFit.cover, // Cover fit
                        key: const ValueKey('microphone'),
                      ); // Replace Widget1 with your specific widget
                    case 1:
                      // input state, text length > 0
                      return Image.asset(
                        'assets/icons/send_black.png',
                        width: 36, // Image width
                        height: 36, // Image height
                        fit: BoxFit.cover, // Cover fit
                        key: const ValueKey('text'),
                      );
                    case 2:
                      //  streaming
                      return Image.asset(
                        'assets/icons/stop_black.png',
                        width: 36, // Image width
                        height: 36, // Image height
                        fit: BoxFit.cover, // Cover fit
                        key: const ValueKey('freeze'),
                      ); // Replace Widget2 with your specific widget
                    default:
                      // default
                      return Image.asset(
                        'assets/icons/microphone_black.png',
                        width: 36, // Image width
                        height: 36, // Image height
                        fit: BoxFit.cover, // Cover fit
                        key: const ValueKey('microphone'),
                      ); // Default case to handle unexpected values
                  }
                }());
          },
        ),
      ),
    );
  }
}
