import 'package:flutter/material.dart';
import 'package:competitivecodingarena/Core_Project/Problemset/examples/exampleprobs.dart';

class Testcase extends StatefulWidget {
  final Problem problem;

  const Testcase({super.key, required this.problem});

  @override
  State<Testcase> createState() => _TestcaseState();
}

class _TestcaseState extends State<Testcase> {
  var index = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              for (int i = 1; i <= widget.problem.testcases.length; i++)
                Padding(
                  padding: const EdgeInsets.only(right: 40),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        index = i - 1;
                      });
                    },
                    child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.white.withOpacity(0.3), width: 2),
                          color: index + 1 == i
                              ? Colors.white.withOpacity(0.4)
                              : Colors.white.withOpacity(0.1),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        child: Text(" case $i ")),
                  ),
                ),
              IconButton(onPressed: () {}, icon: const Icon(Icons.add))
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        _buildTestCase(widget.problem.testcases[index])
      ],
    );
  }
}

Widget _buildTestCase(Map<String, dynamic> testcase) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        testcase['title'],
        style: const TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      const SizedBox(height: 8),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Input",
            style: TextStyle(color: Colors.cyan),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            child: Text(
              testcase['input'],
            ),
          ),
        ],
      ),
      const SizedBox(height: 4),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Output',
            style: TextStyle(color: Colors.orange),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            child: Text(
              testcase['output'],
            ),
          ),
        ],
      ),
      const SizedBox(height: 4),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Explanation',
            style: TextStyle(color: Colors.lime),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            child: Text(
              testcase['explain'],
            ),
          ),
        ],
      ),
    ],
  );
}
