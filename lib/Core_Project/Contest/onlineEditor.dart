import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:highlight/highlight_core.dart';
import 'package:highlight/languages/cpp.dart';
import 'package:highlight/languages/java.dart';
import 'package:highlight/languages/python.dart';
import 'package:competitivecodingarena/AWS/Call_Logic/compiler_call.dart';

class OnlineCodeEditor extends StatefulWidget {
  final String? teamid;
  const OnlineCodeEditor({required this.teamid, super.key});

  @override
  State<OnlineCodeEditor> createState() => _OnlineCodeEditorState();
}

class _OnlineCodeEditorState extends State<OnlineCodeEditor> {
  late CodeController _codeController;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  late String uid;
  bool isLocalChange = false;
  String consoleOutput = '';
  String? solvedBy;
  bool isProblemSolved = false;

  String selectedLanguage = 'python';

  Map<String, Mode> language = {"python": python, "java": java, "cpp": cpp};

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

  @override
  void initState() {
    super.initState();
    uid = auth.currentUser?.uid ?? '';
    _codeController = CodeController(language: java, modifiers: const [
      CloseBlockModifier(),
      TabModifier(),
      IndentModifier()
    ]);
    _updateFirestore();
  }

  Future<void> _updateFirestore() async {
    if (uid.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("UID is empty, cannot update Firestore")),
      );
      return;
    }
    try {
      await firestore.collection('code').doc(widget.teamid).set({
        'uid': uid,
        'data': _codeController.text,
        'consoleOutput': consoleOutput,
        'timestamp': FieldValue.serverTimestamp(),
        'solvedBy': solvedBy,
        'isProblemSolved': isProblemSolved,
      }, SetOptions(merge: true));
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save: $error')),
      );
    }
  }

  Future<void> _updateConsoleOutput(String output) async {
    setState(() {
      consoleOutput = output;
    });
    await _updateFirestore();
  }

  Future<void> _markAsSolved(String userName) async {
    setState(() {
      isProblemSolved = true;
      solvedBy = userName;
    });
    await _updateFirestore();
  }

  @override
  void dispose() {
    _codeController.dispose();
    auth.currentUser?.delete();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: firestore.collection('code').doc(widget.teamid).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Center(child: Text('No data available'));
        }

        Map<String, dynamic>? data =
            snapshot.data!.data() as Map<String, dynamic>?;
        String documentUid = data?['uid'] as String? ?? '';
        String codeText = data?['data'] as String? ?? '';
        String remoteConsoleOutput = data?['consoleOutput'] as String? ?? '';
        bool remoteSolved = data?['isProblemSolved'] as bool? ?? false;
        String? remoteSolvedBy = data?['solvedBy'] as String?;

        if (uid != documentUid) {
          if (_codeController.text != codeText) {
            isLocalChange = false;
            _codeController.text = codeText;
            isLocalChange = true;
          }
          if (consoleOutput != remoteConsoleOutput) {
            consoleOutput = remoteConsoleOutput;
          }
          if (isProblemSolved != remoteSolved) {
            isProblemSolved = remoteSolved;
            solvedBy = remoteSolvedBy;
          }
        }

        return Column(
          children: [
            if (isProblemSolved)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.green.shade300),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green),
                    const SizedBox(width: 8),
                    Text(
                      'Problem solved by $solvedBy!',
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: CodeTheme(
                    data: CodeThemeData(styles: monokaiSublimeTheme),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (!isProblemSolved)
                                  ElevatedButton(
                                    onPressed: () async {
                                      final result = await callCompiler(
                                        context,
                                        selectedLanguage,
                                        _codeController.text,
                                      );
                                      await _updateConsoleOutput(
                                          result.toString());
                                      if (result
                                          .toString()
                                          .contains('Output')) {
                                        final user = auth.currentUser;
                                        await _markAsSolved(
                                            user?.displayName ?? 'Anonymous');
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF2CBB5D),
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 8),
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.play_arrow, size: 18),
                                        SizedBox(width: 4),
                                        Text(
                                          "Run",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                const SizedBox(width: 20),
                                if (!isProblemSolved)
                                  DropdownButton<String>(
                                    value: selectedLanguage,
                                    items: <String>['cpp', 'java', 'python']
                                        .map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    onChanged: (_) {},
                                  ),
                              ],
                            ),
                          ),
                          CodeField(
                            controller: _codeController,
                            textStyle: const TextStyle(
                                fontFamily: 'monospace', fontSize: 14),
                            enabled: !isProblemSolved,
                            onChanged: isProblemSolved
                                ? null
                                : (_) {
                                    _updateFirestore();
                                  },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Console Output Section
            Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(4),
              ),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Console Output',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    width: double.infinity,
                    constraints: const BoxConstraints(
                      minHeight: 100,
                      maxHeight: 200,
                    ),
                    child: SingleChildScrollView(
                      child: Text(
                        consoleOutput.isEmpty
                            ? 'No output yet...'
                            : consoleOutput,
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'monospace',
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
