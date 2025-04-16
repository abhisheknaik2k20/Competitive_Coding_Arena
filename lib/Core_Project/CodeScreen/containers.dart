import 'package:competitivecodingarena/Core_Project/CodeScreen/providers.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:highlight/languages/python.dart';
import 'package:highlight/languages/cpp.dart';
import 'package:highlight/languages/java.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:competitivecodingarena/AWS/compiler_call.dart';
import 'package:competitivecodingarena/Core_Project/Problemset/examples/exampleprobs.dart';

class AppStyles {
  static const TextStyle consoleText =
      TextStyle(color: Colors.white, fontFamily: 'Courier');
  static const TextStyle defaultText =
      TextStyle(fontSize: 16, color: Colors.white);
  static BoxDecoration containerDecoration({double opacity = 0.1}) =>
      BoxDecoration(
          color: Colors.white.withOpacity(opacity),
          borderRadius: const BorderRadius.all(Radius.circular(10)));

  static Color getColor(String? colorName) {
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
}

class Texteditor extends ConsumerStatefulWidget {
  final Problem problem;
  final TextEditingController textEditingController;

  const Texteditor(
      {required this.problem, required this.textEditingController, super.key});

  @override
  ConsumerState<Texteditor> createState() => _TexteditorState();
}

class _TexteditorState extends ConsumerState<Texteditor> {
  String selectedLanguage = 'python';
  late CodeController controller;
  late FirebaseFirestore _firebaseFirestore;
  late String _authid;
  late String _authname;

  @override
  void initState() {
    super.initState();
    controller = CodeController(language: python);
    _firebaseFirestore = FirebaseFirestore.instance;
    _authid = FirebaseAuth.instance.currentUser!.uid;
    _authname = FirebaseAuth.instance.currentUser!.displayName ?? "Guest";
  }

  void updateLanguage(String? newLanguage) {
    if (newLanguage != null) {
      setState(() {
        selectedLanguage = newLanguage;
        controller.language = getLanguage(newLanguage);
      });
    }
  }

  getLanguage(String lang) {
    switch (lang) {
      case 'cpp':
        return cpp;
      case 'java':
        return java;
      case 'python':
      default:
        return python;
    }
  }

  setSolution(Map<String, dynamic> data, String solution) async {
    data['solution'] = solution;
    data['name'] = _authname;
    _firebaseFirestore
        .collection("problems")
        .doc(widget.problem.id)
        .collection("$selectedLanguage solutions")
        .doc(_authid)
        .get()
        .then((docSnapshot) {
      if (docSnapshot.exists) {
        return docSnapshot.reference.update(data);
      } else {
        return docSnapshot.reference.set(data);
      }
    }).catchError((error) {
      print("Error updating/creating document: $error");
    });
  }

  bool hasCompilerError(Map result) {
    String body = result['body'].toString().toLowerCase();
    final List<String> errorIndicators = [
      'error:',
      'syntaxerror',
      'stderr:',
      'execution error:',
      'invalid syntax'
    ];
    return errorIndicators
        .any((indicator) => body.contains(indicator.toLowerCase()));
  }

  @override
  Widget build(BuildContext context) => Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          ElevatedButton(
              onPressed: () async {
                String program = controller.text;
                ref.read(consoleProvider.state).state = "Running.....";
                Map result = await callCompiler(
                    context, selectedLanguage, controller.text);
                if (hasCompilerError(result)) {
                  ref.read(consoleProvider.state).state =
                      "Error: ${result['body']}";
                } else {
                  ref.read(consoleProvider.state).state =
                      result['body'].toString();
                  setSolution(result["body"], program);
                }
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2CBB5D),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
              child: const Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.play_arrow, size: 18),
                SizedBox(width: 4),
                Text("Run",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold))
              ])),
          const SizedBox(width: 20),
          DropdownButton<String>(
              value: selectedLanguage,
              items: <String>['cpp', 'java', 'python'].map((String value) {
                return DropdownMenuItem<String>(
                    value: value, child: Text(value));
              }).toList(),
              onChanged: updateLanguage)
        ]),
        SizedBox(
            width: 1000,
            child: CodeTheme(
                data: CodeThemeData(styles: monokaiSublimeTheme),
                child: SingleChildScrollView(
                    child: CodeField(controller: controller))))
      ]);
}

