import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:competitivecodingarena/AWS/Call_Logic/compiler_call.dart';
import 'package:competitivecodingarena/Core_Project/CodeScreen/Submissions/analyze_complexity.dart';
import 'package:competitivecodingarena/Snackbars&Pbars/snackbars.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class DSARoadmapScreen extends StatefulWidget {
  const DSARoadmapScreen({super.key});

  @override
  _DSARoadmapScreenState createState() => _DSARoadmapScreenState();
}

class _DSARoadmapScreenState extends State<DSARoadmapScreen>
    with SingleTickerProviderStateMixin {
  List<RoadmapStep> steps = [];
  Map<int, Offset> nodePositions = {};
  late AnimationController _animationController;
  bool haveRoadMap = false;
  List mapData = [];
  Future<void>? _dataFuture;
  bool isPremium = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..forward();
    _dataFuture = _loadData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Check if the screen was navigated to with a result
    final bool? shouldReload =
        ModalRoute.of(context)?.settings.arguments as bool?;
    if (shouldReload == true) {
      _dataFuture = _loadData();
    }
  }

  Future<void> _loadData() async {
    try {
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      Map<String, dynamic>? data = docSnapshot.data() as Map<String, dynamic>?;
      if (data != null) {
        setState(() {
          isPremium = data['isPremium'] ?? false;
          if (data['roadmap'] != null) {
            haveRoadMap = true;
            mapData = List<Map<String, dynamic>>.from(data['roadmap']);
            steps = _initializeSteps();
          } else {
            haveRoadMap = false;
          }
        });
      }
    } on FirebaseException catch (e) {
      print(e.code);
    }
  }

  void refreshData() {
    setState(() {
      _dataFuture = _loadData();
    });
  }

  List<RoadmapStep> _initializeSteps() {
    List<Map<String, dynamic>> roadmapWithProgress =
        List<Map<String, dynamic>>.from(mapData);

    List<Color> colors = [
      Colors.red,
      Colors.orange,
      Colors.yellow,
      Colors.green,
      Colors.blue,
      Colors.indigo,
      Colors.purple,
      Colors.blue,
      Colors.teal,
      Colors.cyan
    ];

    List<RoadmapStep> steps = [];

    for (int i = 0; i < roadmapWithProgress.length; i++) {
      List<int> children = [];
      if (i == 0) {
        children = [2, 3];
      } else if (i == 1) {
        children = [4, 5];
      } else if (i == 2) {
        children = [6, 7];
      } else if (i == 5) {
        children = [8, 9];
      } else if (i == 6) {
        children = [10];
      }

      steps.add(RoadmapStep(
        i + 1,
        roadmapWithProgress[i]['title'],
        colors[i % colors.length],
        children,
        roadmapWithProgress[i]['progress'].toDouble(),
      ));
    }

    return steps;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _dataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return haveRoadMap
              ? SizedBox(
                  height: MediaQuery.of(context).size.height * 0.85,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      nodePositions.clear();
                      _calculatePositions(1, 0, constraints.maxWidth * 0.1,
                          constraints.maxWidth * 0.9, constraints.maxHeight);
                      return Stack(
                        children: [
                          CustomPaint(
                            size: Size(
                                constraints.maxWidth, constraints.maxHeight),
                            painter:
                                HierarchicalTreePainter(steps, nodePositions),
                          ),
                          ...steps.map((step) {
                            final position = nodePositions[step.number]!;
                            return AnimatedPositioned(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                              left: position.dx - 40,
                              top: position.dy - 40,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => ProblemsScreen(
                                        topic: step.title,
                                      ),
                                    ),
                                  );
                                },
                                child: NodeWidget(step: step),
                              ),
                            );
                          }),
                        ],
                      );
                    },
                  ),
                )
              : Stack(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.85,
                      child: Center(
                        child: Card(
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.map_outlined,
                                    size: 80, color: Colors.blue),
                                const SizedBox(height: 20),
                                const Text(
                                  "Create Your Coding Road-Map",
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "Embark on your coding journey with a personalized RoadMap",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.grey[600]),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 30),
                                ElevatedButton(
                                  onPressed: isPremium
                                      ? () async {
                                          showCircularbar(context);
                                          try {
                                            Map<String, dynamic> getdata =
                                                await invokeLambdaFunction();
                                            Map<String, dynamic> body =
                                                jsonDecode(getdata['body']);
                                            List<dynamic> programmingRoadmap =
                                                body['programming_roadmap'];
                                            List<Map<String, dynamic>>
                                                roadmapWithProgress =
                                                programmingRoadmap.map((step) {
                                              return {
                                                'title': step,
                                                'progress': 0,
                                              };
                                            }).toList();
                                            await FirebaseFirestore.instance
                                                .collection('users')
                                                .doc(FirebaseAuth
                                                    .instance.currentUser!.uid)
                                                .update({
                                              "roadmap": roadmapWithProgress
                                            });
                                            Navigator.of(context).pop();
                                            refreshData();
                                          } catch (e) {
                                            print(
                                                "Error invoking Lambda function: $e");
                                          }
                                        }
                                      : null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        isPremium ? Colors.blue : Colors.grey,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30, vertical: 15),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  child: Text(
                                    isPremium
                                        ? "Create Roadmap"
                                        : "Premium Feature",
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (!isPremium)
                      Positioned.fill(
                        child: Container(
                          color: Colors.black.withOpacity(0.3),
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.all(30),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade900,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.lock,
                                      size: 80, color: Colors.blue),
                                  const SizedBox(height: 20),
                                  const Text(
                                    "Premium Feature",
                                    style: TextStyle(
                                      fontSize: 24,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  const Text(
                                    "Unlock personalized coding roadmaps\nwith our Premium subscription!",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  ElevatedButton(
                                    onPressed: () {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Navigate to Premium upgrade screen'),
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 15),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                    child: const Text(
                                      "Upgrade to Premium",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                );
        }
      },
    );
  }

  void _calculatePositions(int stepIndex, int level, double leftBound,
      double rightBound, double height) {
    final step = steps[stepIndex - 1];
    final verticalSpacing = height / (steps.length * 0.5);
    final y = verticalSpacing * (level + 1);

    final availableWidth = rightBound - leftBound;
    final childCount = step.children.length;
    final x = leftBound + availableWidth / 2;

    nodePositions[step.number] = Offset(x, y);

    if (childCount > 0) {
      final childWidth = availableWidth / childCount;
      for (int i = 0; i < childCount; i++) {
        final childLeftBound = leftBound + i * childWidth;
        final childRightBound = childLeftBound + childWidth;
        _calculatePositions(step.children[i], level + 1, childLeftBound,
            childRightBound, height);
      }
    }
  }
}

class NodeWidget extends StatelessWidget {
  final RoadmapStep step;

  const NodeWidget({required this.step, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [step.currentColor, step.currentColor.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: step.currentColor.withOpacity(0.5),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 4),
            Text(
              step.title,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}

class RoadmapStep {
  final int number;
  final String title;
  final Color originalColor;
  Color currentColor;
  final List<int> children;
  double progress;

  RoadmapStep(
      this.number, this.title, this.originalColor, this.children, this.progress)
      : currentColor = originalColor;
}

class HierarchicalTreePainter extends CustomPainter {
  final List<RoadmapStep> steps;
  final Map<int, Offset> nodePositions;

  HierarchicalTreePainter(this.steps, this.nodePositions);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    void drawBranch(Offset start, Offset end) {
      final controlPoint1 =
          Offset(start.dx, start.dy + (end.dy - start.dy) * 0.7);
      final controlPoint2 =
          Offset(end.dx, start.dy + (end.dy - start.dy) * 0.3);

      final path = Path()
        ..moveTo(start.dx, start.dy)
        ..cubicTo(
          controlPoint1.dx,
          controlPoint1.dy,
          controlPoint2.dx,
          controlPoint2.dy,
          end.dx,
          end.dy,
        );
      canvas.drawPath(path, paint);
    }

    for (var step in steps) {
      for (var childNumber in step.children) {
        drawBranch(nodePositions[step.number]!, nodePositions[childNumber]!);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class GeminiService {
  static final model = GenerativeModel(
    model: 'gemini-pro',
    apiKey: apiKey,
  );

  static Future<List<Map<String, dynamic>>> getProblemsForTopic(
      String topic) async {
    try {
      final prompt = '''
Generate 5 programming problems for the topic: $topic
For each problem, provide:
- A title
- Difficulty level (Easy, Medium, or Hard)
- Description of the problem
- Example input
- Example output
- Constraints

Format the response as a JSON array with objects containing these fields:
title, difficulty, description, exampleInput, exampleOutput, constraints
''';

      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);
      final responseText = response.text;

      // Parse the response text as JSON
      try {
        // Since the response might include markdown or other formatting,
        // we need to extract just the JSON part
        final jsonString = responseText?.substring(
          responseText.indexOf('['),
          responseText.lastIndexOf(']') + 1,
        );

        final List<dynamic> jsonList = json.decode(jsonString!);
        return jsonList.cast<Map<String, dynamic>>();
      } catch (e) {
        print('JSON parsing error: $e');
        print('Response text: $responseText');
        throw const FormatException('Failed to parse AI response as JSON');
      }
    } catch (e) {
      print('Error generating problems: $e');
      throw Exception('Failed to generate problems: $e');
    }
  }
}

class ProblemsScreen extends StatefulWidget {
  final String topic;

  const ProblemsScreen({super.key, required this.topic});

  @override
  _ProblemsScreenState createState() => _ProblemsScreenState();
}

class _ProblemsScreenState extends State<ProblemsScreen> {
  late Future<List<Map<String, dynamic>>> _problemsFuture;

  @override
  void initState() {
    super.initState();
    _problemsFuture = GeminiService.getProblemsForTopic(widget.topic);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.topic} Problems'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _problemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Fetching the list of Problems...'),
                ],
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error generating problems:\n${snapshot.error}',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _problemsFuture =
                            GeminiService.getProblemsForTopic(widget.topic);
                      });
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final problems = snapshot.data ?? [];
          if (problems.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.warning_amber_rounded,
                      size: 48, color: Colors.orange),
                  const SizedBox(height: 16),
                  const Text('No problems generated for this topic'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _problemsFuture =
                            GeminiService.getProblemsForTopic(widget.topic);
                      });
                    },
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: problems.length,
            itemBuilder: (context, index) {
              final problem = problems[index];
              return Card(
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 16),
                child: ExpansionTile(
                  title: Text(
                    problem['title'] ?? '',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Row(
                    children: [
                      _buildDifficultyIndicator(problem['difficulty']),
                      const SizedBox(width: 8),
                      Text(widget.topic),
                    ],
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Description:',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(problem['description'] ?? ''),
                          const SizedBox(height: 16),
                          Text(
                            'Example Input:',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.grey[700],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(problem['exampleInput'] ?? ''),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Example Output:',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.grey[700],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(problem['exampleOutput'] ?? ''),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Constraints:',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(problem['constraints'] ?? ''),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                onPressed: () {},
                                child: const Text('Solve Problem'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildDifficultyIndicator(String? difficulty) {
    Color color;
    switch (difficulty?.toLowerCase()) {
      case 'easy':
        color = Colors.green;
        break;
      case 'medium':
        color = Colors.orange;
        break;
      case 'hard':
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(
        difficulty ?? 'N/A',
        style: TextStyle(color: color, fontSize: 12),
      ),
    );
  }
}
