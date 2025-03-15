import 'package:competitivecodingarena/Stack_OverFlow/DSA/live_submissions.dart';
import 'package:competitivecodingarena/Stack_OverFlow/DSA/problem_description.dart';
import 'package:competitivecodingarena/Stack_OverFlow/DSA/problem_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_syntax_view/flutter_syntax_view.dart';

class MobileHomescreen extends StatelessWidget {
  const MobileHomescreen({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    double width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      body: SizedBox(
        height: height,
        width: width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InvisibleSpacer(width: width),
            ScrollConfiguration(
              behavior:
                  ScrollConfiguration.of(context).copyWith(scrollbars: false),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Divider(),
                    ProblemTitle(
                        height: height,
                        width: width,
                        title: "This is a Flutter Problem to-FIX"),
                    Divider(),
                    ProblemDescription(
                      description: '''
I'm experiencing an issue with ListView.builder in my Flutter app. The problem occurs when I delete an item from the list. Instead of the UI updating automatically and removing the item, the deleted item still appears in the list until I perform a hot reload or manually trigger a setState elsewhere in the app.s
                        ''',
                      code: '''
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Boilerplate')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'You have pressed the button this many times:',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              '_counter',
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        child: const Icon(Icons.add),
      ),
    );
  }
}
''',
                      height: height,
                      width: width,
                      language: Syntax.DART,
                    ),
                    Divider(),
                  ],
                ),
              ),
            ),
            LiveSubmissions(width: width)
          ],
        ),
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
      width: width * 0.08,
    );
  }
}
