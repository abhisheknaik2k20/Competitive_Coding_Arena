import 'package:flutter/material.dart';

class ProblemTitle extends StatelessWidget {
  final double height;
  final double width;
  final String title;
  const ProblemTitle(
      {required this.height,
      required this.width,
      required this.title,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      width: width * 0.6,
      height: height * 0.2,
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
                "Asked 1 month ago  •  Modified 1 month ago  •  Viewed 1k times",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.verified, color: Colors.orange, size: 16),
              SizedBox(width: 4),
              Text(
                "Part of ",
                style: TextStyle(fontSize: 12, color: Colors.black54),
              ),
              Text(
                "R Language",
                style: TextStyle(fontSize: 12, color: Colors.blue),
              ),
              Text(
                " Collective",
                style: TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