class Console extends ConsumerWidget {
  const Console({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final result = ref.watch(consoleProvider);
    return SizedBox(
        child: SingleChildScrollView(
            child: Text(result, style: AppStyles.consoleText)));
  }
}

class ProblemRenderer {
  static RichText problemToRichText(Problem problem) {
    List<TextSpan> textSpans = [];
    for (var content in problem.content) {
      TextStyle style = TextStyle(
          fontSize: (content['fontSize'] as num?)?.toDouble() ?? 16,
          color: AppStyles.getColor(content['color']),
          fontWeight:
              content['isBold'] == true ? FontWeight.bold : FontWeight.normal,
          fontStyle: content['isItalic'] == true
              ? FontStyle.italic
              : FontStyle.normal);

      textSpans.add(TextSpan(text: content['text'] as String, style: style));
    }
    return RichText(
        text: TextSpan(style: AppStyles.defaultText, children: textSpans));
  }
}

class Testcase extends StatefulWidget {
  final Problem problem;
  const Testcase({super.key, required this.problem});
  @override
  State<Testcase> createState() => _TestcaseState();
}

class _TestcaseState extends State<Testcase> {
  var index = 0;
  @override
  Widget build(BuildContext context) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  for (int i = 1; i <= widget.problem.testcases.length; i++)
                    Padding(
                        padding: const EdgeInsets.only(right: 40),
                        child: InkWell(
                            onTap: () => setState(() => index = i - 1),
                            child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.white.withOpacity(0.3),
                                        width: 2),
                                    color: index + 1 == i
                                        ? Colors.white.withOpacity(0.4)
                                        : Colors.white.withOpacity(0.1),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10))),
                                child: Text(" case $i ")))),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.add))
                ])),
        const SizedBox(height: 20),
        _buildTestCase(widget.problem.testcases[index])
      ]);

  Widget _buildTestCase(Map<String, dynamic> testcase) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(testcase['title'],
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        const SizedBox(height: 8),
        _buildTestCaseSection('Input', testcase['input'], Colors.cyan),
        const SizedBox(height: 4),
        _buildTestCaseSection('Output', testcase['output'], Colors.orange),
        const SizedBox(height: 4),
        _buildTestCaseSection('Explanation', testcase['explain'], Colors.lime)
      ]);

  Widget _buildTestCaseSection(
          String title, String content, Color titleColor) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: TextStyle(color: titleColor)),
        Container(
            padding: const EdgeInsets.all(10),
            decoration: AppStyles.containerDecoration(),
            child: Text(content))
      ]);
}

class SubmissionGraphPage extends StatelessWidget {
  final String problemId;
  final String language;
  final String name;

  const SubmissionGraphPage(
      {super.key,
      required this.problemId,
      required this.language,
      required this.name});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<GraphData>(
        future: fetchSubmissionData(problemId, language, name),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.submissions.isEmpty) {
            return const Center(child: Text('No submission data available.'));
          }
          return Center(child: SubmissionGraph(data: snapshot.data!));
        });
  }

  Future<GraphData> fetchSubmissionData(
      String problemId, String language, String userId) async {
    final submissionsSnapshot = await FirebaseFirestore.instance
        .collection("problems")
        .doc(problemId)
        .collection("${language.toLowerCase()} solutions")
        .get();
    List<double> runtimes = [];
    double? userRuntime;
    for (var doc in submissionsSnapshot.docs) {
      double executionTime = double.parse(doc['executionTime'].toString());
      runtimes.add(executionTime);
      if (doc['name'] == userId) {
        userRuntime = executionTime;
      }
    }
    runtimes.sort((a, b) => a.compareTo(b));
    int totalSubmissions = runtimes.length;
    List<SubmissionData> distributionData = [];
    for (int i = 0; i <= 100; i += 2) {
      int index = (i / 100 * totalSubmissions).round();
      if (index < totalSubmissions) {
        distributionData.add(
            SubmissionData(runtime: runtimes[index], percentile: i.toDouble()));
      }
    }
    double userPercentile = userRuntime != null
        ? (runtimes.indexOf(userRuntime) / totalSubmissions) * 100
        : -1;
    return GraphData(
        submissions: distributionData,
        userRuntime: userRuntime,
        userPercentile: userPercentile);
  }
}

