import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProblemTitle extends StatelessWidget {
  final String name;
  final double height;
  final double width;
  final String title;
  final Timestamp timestamp;
  final List<String> tags;

  const ProblemTitle({
    required this.name,
    required this.height,
    required this.width,
    required this.title,
    required this.timestamp,
    required this.tags,
    super.key,
  });

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
    String askedTime = getRelativeTime(timestamp);
    return Container(
      padding: EdgeInsets.all(20),
      width: width * 0.6,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Text(
                "Asked $askedTime  •  Asked by $name",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
              children: tags
                  .map((tag) => _buildTag(tag, _getColorFromTag(tag)))
                  .toList()),
        ],
      ),
    );
  }

  Widget _buildTag(String label, Color color) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
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
      ),
    );
  }

  Color _getColorFromTag(String tag) {
    int hash = tag.hashCode;
    return Colors.primaries[hash % Colors.primaries.length];
  }
}
