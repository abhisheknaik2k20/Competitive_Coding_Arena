import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:competitivecodingarena/Stack_OverFlow/problem_class.dart';
import 'package:competitivecodingarena/Stack_OverFlow/problem_screen.dart';
import 'package:flutter/material.dart';

class TabItem {
  final IconData icon;
  final String label;
  final Color color;

  TabItem({required this.icon, required this.label, required this.color});
}

class BuildQuestionItem extends StatelessWidget {
  final StackOverFlowProblemClass stflow_instance;
  const BuildQuestionItem({required this.stflow_instance, super.key});

  Color getColorFromTag(String tag) {
    int hash = tag.hashCode;
    return Colors.primaries[hash % Colors.primaries.length];
  }

  String getRelativeTime(Timestamp timestamp) {
    DateTime postDate = timestamp.toDate();
    Duration diff = DateTime.now().difference(postDate);

    if (diff.inMinutes < 60) {
      return "${diff.inMinutes} min ago";
    } else if (diff.inHours < 24) {
      return "${diff.inHours} hour${diff.inHours > 1 ? 's' : ''} ago";
    } else if (diff.inDays < 30) {
      return "${diff.inDays} day${diff.inDays > 1 ? 's' : ''} ago";
    } else if (diff.inDays < 365) {
      return "${(diff.inDays / 30).floor()} month${(diff.inDays / 30).floor() > 1 ? 's' : ''} ago";
    } else {
      return "${(diff.inDays / 365).floor()} year${(diff.inDays / 365).floor() > 1 ? 's' : ''} ago";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade100),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        onTap: () async {
          Navigator.of(context).push(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  ProblemScreen(stflow_instance: stflow_instance),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
              transitionDuration:
                  const Duration(microseconds: 100), // Faster transition
            ),
          );
        },
        title: Row(
          children: [
            Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue,
                )),
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
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
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
                children: stflow_instance.tags
                    .map(
                      (tag) => _buildTag(tag, getColorFromTag(tag)),
                    )
                    .toList()),
            const SizedBox(height: 12),
            Row(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildStatBox(stflow_instance.views.toString(), "Views",
                        Colors.white, Colors.blue),
                    _buildStatBox(
                        (stflow_instance.upvotes - stflow_instance.downvotes)
                            .toString(),
                        "Votes",
                        Colors.white,
                        Colors.blue),
                    _buildStatBox(stflow_instance.answers.toString(), "Answers",
                        Colors.white, Colors.blue)
                  ],
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                          radius: 12,
                          backgroundColor: Colors.blue,
                          child: const Icon(Icons.person,
                              size: 16, color: Colors.white)),
                      const SizedBox(width: 8),
                      Text(
                        stflow_instance.name,
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        getRelativeTime(stflow_instance.time_stamp),
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }

  Widget _buildStatBox(
      String value, String label, Color bgColor, Color textColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4, right: 10),
      child: Container(
        width: 60,
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
        decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: textColor, width: 2)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(value,
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: textColor)),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(fontSize: 10, color: textColor)),
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
