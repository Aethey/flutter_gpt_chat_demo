import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final ValueNotifier<int> buttonType;
  final TextEditingController controller;

  const CustomTextField(
      {super.key, required this.buttonType, required this.controller});

  @override
  Widget build(BuildContext context) {
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
            borderSide: const BorderSide(color: Colors.black, width: 2.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Colors.black, width: 2.0),
          ),
          hintText: "Message"),
    );
  }
}
