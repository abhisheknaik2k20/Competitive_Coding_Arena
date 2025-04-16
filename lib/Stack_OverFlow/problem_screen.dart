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
  bool _isLoading = true;
  Problem? _problem;
  String? _errorMessage;
  @override
  void initState() {
    super.initState();
    problem_id = widget.stflow_instance.problem_title
        .replaceAll(RegExp(r'[^\w\s]'), '')
        .replaceAll(RegExp(r'\s+'), '_')
        .toLowerCase();
    _updateViews();
    if (widget.stflow_instance.category != 'DSA') {
      setState(() => _isLoading = false);
    }
    if (_isLoading) _fetchProblem();
  }

  Future<void> _updateViews() async {
    try {
      await FirebaseFirestore.instance
          .collection('stack_overflow_problems')
          .doc(problem_id)
          .update({'views': FieldValue.increment(1)});
    } catch (e) {}
  }

  Future<void> _fetchProblem() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final String problemId = widget.stflow_instance.problem_id.toString();
      final DocumentSnapshot problemDoc = await FirebaseFirestore.instance
          .collection('problems')
          .doc(problemId)
          .get();
      if (problemDoc.exists) {
        setState(() {
          _problem = Problem.fromFirestore(problemDoc);
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Problem not found';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading problem: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  Widget _buildProblemContent(double height, double width) {
    if (_isLoading) {
      return SizedBox(
          height: height * 0.5,
          child: const Center(child: CircularProgressIndicator()));
    }
    if (_errorMessage != null) {
      return SizedBox(
          height: height * 0.5,
          child: Center(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(_errorMessage!, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _fetchProblem, child: const Text('Retry'))
          ])));
    }

    return Column(
      children: [
        const Divider(),
        ProblemTitle(
            name: widget.stflow_instance.name,
            timestamp: widget.stflow_instance.time_stamp,
            height: height,
            width: width,
            title: widget.stflow_instance.problem_title,
            tags: widget.stflow_instance.tags),
        const Divider(),
        ProblemDescription(
            upvotes: widget.stflow_instance.upvotes,
            downvotes: widget.stflow_instance.downvotes,
            height: height,
            width: width,
            description: widget.stflow_instance.problem_description,
            code: widget.stflow_instance.code,
            language: widget.stflow_instance.syntax),
        const Divider(),
        _problem != null
            ? ProblemStatement(
                height: height,
                width: width,
                problem: _problem!,
              )
            : Container(),
        const Divider()
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
        body: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          InvisibleSpacer(width: width),
          Expanded(
              child: SingleChildScrollView(
                  child: _buildProblemContent(height, width))),
          LiveSubmissions(width: width, docref: problem_id)
        ]),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
          child: const Icon(Icons.add, color: Colors.white),
          onPressed: () => showDialog(
              context: context,
              builder: (context) => SubmitSolutionScreen(
                  stflow_instance: widget.stflow_instance)),
        ));
  }
}

class InvisibleSpacer extends StatelessWidget {
  final double width;
  const InvisibleSpacer({required this.width, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.all(20),
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
