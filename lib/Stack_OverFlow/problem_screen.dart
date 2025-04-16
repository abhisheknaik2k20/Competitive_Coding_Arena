import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:competitivecodingarena/Core_Project/Problemset/examples/exampleprobs.dart';
import 'package:competitivecodingarena/Stack_OverFlow/COMMAN_SCREENS/live_submissions.dart';
import 'package:competitivecodingarena/Stack_OverFlow/COMMAN_SCREENS/problem_description.dart';
import 'package:competitivecodingarena/Stack_OverFlow/COMMAN_SCREENS/problem_statement.dart';
import 'package:competitivecodingarena/Stack_OverFlow/COMMAN_SCREENS/problem_title.dart';
import 'package:competitivecodingarena/Stack_OverFlow/DIALOG/submit_solution.dart';
import 'package:competitivecodingarena/Stack_OverFlow/problem_class.dart';
import 'package:flutter/material.dart';

class ProblemScreen extends StatefulWidget {
  final StackOverFlowProblemClass stflow_instance;
  const ProblemScreen({required this.stflow_instance, super.key});

  @override
  State<ProblemScreen> createState() => _ProblemScreenState();
}

class _ProblemScreenState extends State<ProblemScreen> {
  late final String problem_id;

  @override
  void initState() {
    super.initState();
    problem_id = widget.stflow_instance.problem_title
        .replaceAll(RegExp(r'[^\w\s]'), '')
        .replaceAll(RegExp(r'\s+'), '_')
        .toLowerCase();
    _updateViews();
  }

  Future<void> _updateViews() async {
    await FirebaseFirestore.instance
        .collection('stack_overflow_problems')
        .doc(problem_id)
        .update({'views': FieldValue.increment(1)});
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        InvisibleSpacer(width: width),
        SingleChildScrollView(
            child: Column(children: [
          Divider(),
          ProblemTitle(
              name: widget.stflow_instance.name,
              timestamp: widget.stflow_instance.time_stamp,
              height: height,
              width: width,
              title: widget.stflow_instance.problem_title,
              tags: widget.stflow_instance.tags),
          Divider(),
          ProblemDescription(
              upvotes: widget.stflow_instance.upvotes,
              downvotes: widget.stflow_instance.downvotes,
              height: height,
              width: width,
              description: widget.stflow_instance.problem_description,
              code: widget.stflow_instance.code,
              language: widget.stflow_instance.syntax),
          Divider(),
          widget.stflow_instance.problem_id == null
              ? Container()
              : ProblemStatement(
                  height: height,
                  width: width,
                  problem:
                      problemexample[widget.stflow_instance.problem_id ?? 0]),
          Divider(),
        ])),
        LiveSubmissions(width: width, docref: problem_id)
      ]),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: Icon(Icons.add, color: Colors.white),
        onPressed: () => showDialog(
            context: context,
            builder: (context) => SubmitSolutionScreen(
                  stflow_instance: widget.stflow_instance,
                )),
      ),
    );
  }
}

class InvisibleSpacer extends StatelessWidget {
  final double width;
  const InvisibleSpacer({required this.width, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.topLeft,
        padding: EdgeInsets.all(20),
        width: width * 0.08,
        child: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.arrow_back_rounded,
                size: 45,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.blue)));
  }
}
