import 'package:competitivecodingarena/Core_Project/Problemset/examples/exampleprobs.dart';
import 'package:flutter/material.dart';

class ProblemStatement extends StatelessWidget {
  final double height;
  final double width;
  final Problem problem;

  const ProblemStatement({
    required this.height,
    required this.width,
    required this.problem,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height * 0.6,
      width: width * 0.6,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 15,
                offset: const Offset(0, 4))
          ],
          border: Border.all(color: Colors.grey.shade200)),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatsCard(),
            const SizedBox(height: 3),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...problem.content.map((item) => _buildContentText(item)),
                ],
              ),
            ),
            const SizedBox(height: 5),
            Row(children: [
              const Icon(Icons.science_outlined,
                  size: 20, color: Colors.indigo),
              const SizedBox(width: 8),
              const Text('Test-Cases',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo))
            ]),
            const SizedBox(height: 8),
            ...problem.testcases.map((testcase) => _buildTestCase(testcase)),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCard() {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!)),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          _buildStatItem(Icons.check_circle_outline, 'Status', problem.status),
          _buildStatItem(
              Icons.percent, 'Acceptance', '${problem.acceptanceRate}%'),
          _buildStatItem(Icons.trending_up, 'Frequency', problem.frequency)
        ]));
  }

  Widget _buildStatItem(IconData icon, String label, String value) {
    return Column(children: [
      Row(children: [
        Icon(icon, size: 20, color: Colors.black),
        const SizedBox(width: 4),
        Text(label,
            style: TextStyle(
                fontSize: 12, fontWeight: FontWeight.w500, color: Colors.black))
      ]),
      const SizedBox(height: 3),
      Text(value,
          style: const TextStyle(
              fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blue))
    ]);
  }

  Widget _buildContentText(Map<String, dynamic> item) {
    final text = item['text'] ?? '';
    final fontSize = item['fontSize'] ?? 16.0;
    final isBold = item['isBold'] ?? false;
    final color = item['color'] != null
        ? _getColorFromString(item['color'])
        : Colors.black87;

    return Padding(
        padding: const EdgeInsets.only(bottom: 0.5),
        child: Text(text,
            style: TextStyle(
                fontSize: fontSize is int ? fontSize.toDouble() : fontSize,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                color: color,
                letterSpacing: 0.3)));
  }

  Color _getColorFromString(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'red':
        return Colors.red.shade700;
      case 'green':
        return Colors.green.shade700;
      case 'blue':
        return Colors.blue.shade700;
      case 'orange':
        return Colors.orange.shade700;
      default:
        return Colors.black87;
    }
  }

  Widget _buildTestCase(Map<String, dynamic> testcase) {
    final input = testcase['input'] ?? [];
    final input2 = testcase['input2'] ?? [];
    final output = testcase['output'];
    final explain = testcase['explain'] ?? '';
    return Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: Colors.indigo.shade50.withOpacity(0.5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.indigo.shade100)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(height: 6),
          _buildCodeLine('Input: nums1 = $input'),
          _buildCodeLine('Input: nums2 = $input2'),
          _buildCodeLine('Output: $output', isOutput: true),
          if (explain.isNotEmpty) ...[
            const SizedBox(height: 6),
            Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                    color: Colors.amber.shade50,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.amber.shade100)),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.lightbulb_outline,
                          size: 16, color: Colors.amber.shade700),
                      const SizedBox(width: 8),
                      Expanded(
                          child: Text(explain,
                              style: TextStyle(
                                  color: Colors.amber.shade900, fontSize: 14)))
                    ]))
          ]
        ]));
  }

  Widget _buildCodeLine(String text, {bool isOutput = false}) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
        margin: const EdgeInsets.only(bottom: 4),
        decoration: BoxDecoration(
            color: isOutput ? Colors.green.shade50 : Colors.white,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
                color:
                    isOutput ? Colors.green.shade100 : Colors.grey.shade200)),
        child: Text(text,
            style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 14,
                fontWeight: isOutput ? FontWeight.w600 : FontWeight.normal,
                color: isOutput ? Colors.green.shade900 : Colors.black87)));
  }
}
