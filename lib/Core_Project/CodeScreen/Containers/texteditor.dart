import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:competitivecodingarena/Core_Project/CodeScreen/Containers/responses.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:highlight/languages/python.dart';
import 'package:highlight/languages/cpp.dart';
import 'package:highlight/languages/java.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:competitivecodingarena/AWS/Call_Logic/compiler_call.dart';
import 'package:competitivecodingarena/Core_Project/Problemset/examples/exampleprobs.dart';
import '../providers.dart';

class Texteditor extends ConsumerStatefulWidget {
  final Problem problem;
  final TextEditingController textEditingController;

  const Texteditor({
    required this.problem,
    required this.textEditingController,
    super.key,
  });

  @override
  _TexteditorState createState() => _TexteditorState();
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
    print(javaresponses.length);
    controller = CodeController(
      language: python,
    );
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
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
                  borderRadius: BorderRadius.circular(3),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.play_arrow, size: 18),
                  SizedBox(width: 4),
                  Text(
                    "Run",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 20),
            DropdownButton<String>(
              value: selectedLanguage,
              items: <String>['cpp', 'java', 'python'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: updateLanguage,
            ),
          ],
        ),
        SizedBox(
          width: 1000,
          child: CodeTheme(
            data: CodeThemeData(styles: monokaiSublimeTheme),
            child: SingleChildScrollView(
              child: CodeField(controller: controller),
            ),
          ),
        ),
      ],
    );
  }
}
