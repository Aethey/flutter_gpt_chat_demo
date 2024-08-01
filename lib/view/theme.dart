import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

MarkdownStyleSheet getDefaultMarkdownStyleSheet(BuildContext context) {
  return MarkdownStyleSheet.fromTheme(Theme.of(context));
}

MarkdownStyleSheet customMarkdownStyleSheet(BuildContext context) {
  // Get the default styles
  MarkdownStyleSheet defaultStyleSheet = getDefaultMarkdownStyleSheet(context);

  // Customize the h1 style
  TextStyle customH1Style = defaultStyleSheet.h1!.copyWith(color: Colors.black);
  TextStyle customH2Style = defaultStyleSheet.h2!.copyWith(color: Colors.black);
  TextStyle customH3Style = defaultStyleSheet.h3!.copyWith(color: Colors.black);
  TextStyle customPStyle = defaultStyleSheet.p!.copyWith(color: Colors.black);

  return defaultStyleSheet.copyWith(
      h1: customH1Style, h2: customH2Style, h3: customH3Style, p: customPStyle);
}
