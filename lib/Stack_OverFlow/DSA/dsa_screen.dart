import 'package:competitivecodingarena/Core_Project/Problemset/examples/exampleprobs.dart';
import 'package:competitivecodingarena/Stack_OverFlow/DSA/live_submissions.dart';
import 'package:competitivecodingarena/Stack_OverFlow/DSA/problem_description.dart';
import 'package:competitivecodingarena/Stack_OverFlow/DSA/problem_statement.dart';
import 'package:competitivecodingarena/Stack_OverFlow/DSA/problem_title.dart';
import 'package:competitivecodingarena/Stack_OverFlow/problem_class.dart';
import 'package:flutter/material.dart';

class DSAScreen extends StatefulWidget {
  final StackOverFlowProblemClass stflow_instance;
  const DSAScreen({required this.stflow_instance, super.key});

  @override
  State<DSAScreen> createState() => _DSAScreenState();
}

class _DSAScreenState extends State<DSAScreen> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          InvisibleSpacer(width: width),
          SingleChildScrollView(
            child: Column(
              children: [
                Divider(),
                ProblemTitle(
                    height: height,
                    width: width,
                    title: widget.stflow_instance.problem_title),
                Divider(),
                ProblemDescription(
                  height: height,
                  width: width,
                  description: widget.stflow_instance.problem_description,
                  code: widget.stflow_instance.code,
                  language: widget.stflow_instance.syntax,
                ),
                Divider(),
                ProblemStatement(
                  height: height,
                  width: width,
                  problem:
                      problemexample[widget.stflow_instance.problem_id ?? 0],
                ),
                Divider(),
              ],
            ),
          ),
          LiveSubmissions(width: width)
        ],
      ),
    );
  }
}

class InvisibleSpacer extends StatelessWidget {
  final double width;
  const InvisibleSpacer({required this.width, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(width: width * 0.08);
  }
}
