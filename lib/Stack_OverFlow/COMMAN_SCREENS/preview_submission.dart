import 'package:competitivecodingarena/Stack_OverFlow/COMMAN_SCREENS/submission_class.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_syntax_view/flutter_syntax_view.dart';

class PreviewSubmission extends StatelessWidget {
  final Submission submission;
  final double width;
  const PreviewSubmission(
      {required this.width, required this.submission, super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(2),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              "${submission.username}'s ${submission.language} Submission",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto',
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.all(10),
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: submission.code));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Code copied to clipboard!"),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: Icon(
              Icons.copy,
              color: Colors.white,
              size: 30,
            ),
          ),
          SizedBox(width: 8),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: EdgeInsets.all(10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Icon(
              Icons.close,
              color: Colors.white,
              size: 30,
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: width * 0.5,
        height: 500,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  getStatusBadge(submission.status),
                  SizedBox(width: 8),
                  Text(
                    "${submission.executionTimeMs} ms, ${submission.memoryUsageKb / 1024} MB",
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Color(0xFF6A737C),
                      fontFamily: 'Arial',
                    ),
                  ),
                ],
              ),
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
                  expanded: true,
                ),
              ),
              SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildTag("Accepted", Color(0xFF48A868), Icons.check_circle),
                  _buildTag("Wrong Answer", Color(0xFFD1383D), Icons.close),
                  _buildTag("Time Limit Exceeded", Color(0xFFFF9800),
                      Icons.timer_off),
                  _buildTag("Runtime Error", Color(0xFF9C27B0), Icons.error),
                  _buildTag("Compilation Error", Colors.blue, Icons.code_off),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTag(String label, Color color, IconData icon) {
    return InkWell(
      onTap: () {
        // Tag selection logic would go here
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: submission.status == label
              ? color.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: color),
            SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 11,
                fontFamily: 'Arial',
              ),
            ),
          ],
        ),
      ),
    );
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
        return Syntax.DART; // Default to Dart syntax
    }
  }

  Widget getStatusBadge(String status) {
    Color badgeColor;
    IconData icon;

    switch (status) {
      case "Accepted":
        badgeColor = Color(0xFF48A868); // Stack overflow green
        icon = Icons.check_circle;
        break;
      case "Wrong Answer":
        badgeColor = Color(0xFFD1383D); // Stack overflow red
        icon = Icons.close;
        break;
      case "Time Limit Exceeded":
        badgeColor = Color(0xFFFF9800); // Orange
        icon = Icons.timer_off;
        break;
      case "Runtime Error":
        badgeColor = Color(0xFF9C27B0); // Purple
        icon = Icons.error;
        break;
      case "Compilation Error":
        badgeColor = Colors.blue; // SO blue
        icon = Icons.code_off;
        break;
      default:
        badgeColor = Color(0xFF6A737C); // SO dark gray
        icon = Icons.question_mark;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(3),
        border: Border.all(color: badgeColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: badgeColor),
          SizedBox(width: 4),
          Text(
            status,
            style: TextStyle(
              color: badgeColor,
              fontWeight: FontWeight.bold,
              fontSize: 11,
              fontFamily: 'Arial',
            ),
          ),
        ],
      ),
    );
  }
}
