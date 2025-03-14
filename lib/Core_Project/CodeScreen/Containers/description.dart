import 'package:flutter/material.dart';
import 'package:competitivecodingarena/Core_Project/Problemset/examples/exampleprobs.dart';

RichText problemToRichText(Problem problem) {
  List<TextSpan> textSpans = [];

  for (var content in problem.content) {
    TextStyle style = TextStyle(
      fontSize: (content['fontSize'] as num?)?.toDouble() ?? 16,
      color: _getColor(content['color']),
      fontWeight:
          content['isBold'] == true ? FontWeight.bold : FontWeight.normal,
      fontStyle:
          content['isItalic'] == true ? FontStyle.italic : FontStyle.normal,
    );

    textSpans.add(TextSpan(
      text: content['text'] as String,
      style: style,
    ));
  }

  return RichText(
    text: TextSpan(
      style: const TextStyle(fontSize: 16, color: Colors.white),
      children: textSpans,
    ),
  );
}

Color _getColor(String? colorName) {
  switch (colorName) {
    case 'green':
      return Colors.green;
    case 'yellow':
      return Colors.yellow;
    case 'cyan':
      return Colors.cyan;
    case 'orange':
      return Colors.orange;
    case 'red':
      return Colors.red;
    default:
      return Colors.white;
  }
}
