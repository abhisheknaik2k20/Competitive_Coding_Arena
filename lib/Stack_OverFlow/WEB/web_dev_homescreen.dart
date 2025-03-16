import 'package:competitivecodingarena/Stack_OverFlow/DSA/dsa_screen.dart';
import 'package:competitivecodingarena/Stack_OverFlow/DSA/live_submissions.dart';
import 'package:competitivecodingarena/Stack_OverFlow/DSA/problem_description.dart';
import 'package:competitivecodingarena/Stack_OverFlow/DSA/problem_title.dart';
import 'package:competitivecodingarena/Stack_OverFlow/WEB/react_code_snippets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_syntax_view/flutter_syntax_view.dart';

class WebDevHomescreen extends StatelessWidget {
  const WebDevHomescreen({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    double width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      body: SizedBox(
        height: height,
        width: width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InvisibleSpacer(width: width),
            ScrollConfiguration(
              behavior:
                  ScrollConfiguration.of(context).copyWith(scrollbars: false),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Divider(),
                    ProblemTitle(
                        height: height,
                        width: width,
                        title: "This is a web-dev Problem to-FIX"),
                    Divider(),
                    ProblemDescription(
                      height: height,
                      width: width,
                      description: '''
The goal is to implement an efficient state management strategy using React's Context API, Redux, or an alternative solution like Zustand, Jotai, or Recoil. The solution should minimize unnecessary re-renders, provide a clear separation of concerns, and ensure a seamless data flow across components.

Would you like me to add code snippets or suggest a specific approach based on your project’s needs? 
                        ''',
                      code: reactcode_snippets[0],
                      language: Syntax.JAVASCRIPT,
                    ),
                    Divider(),
                  ],
                ),
              ),
            ),
            LiveSubmissions(width: width)
          ],
        ),
      ),
    );
  }
}
