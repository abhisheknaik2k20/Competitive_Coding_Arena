import 'package:competitivecodingarena/Stack_OverFlow/COMMAN_SCREENS/submission_class.dart';
import 'package:competitivecodingarena/Stack_OverFlow/problem_class.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_syntax_view/flutter_syntax_view.dart';

class SubmitSolutionScreen extends StatefulWidget {
  final StackOverFlowProblemClass stflow_instance;
  const SubmitSolutionScreen({required this.stflow_instance, super.key});

  @override
  State<SubmitSolutionScreen> createState() => _SubmitSolutionScreenState();
}

class _SubmitSolutionScreenState extends State<SubmitSolutionScreen> {
  final TextEditingController _codeController = TextEditingController();

  String _selectedLanguage = 'Python';
  final List<String> _availableLanguages = ['Python', 'C++', 'Java'];

  final List<String> _availableTags = [
    'Array',
    'String',
    'Hash Table',
    'Dynamic Programming',
    'Math',
    'Greedy',
    'Sorting',
    'Depth-First Search',
    'Binary Search',
    'Breadth-First Search',
    'Tree',
    'Matrix',
    'Two Pointers',
    'Bit Manipulation',
    'Stack',
    'Heap',
    'Graph',
    'Linked List',
    'Recursion',
    'Backtracking',
    'Trie',
    'Segment Tree',
    'Divide and Conquer',
    'Memoization',
    'Concurrency',
    'Multi-threading',
    'Design Patterns',
    'Database',
    'SQL',
    'ORM',
    'REST API',
    'GraphQL',
    'Networking',
    'WebSockets',
    'Caching',
    'Microservices',
    'DevOps',
    'CI/CD',
    'Containerization',
    'Docker',
    'Kubernetes',
    'Cloud Computing',
    'Firebase',
    'AWS',
    'Machine Learning',
    'Artificial Intelligence',
    'Blockchain',
    'Cybersecurity',
    'Cryptography',
    'Unit Testing',
    'Integration Testing',
    'TDD',
    'Version Control',
    'Git',
    'Flutter',
    'React',
    'Node.js',
    'Django',
    'Spring Boot'
  ];

  final List<String> _selectedTags = [];

  bool _isSubmitting = false;

  @override
  void dispose() {
    _codeController.dispose();

    super.dispose();
  }

  Future<void> _submitSolution() async {
    if (_codeController.text.trim().isEmpty) {
      _showErrorSnackBar("Please enter your code solution");
      return;
    }
    setState(() {
      _isSubmitting = true;
    });
    try {
      final submission = Submission(
        tags: _selectedTags,
        username: FirebaseAuth.instance.currentUser!.displayName ?? "Anonymous",
        language: _selectedLanguage,
        status: "Fixed the bug",
        executionTimeMs: 67,
        memoryUsageKb: 10240,
        code: _codeController.text,
        time_stamp: Timestamp.now(),
        imageUrl: FirebaseAuth.instance.currentUser?.photoURL,
      );

      await FirebaseFirestore.instance
          .collection('stack_overflow_problems')
          .doc(widget.stflow_instance.problem_title
              .replaceAll(RegExp(r'[^\w\s]'), '')
              .replaceAll(RegExp(r'\s+'), '_')
              .toLowerCase())
          .collection('submissions')
          .add(submission.toMap());

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Solution submitted successfully!"),
        backgroundColor: Colors.green,
      ));

      Navigator.of(context).pop(true);
    } catch (error) {
      _showErrorSnackBar("Error submitting solution: $error");
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    ));
  }

  void _toggleTag(String tag) {
    setState(() {
      if (_selectedTags.contains(tag)) {
        _selectedTags.remove(tag);
      } else {
        _selectedTags.add(tag);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Dialog(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        title:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Expanded(
            child: Text.rich(
              TextSpan(children: [
                TextSpan(
                    text: "Submit Solution: ",
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto')),
                TextSpan(
                    text: widget.stflow_instance.problem_title,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto'))
              ]),
              overflow: TextOverflow.ellipsis,
            ),
          ),
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
          height: 600,
          child: ScrollConfiguration(
            behavior:
                ScrollConfiguration.of(context).copyWith(scrollbars: false),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16),
                  Text(
                    "Programming Language:",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800]),
                  ),
                  SizedBox(height: 8),
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                              value: _selectedLanguage,
                              isExpanded: true,
                              hint: Text("Select Language"),
                              items: _availableLanguages.map((language) {
                                return DropdownMenuItem(
                                  value: language,
                                  child: Text(
                                    language,
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() {
                                    _selectedLanguage = value;
                                  });
                                }
                              }))),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Your Solution:",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800]),
                      ),
                      Row(
                        children: [
                          ElevatedButton.icon(
                            icon: Icon(Icons.content_paste, size: 16),
                            label: Text("Paste"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                            ),
                            onPressed: () async {
                              final data =
                                  await Clipboard.getData('text/plain');
                              if (data != null && data.text != null) {
                                _codeController.text = data.text!;
                                setState(() {});
                              }
                            },
                          ),
                          SizedBox(width: 8),
                          ElevatedButton.icon(
                            icon: Icon(Icons.clear, size: 16),
                            label: Text("Clear"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.shade300,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                            ),
                            onPressed: () {
                              _codeController.clear();
                              setState(() {});
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Container(
                    height: 250,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: TextField(
                      controller: _codeController,
                      maxLines: null,
                      expands: true,
                      decoration: InputDecoration(
                        hintText: "// Enter your code here",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(12),
                      ),
                      style: TextStyle(
                          fontFamily: 'Courier New',
                          fontSize: 14,
                          color: Colors.grey[600]),
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Preview:",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800]),
                  ),
                  SizedBox(height: 8),
                  Container(
                      height: 200,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: SyntaxView(
                        code: _codeController.text.isEmpty
                            ? "// Your code will be previewed here with syntax highlighting"
                            : _codeController.text,
                        syntax: _getSyntax(_selectedLanguage),
                        syntaxTheme: SyntaxTheme.vscodeDark(),
                        fontSize: 13,
                        withZoom: true,
                        withLinesCount: true,
                        expanded: true,
                      )),
                  SizedBox(height: 16),
                  Text(
                    "Tags (Select techniques used in your solution):",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800]),
                  ),
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _availableTags.map((tag) {
                        final isSelected = _selectedTags.contains(tag);
                        final color = _getColorFromTag(tag);

                        return InkWell(
                          onTap: () => _toggleTag(tag),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 6),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? color.withOpacity(0.2)
                                  : Colors.transparent,
                              border: Border.all(color: color),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              tag,
                              style: TextStyle(
                                color: color,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      onPressed: _isSubmitting ? null : _submitSolution,
                      child: _isSubmitting
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                ),
                                SizedBox(width: 12),
                                Text(
                                  "Submitting Solution...",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            )
                          : Text(
                              "Submit Solution",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getColorFromTag(String tag) {
    int hash = tag.hashCode;
    return Colors.primaries[hash % Colors.primaries.length];
  }

  Syntax _getSyntax(String language) {
    switch (language.toLowerCase()) {
      case "c++":
        return Syntax.CPP;
      case "python":
        return Syntax.SWIFT;
      case "java":
        return Syntax.JAVA;
      default:
        return Syntax.DART;
    }
  }
}
