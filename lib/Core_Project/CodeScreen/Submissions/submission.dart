import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:competitivecodingarena/Core_Project/CodeScreen/Submissions/analyze_complexity.dart';
import 'package:competitivecodingarena/Core_Project/CodeScreen/Submissions/pie_chart.dart';
import 'package:competitivecodingarena/Core_Project/CodeScreen/Submissions/runtime_dist.dart';
import 'package:competitivecodingarena/Core_Project/CodeScreen/Submissions/solution_list.dart';
import 'package:dev_icons/dev_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:competitivecodingarena/Core_Project/Problemset/examples/exampleprobs.dart';
import 'package:flutter_syntax_view/flutter_syntax_view.dart';

class Submissions extends StatefulWidget {
  final Problem problem;
  const Submissions({super.key, required this.problem});
  @override
  State<Submissions> createState() => _SubmissionsState();
}

class _SubmissionsState extends State<Submissions>
    with SingleTickerProviderStateMixin {
  bool isLoading = true;
  bool noSolutionsAvailable = false;
  String selectedCategory = "Python";
  Syntax selectedSyntax = Syntax.DART;
  double _pythonPercentage = 0.0;
  double _javaPercentage = 0.0;
  double _cppPercentage = 0.0;
  List<QueryDocumentSnapshot> pythonSolutions = [];
  List<QueryDocumentSnapshot> javaSolutions = [];
  List<QueryDocumentSnapshot> cppSolutions = [];

  String? userPythonSolution;
  String? userJavaSolution;
  String? userCppSolution;

  @override
  void initState() {
    super.initState();
    _fetchAllSolutionCounts();
  }

  Future<void> _fetchAllSolutionCounts() async {
    try {
      String currentUserId = FirebaseAuth.instance.currentUser!.displayName!;

      var pythonQuery = await FirebaseFirestore.instance
          .collection("problems")
          .doc(widget.problem.id)
          .collection("python solutions")
          .orderBy("executionTime")
          .get();

      var javaQuery = await FirebaseFirestore.instance
          .collection("problems")
          .doc(widget.problem.id)
          .collection("java solutions")
          .orderBy("executionTime")
          .get();

      var cppQuery = await FirebaseFirestore.instance
          .collection("problems")
          .doc(widget.problem.id)
          .collection("cpp solutions")
          .orderBy("executionTime")
          .get();

      setState(() {
        pythonSolutions = pythonQuery.docs;
        javaSolutions = javaQuery.docs;
        cppSolutions = cppQuery.docs;

        int total =
            pythonSolutions.length + javaSolutions.length + cppSolutions.length;
        _pythonPercentage =
            total > 0 ? (pythonSolutions.length / total) * 100 : 0;
        _javaPercentage = total > 0 ? (javaSolutions.length / total) * 100 : 0;
        _cppPercentage = total > 0 ? (cppSolutions.length / total) * 100 : 0;

        userPythonSolution = pythonSolutions
            .cast<QueryDocumentSnapshot<Map<String, dynamic>>>()
            .firstWhere((doc) => doc.data()['name'] == currentUserId)
            .data()['solution'];
        userJavaSolution = javaSolutions
            .cast<QueryDocumentSnapshot<Map<String, dynamic>>>()
            .firstWhere((doc) => doc.data()['name'] == currentUserId)
            .data()['solution'];
        userCppSolution = cppSolutions
            .cast<QueryDocumentSnapshot<Map<String, dynamic>>>()
            .firstWhere(
              (doc) => doc.data()['name'] == currentUserId,
            )
            .data()['solution'];

        isLoading = false;
        noSolutionsAvailable = total == 0;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        noSolutionsAvailable = true;
      });
    }
  }

  List<QueryDocumentSnapshot> get currentSolutions {
    switch (selectedCategory) {
      case "Python":
        return pythonSolutions;
      case "Java":
        return javaSolutions;
      case "Cpp":
        return cppSolutions;
      default:
        return [];
    }
  }

  String? get currentUserSolution {
    switch (selectedCategory) {
      case "Python":
        return userPythonSolution;
      case "Java":
        return userJavaSolution;
      case "Cpp":
        return userCppSolution;
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [SegmentedButton()],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.pink))
          : SizedBox(
              height: MediaQuery.sizeOf(context).height,
              width: MediaQuery.sizeOf(context).width,
              child: Row(
                children: [
                  Expanded(
                      child: Container(
                    padding: const EdgeInsets.all(5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                            decoration: BoxDecoration(
                                color: Colors.teal.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                                border:
                                    Border.all(color: Colors.white, width: 2)),
                            height: MediaQuery.sizeOf(context).height * 0.35,
                            child: BuildPieChart(
                              cppPercentage: _cppPercentage,
                              javaPercentage: _javaPercentage,
                              pythonPercentage: _pythonPercentage,
                            )),
                        SizedBox(
                          height: MediaQuery.sizeOf(context).height * 0.5,
                          child: SolutionList(
                            solutions: currentSolutions,
                            currentUserId:
                                FirebaseAuth.instance.currentUser!.displayName!,
                            selectedSyntax: selectedSyntax,
                          ),
                        ),
                      ],
                    ),
                  )),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          RuntimeDistributionChart(
                            solutions: currentSolutions,
                            selectedCategory: selectedCategory,
                          ),
                          AnalyzeComplexity(
                            key: ValueKey(selectedCategory),
                            providedCode: currentUserSolution,
                            syntax: selectedSyntax,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget SegmentedButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(7),
        child: Material(
          color: Colors.transparent,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildSegmentButton('Python', 0, DevIcons.pythonPlain),
              _buildSegmentButton('Java', 1, DevIcons.javaPlain),
              _buildSegmentButton('C++', 2, DevIcons.cplusplusPlain),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSegmentButton(String label, int index, IconData icon) {
    bool isSelected = selectedCategory == _getCategoryName(index);
    return InkWell(
      onTap: () {
        if (selectedCategory != _getCategoryName(index)) {
          setState(() {
            selectedCategory = _getCategoryName(index);
            selectedSyntax = _getSyntax(index);
          });
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [Colors.pink.shade400, Colors.pink.shade600],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isSelected ? null : Colors.grey.shade800,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.grey.shade300,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey.shade300,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getCategoryName(int index) {
    switch (index) {
      case 0:
        return "Python";
      case 1:
        return "Java";
      case 2:
        return "Cpp";
      default:
        return "All";
    }
  }

  Syntax _getSyntax(int index) {
    switch (index) {
      case 0:
        return Syntax.DART;
      case 1:
        return Syntax.JAVA;
      case 2:
        return Syntax.CPP;
      default:
        return Syntax.DART;
    }
  }
}