class SubmissionGraph extends StatelessWidget {
  final GraphData data;
  const SubmissionGraph({super.key, required this.data});

  @override
  Widget build(BuildContext context) => CustomPaint(
      size: const Size(300, 200), painter: SubmissionGraphPainter(data: data));
}

class SubmissionGraphPainter extends CustomPainter {
  final GraphData data;
  SubmissionGraphPainter({required this.data});

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()
      ..color = const Color(0xFF1E1E1E)
      ..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    final axisPaint = Paint()
      ..color = Colors.grey[700]!
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final barPaint = Paint()
      ..color = Colors.blue[700]!
      ..style = PaintingStyle.fill;

    final userBarPaint = Paint()
      ..color = Colors.blue[300]!
      ..style = PaintingStyle.fill;
    canvas.drawLine(
        Offset(0, size.height), Offset(size.width, size.height), axisPaint);
    canvas.drawLine(Offset(0, size.height), const Offset(0, 0), axisPaint);
    if (data.submissions.isEmpty) return;
    double barWidth = size.width / (data.submissions.length * 1.2);
    double spacing = barWidth * 0.2;
    for (int i = 0; i < data.submissions.length; i++) {
      double x = i * (barWidth + spacing);
      double barHeight =
          (data.submissions[i].runtime / data.submissions.last.runtime) *
              size.height;
      Rect barRect =
          Rect.fromLTWH(x, size.height - barHeight, barWidth, barHeight);
      canvas.drawRect(barRect, barPaint);
    }
    if (data.userRuntime != null && data.userPercentile >= 0) {
      int userIndex =
          (data.userPercentile / 100 * data.submissions.length).round();
      double x = userIndex * (barWidth + spacing);
      double barHeight =
          (data.userRuntime! / data.submissions.last.runtime) * size.height;
      Rect userBarRect =
          Rect.fromLTWH(x, size.height - barHeight, barWidth, barHeight);
      canvas.drawRect(userBarRect, userBarPaint);
    }
    const textStyle = TextStyle(color: Colors.white, fontSize: 10);
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    for (int i = 0; i <= 4; i++) {
      final runtime =
          (i * data.submissions.last.runtime / 4).toStringAsFixed(0);
      textPainter.text = TextSpan(text: '${runtime}ms', style: textStyle);
      textPainter.layout();
      textPainter.paint(
          canvas, Offset(-35, size.height - (i / 4 * size.height) - 5));
    }
    for (int i = 0; i <= 4; i++) {
      final percentile = (i * 25).toString();
      textPainter.text = TextSpan(text: '$percentile%', style: textStyle);
      textPainter.layout();
      textPainter.paint(
          canvas, Offset((i / 4) * size.width - 10, size.height + 5));
    }
    if (data.userPercentile >= 0) {
      textPainter.text = TextSpan(
          text:
              'Your runtime: ${data.userRuntime!.toStringAsFixed(0)}ms (${data.userPercentile.toStringAsFixed(2)} percentile)',
          style: const TextStyle(
              color: Colors.blue, fontSize: 12, fontWeight: FontWeight.bold));
      textPainter.layout();
      textPainter.paint(canvas, const Offset(10, 10));
    }
  }

  @override
  bool shouldRepaint(covariant SubmissionGraphPainter oldDelegate) =>
      oldDelegate.data != data;
}

class GraphData {
  final List<SubmissionData> submissions;
  final double? userRuntime;
  final double userPercentile;
  GraphData(
      {required this.submissions,
      this.userRuntime,
      required this.userPercentile});
}

class SubmissionData {
  final double runtime;
  final double percentile;

  SubmissionData({required this.runtime, required this.percentile});
}
