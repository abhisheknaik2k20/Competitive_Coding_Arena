import 'package:competitivecodingarena/Stack_OverFlow/dsa_screen.dart';
import 'package:competitivecodingarena/Stack_OverFlow/problem_class.dart';
import 'package:flutter/material.dart';

final List<Map<String, dynamic>> stats = [
  {
    "value": "2",
    "label": "votes",
    "bgColor": Colors.grey.shade200,
    "textColor": Colors.grey.shade700
  },
  {
    "value": "1",
    "label": "answer",
    "bgColor": Colors.green.shade50,
    "textColor": Colors.green
  },
  {
    "value": "18",
    "label": "views",
    "bgColor": Colors.blue.shade50,
    "textColor": Colors.blue.shade700
  },
];

final List<Map<String, dynamic>> tags = [
  {"label": "flutter", "color": Colors.blue},
  {"label": "state-management", "color": Colors.green},
  {"label": "provider", "color": Colors.purple},
  {"label": "riverpod", "color": Colors.orange},
];

class TabItem {
  final IconData icon;
  final String label;
  final Color color;

  TabItem({required this.icon, required this.label, required this.color});
}

class BuildQuestionItem extends StatelessWidget {
  final StackOverFlowProblemClass stflow_instance;
  const BuildQuestionItem({required this.stflow_instance, super.key});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                ProblemScreen(stflow_instance: stflow_instance)));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
                children: stats
                    .map((stat) => _buildStatBox(stat['value'], stat['label'],
                        stat['bgColor'], stat['textColor']))
                    .toList()),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          stflow_instance.problem_title,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    stflow_instance.problem_description,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey.shade500
                            : Colors.grey.shade800,
                        height: 1.5),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: tags
                          .map((tag) => _buildTag(tag['label'], tag['color']))
                          .toList()),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 12,
                              backgroundColor: Colors.blue,
                              child: const Icon(Icons.person,
                                  size: 24, color: Colors.white),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'JohnDoe',
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'asked 2 hours ago',
                              style: TextStyle(color: Colors.grey.shade700),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatBox(
      String value, String label, Color bgColor, Color textColor) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Container(
        width: 60,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(value,
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: textColor)),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(fontSize: 12, color: textColor)),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.5), width: 1),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
