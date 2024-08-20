import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomDialogButton extends StatelessWidget {
  final String title;
  final GestureTapCallback onTap;
  const CustomDialogButton(
      {super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        title,
        style: GoogleFonts.oswald(
          textStyle: const TextStyle(
              color: Colors.black, fontSize: 24.0, letterSpacing: .5),
        ),
      ),
    );
  }
}
