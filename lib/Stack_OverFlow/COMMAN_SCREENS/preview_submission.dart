import 'package:competitivecodingarena/Stack_OverFlow/COMMAN_SCREENS/submission_class.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_syntax_view/flutter_syntax_view.dart';

class DialogWindow extends StatelessWidget {
  final Image image;
  final double width;
  final Submission submission;
  const DialogWindow(
      {required this.image,
      required this.width,
      required this.submission,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: PreviewSubmission(
            width: width, submission: submission, image: image));
  }
}

class PreviewSubmission extends StatelessWidget {
  final Submission submission;
  final double width;
  final Image image;
  const PreviewSubmission(
      {required this.image,
      required this.width,
      required this.submission,
      super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
        title:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          CircleAvatar(radius: 30, child: ClipOval(child: image)),
          SizedBox(
            width: 5,
          ),
          Text.rich(
              TextSpan(children: [
                TextSpan(
                    text: "${submission.username}'s ",
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto')),
                TextSpan(
                    text: "${submission.language} Submission",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto'))
              ]),
              overflow: TextOverflow.ellipsis),
          Expanded(child: Container()),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(10),
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5))),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: submission.code));
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Code copied to clipboard!"),
                    duration: Duration(seconds: 2)));
              },
              child: Icon(Icons.copy, color: Colors.white, size: 30)),
          SizedBox(width: 8),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5))),
              onPressed: () => Navigator.of(context).pop(),
              child: Icon(Icons.close, color: Colors.white, size: 30))
        ]),
        content: SizedBox(
            width: width * 0.5,
            height: 500,
            child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Row(children: [
                    Text(
                        "${submission.executionTimeMs} ms  •  ${(submission.memoryUsageKb / 1024).toStringAsFixed(2)} MB",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.italic,
                            letterSpacing: 0.5,
                            foreground: Paint()
                              ..shader = LinearGradient(
                                colors: [Color(0xFF6A737C), Color(0xFF4A90E2)],
                              ).createShader(Rect.fromLTWH(0, 0, 200, 30)),
                            fontFamily: 'Arial'))
                  ]),
                  SizedBox(height: 8),
                  Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: submission.tags
                          .map((tag) => _buildTag(tag, _getColorFromTag(tag)))
                          .toList()),
                  SizedBox(height: 12),
                  Container(
                      height: 460,
                      width: width * 0.49,
                      padding: EdgeInsets.all(12),
                      child: SyntaxView(
                          code: submission.code,
                          syntax: _getSyntax(submission.language),
                          syntaxTheme: SyntaxTheme.monokaiSublime(),
                          fontSize: 13,
                          withZoom: true,
                          withLinesCount: true,
                          expanded: true))
                ]))));
  }

  Color _getColorFromTag(String tag) {
    int hash = tag.hashCode;
    return Colors.primaries[hash % Colors.primaries.length];
  }

  Widget _buildTag(String label, Color color) {
    return InkWell(
        onTap: () {},
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
                color: submission.status == label
                    ? color.withOpacity(0.1)
                    : Colors.transparent,
                border: Border.all(color: color, width: 1)),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Text(label,
                  style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                      fontFamily: 'Arial'))
            ])));
  }

  Syntax _getSyntax(String language) {
    switch (language.toLowerCase()) {
      case "c++":
        return Syntax.CPP;
      case "python":
        return Syntax.SWIFT;
      case "java":
        return Syntax.JAVA;
      case "javascript":
        return Syntax.JAVASCRIPT;
      default:
        return Syntax.DART;
    }
  }

  Widget getStatusBadge(String status) {
    Color badgeColor;
    IconData icon;

    switch (status) {
      case "Accepted":
        badgeColor = Color(0xFF48A868);
        icon = Icons.check_circle;
        break;
      case "Wrong Answer":
        badgeColor = Color(0xFFD1383D);
        icon = Icons.close;
        break;
      case "Time Limit Exceeded":
        badgeColor = Color(0xFFFF9800);
        icon = Icons.timer_off;
        break;
      case "Runtime Error":
        badgeColor = Color(0xFF9C27B0);
        icon = Icons.error;
        break;
      case "Compilation Error":
        badgeColor = Colors.blue;
        icon = Icons.code_off;
        break;
      default:
        badgeColor = Color(0xFF6A737C);
        icon = Icons.question_mark;
    }

    return Container(
        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
            color: badgeColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(3),
            border: Border.all(color: badgeColor)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 12, color: badgeColor),
          SizedBox(width: 4),
          Text(status,
              style: TextStyle(
                  color: badgeColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                  fontFamily: 'Arial'))
        ]));
  }
}
