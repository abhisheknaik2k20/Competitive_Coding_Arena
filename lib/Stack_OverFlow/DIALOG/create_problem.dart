import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:competitivecodingarena/Stack_OverFlow/DIALOG/data.dart';
import 'package:competitivecodingarena/Stack_OverFlow/problem_class.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_syntax_view/flutter_syntax_view.dart';

class CreateProblemScreen extends StatefulWidget {
  const CreateProblemScreen({super.key});
  @override
  State<CreateProblemScreen> createState() => _CreateProblemScreenState();
}

class _CreateProblemScreenState extends State<CreateProblemScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _codeController = TextEditingController();
  final _expectedOutputController = TextEditingController();
  String _selectedCategory = "DSA";
  String _selectedLanguage = 'Python';
  final List<String> _selectedTags = [];
  bool _isSubmitting = false;

  List<Map<String, String>> _dsaProblems = [];
  String? _selectedProblemId;
  bool _isLoadingProblems = false;

  @override
  void initState() {
    super.initState();
    _fetchDSAProblems();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _codeController.dispose();
    _expectedOutputController.dispose();
    super.dispose();
  }

  Future<void> _fetchDSAProblems() async {
    if (_selectedCategory == "DSA") {
      setState(() => _isLoadingProblems = true);
      try {
        final QuerySnapshot querySnapshot =
            await FirebaseFirestore.instance.collection('problems').get();
        setState(() {
          _dsaProblems = querySnapshot.docs
              .map((doc) => {
                    'id': doc.id,
                    'title': ((doc.data() as Map<String, dynamic>)['title'] ??
                            'Untitled Problem')
                        .toString(),
                  })
              .toList();
          _isLoadingProblems = false;
        });
      } catch (error) {
        print("Error fetching DSA problems: $error");
        setState(() => _isLoadingProblems = false);
        _showErrorSnackBar("Failed to load DSA problems");
      }
    } else {
      setState(() {
        _dsaProblems = [];
        _selectedProblemId = null;
      });
    }
  }

  Future<void> _createProblem() async {
    if (_titleController.text.trim().isEmpty) {
      _showErrorSnackBar("Please enter a problem title");
      return;
    }
    if (_descriptionController.text.trim().isEmpty) {
      _showErrorSnackBar("Please enter a problem description");
      return;
    }

    if (_codeController.text.trim().isEmpty) {
      _showErrorSnackBar("Please enter the code with bug");
      return;
    }

    if (_selectedTags.isEmpty) {
      _showErrorSnackBar("Please select at least one tag");
      return;
    }
    if (_selectedCategory == "DSA" && _selectedProblemId == null) {
      _showErrorSnackBar("Please select a DSA problem");
      return;
    }
    setState(() => _isSubmitting = true);
    try {
      final problem = StackOverFlowProblemClass(
          problem_title: _titleController.text,
          problem_description: _descriptionController.text,
          tags: _selectedTags,
          name: FirebaseAuth.instance.currentUser?.displayName ?? "Anonymous",
          upvotes: 0,
          downvotes: 0,
          category: _selectedCategory,
          time_stamp: Timestamp.now(),
          code: _codeController.text,
          syntax: getSyntaxfunc(_selectedLanguage),
          views: 0,
          answers: 0,
          problem_id: _selectedCategory == "DSA"
              ? int.parse(_selectedProblemId!)
              : null);

      final docId = _titleController.text
          .replaceAll(RegExp(r'[^\w\s]'), '')
          .replaceAll(RegExp(r'\s+'), '_')
          .toLowerCase();

      await FirebaseFirestore.instance
          .collection('stack_overflow_problems')
          .doc(docId)
          .set(problem.toMap());

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Problem created successfully!"),
        backgroundColor: Colors.green,
      ));

      Navigator.of(context).pop(true);
    } catch (error) {
      _showErrorSnackBar("Error creating problem: $error");
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  void _showErrorSnackBar(String message) {
    print(message);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
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
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Create New Stack Overflow Problem",
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Roboto')),
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
                    behavior: ScrollConfiguration.of(context)
                        .copyWith(scrollbars: false),
                    child: SingleChildScrollView(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          SizedBox(height: 16),
                          Text("Problem Title:",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800])),
                          SizedBox(height: 8),
                          Container(
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.grey.shade400),
                                  borderRadius: BorderRadius.circular(4)),
                              child: TextField(
                                  controller: _titleController,
                                  decoration: InputDecoration(
                                      hintText:
                                          "E.g. 'Fix the bug in this array sorting function'",
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.all(12)),
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey[800]))),
                          SizedBox(height: 16),
                          Text("Problem Description:",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800])),
                          SizedBox(height: 8),
                          Container(
                              height: 120,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.grey.shade400),
                                  borderRadius: BorderRadius.circular(4)),
                              child: TextField(
                                  controller: _descriptionController,
                                  maxLines: null,
                                  expands: true,
                                  decoration: InputDecoration(
                                      hintText:
                                          "Describe the problem and what needs to be fixed...",
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.all(12)),
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey[800]))),
                          SizedBox(height: 16),
                          Row(children: [
                            Expanded(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                  Text("Difficulty Level:",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[800])),
                                  SizedBox(height: 8),
                                  Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 12),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.grey.shade400),
                                          borderRadius:
                                              BorderRadius.circular(4)),
                                      child: DropdownButtonHideUnderline(
                                          child: DropdownButton<String>(
                                              value: _selectedCategory,
                                              isExpanded: true,
                                              hint: Text("Select Category"),
                                              items:
                                                  categories.map((difficulty) {
                                                return DropdownMenuItem(
                                                    value: difficulty,
                                                    child: Text(difficulty,
                                                        style: TextStyle(
                                                            color: getDifficultyColor(
                                                                difficulty))));
                                              }).toList(),
                                              onChanged: (value) {
                                                if (value != null) {
                                                  setState(() {
                                                    _selectedCategory = value;
                                                    _selectedProblemId =
                                                        null; // Reset problem selection
                                                  });
                                                  _fetchDSAProblems(); // Fetch problems if category is DSA
                                                }
                                              })))
                                ])),
                            SizedBox(width: 16),
                            Expanded(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                  Text("Programming Language:",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[800])),
                                  SizedBox(height: 8),
                                  Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 12),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.grey.shade400),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: DropdownButtonHideUnderline(
                                          child: DropdownButton<String>(
                                              value: _selectedLanguage,
                                              isExpanded: true,
                                              hint: Text("Select Language"),
                                              items: availableLanguages
                                                  .map((language) {
                                                return DropdownMenuItem(
                                                    value: language,
                                                    child: Text(language,
                                                        style: TextStyle(
                                                            color: Colors
                                                                .grey[600])));
                                              }).toList(),
                                              onChanged: (value) {
                                                if (value != null) {
                                                  setState(() =>
                                                      _selectedLanguage =
                                                          value);
                                                }
                                              })))
                                ]))
                          ]),

                          // Add DSA Problem selection dropdown if category is DSA
                          if (_selectedCategory == "DSA") ...[
                            SizedBox(height: 16),
                            Text("Select DSA Problem:",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[800])),
                            SizedBox(height: 8),
                            Container(
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.grey.shade400),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: _isLoadingProblems
                                    ? Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 12),
                                        child: Center(
                                            child: SizedBox(
                                                width: 20,
                                                height: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                        strokeWidth: 2))))
                                    : _dsaProblems.isEmpty
                                        ? Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 12),
                                            child: Text("No DSA problems found",
                                                style: TextStyle(
                                                    color: Colors.grey[600])))
                                        : DropdownButtonHideUnderline(
                                            child: DropdownButton<String>(
                                                value: _selectedProblemId,
                                                isExpanded: true,
                                                hint: Text(
                                                    "Select a DSA Problem"),
                                                // Fixed: Properly specify the type and use a proper mapping
                                                items: _dsaProblems.map<
                                                        DropdownMenuItem<
                                                            String>>(
                                                    (Map<String, String>
                                                        problem) {
                                                  return DropdownMenuItem<
                                                          String>(
                                                      value: problem['id'],
                                                      child: Text(
                                                          problem['title'] ??
                                                              '',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .grey[600])));
                                                }).toList(),
                                                onChanged: (value) {
                                                  if (value != null) {
                                                    setState(() =>
                                                        _selectedProblemId =
                                                            value);
                                                  }
                                                })))
                          ],

                          SizedBox(height: 16),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Code with Bug:",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[800])),
                                Row(children: [
                                  ElevatedButton.icon(
                                      icon: Icon(Icons.content_paste, size: 16),
                                      label: Text("Paste"),
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue,
                                          foregroundColor: Colors.white,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 8)),
                                      onPressed: () async {
                                        final data = await Clipboard.getData(
                                            'text/plain');
                                        if (data != null && data.text != null) {
                                          _codeController.text = data.text!;
                                          setState(() {});
                                        }
                                      }),
                                  SizedBox(width: 8),
                                  ElevatedButton.icon(
                                      icon: Icon(Icons.clear, size: 16),
                                      label: Text("Clear"),
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red.shade300,
                                          foregroundColor: Colors.white,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 8)),
                                      onPressed: () {
                                        _codeController.clear();
                                        setState(() {});
                                      })
                                ])
                              ]),
                          SizedBox(height: 8),
                          Container(
                              height: 200,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.grey.shade400),
                                  borderRadius: BorderRadius.circular(4)),
                              child: TextField(
                                  controller: _codeController,
                                  maxLines: null,
                                  expands: true,
                                  decoration: InputDecoration(
                                      hintText:
                                          "// Enter the code with the bug here",
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.all(12)),
                                  style: TextStyle(
                                      fontFamily: 'Courier New',
                                      fontSize: 14,
                                      color: Colors.grey[600]),
                                  onChanged: (_) => setState(() {}))),
                          SizedBox(height: 16),
                          Text("Preview:",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800])),
                          SizedBox(height: 8),
                          Container(
                              height: 150,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(4)),
                              child: SyntaxView(
                                  code: _codeController.text.isEmpty
                                      ? "// Your code will be previewed here with syntax highlighting"
                                      : _codeController.text,
                                  syntax: getSyntaxfunc(_selectedLanguage),
                                  syntaxTheme: SyntaxTheme.vscodeDark(),
                                  fontSize: 13,
                                  withZoom: true,
                                  withLinesCount: true,
                                  expanded: true)),
                          SizedBox(height: 16),
                          Text("Expected Output/Behavior:",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800])),
                          SizedBox(height: 8),
                          Container(
                              height: 80,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.grey.shade400),
                                  borderRadius: BorderRadius.circular(4)),
                              child: TextField(
                                  controller: _expectedOutputController,
                                  maxLines: null,
                                  expands: true,
                                  decoration: InputDecoration(
                                      hintText:
                                          "Describe what the correct behavior or output should be...",
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.all(12)),
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey[800]))),
                          SizedBox(height: 16),
                          Text("Tags (Select relevant categories):",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800])),
                          SizedBox(height: 8),
                          Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.grey.shade400),
                                  borderRadius: BorderRadius.circular(4)),
                              child: Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: availableTags.map((tag) {
                                  final isSelected =
                                      _selectedTags.contains(tag);
                                  final color = getColorFromTag(tag);
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
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: Text(tag,
                                              style: TextStyle(
                                                color: color,
                                                fontWeight: isSelected
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
                                                fontSize: 12,
                                              ))));
                                }).toList(),
                              )),
                          SizedBox(height: 24),
                          SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(4))),
                                  onPressed:
                                      _isSubmitting ? null : _createProblem,
                                  child: _isSubmitting
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                              SizedBox(
                                                  width: 20,
                                                  height: 20,
                                                  child:
                                                      CircularProgressIndicator(
                                                          color: Colors.white,
                                                          strokeWidth: 2)),
                                              SizedBox(width: 12),
                                              Text("Creating Problem...",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ))
                                            ])
                                      : Text("Create Problem",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold))))
                        ]))))));
  }
}
