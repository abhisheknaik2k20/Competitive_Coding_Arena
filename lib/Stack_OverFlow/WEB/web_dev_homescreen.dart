import 'package:competitivecodingarena/Stack_OverFlow/DSA/dsa_screen.dart';
import 'package:competitivecodingarena/Stack_OverFlow/DSA/live_submissions.dart';
import 'package:competitivecodingarena/Stack_OverFlow/DSA/problem_description.dart';
import 'package:competitivecodingarena/Stack_OverFlow/DSA/problem_title.dart';
import 'package:competitivecodingarena/Stack_OverFlow/problem_class.dart';
import 'package:flutter/material.dart';

class WebDevHomescreen extends StatelessWidget {
  final StackOverFlowProblemClass stflow_instance;
  const WebDevHomescreen({required this.stflow_instance, super.key});

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
                        title: stflow_instance.problem_title),
                    Divider(),
                    ProblemDescription(
                      height: height,
                      width: width,
                      description: stflow_instance.problem_description,
                      code: stflow_instance.code,
                      language: stflow_instance.syntax,
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
