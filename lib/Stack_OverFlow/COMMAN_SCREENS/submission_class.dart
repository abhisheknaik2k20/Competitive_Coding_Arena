import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Submission {
  final String username;
  final String language;
  final DateTime submittedAt;
  final String status;
  final int executionTimeMs;
  final int memoryUsageKb;
  final String code;
  final List<String> tags;
  String? imageUrl;
  final Timestamp time_stamp;

  Submission({
    required this.username,
    required this.language,
    required this.submittedAt,
    required this.status,
    required this.executionTimeMs,
    required this.memoryUsageKb,
    required this.code,
    required this.tags,
    required this.time_stamp,
    this.imageUrl,
  });
}

final List<String> statuses = [
  "All",
  "Accepted",
  "Wrong Answer",
  "Time Limit Exceeded",
  "Runtime Error",
  "Compilation Error"
];
List<Submission> submissions = [
  Submission(
    tags: [
      "memory_issue",
      "segmentation_fault",
      "null_pointer",
      "resource_leak"
    ],
    username: "coding_master",
    language: "C++",
    submittedAt: DateTime.now().subtract(Duration(minutes: 5)),
    status: "Accepted",
    executionTimeMs: 45,
    memoryUsageKb: 8124,
    code: '''
  #include <stdio.h>
  #include <stdbool.h>
  #include <stdint.h>
  #include <stdlib.h>

  static bool init_rand(void *data, size_t size) {
      FILE *stream = fopen("/dev/urandom", "r");
      if (stream == NULL) {
          perror("Failed to open /dev/urandom");
          return false;
      }

      bool ok = (fread(data, sizeof(uint8_t), size, stream) == size);
      fclose(stream);

      if (!ok) {
          perror("Failed to read random data");
          return false;
      }

      // Deliberately writing to a NULL pointer (Segfault here)
      uint8_t *ptr = NULL;
      ptr[0] = 0xFF;  // 💥 Writing to NULL causes Segfault

      return true;
  }

  int main() {
      size_t size = 16;
      uint8_t *data = NULL; // 💥 Not allocating memory

      if (init_rand(data, size)) {
          printf("Random data generated successfully.");
      } else {
          printf("Failed to generate random data.");
      }

      free(data); // 💥 Freeing NULL (not a segfault but incorrect)
      return EXIT_SUCCESS;
  }

  ''',
    time_stamp: Timestamp.fromDate(DateTime(2025, 3, 18, 10, 30, 0)),
  ),
  Submission(
    tags: ["logic_error", "wrong_algorithm", "python"],
    username: "flutter_dev",
    language: "Python",
    submittedAt: DateTime.now().subtract(Duration(minutes: 8)),
    status: "Wrong Answer",
    executionTimeMs: 67,
    memoryUsageKb: 10240,
    code: "# Python solution code",
    time_stamp: Timestamp.fromDate(DateTime(2025, 3, 18, 10, 30, 0)),
  ),
  Submission(
    tags: ["time_complexity", "optimization_needed", "java"],
    username: "algorithm_guru",
    language: "Java",
    submittedAt: DateTime.now().subtract(Duration(minutes: 15)),
    status: "Time Limit Exceeded",
    executionTimeMs: 2500,
    memoryUsageKb: 15360,
    code: "// Java solution code",
    time_stamp: Timestamp.fromDate(DateTime(2025, 3, 18, 10, 30, 0)),
  ),
  Submission(
    tags: ["syntax_error", "compilation_failure", "beginner"],
    username: "new_coder123",
    language: "C++",
    submittedAt: DateTime.now().subtract(Duration(minutes: 20)),
    status: "Compilation Error",
    executionTimeMs: 0,
    memoryUsageKb: 0,
    code: "// C++ solution with syntax error",
    time_stamp: Timestamp.fromDate(DateTime(2025, 3, 18, 10, 30, 0)),
  ),
  Submission(
    tags: ["runtime_exception", "javascript", "error_handling"],
    username: "js_ninja",
    language: "JavaScript",
    submittedAt: DateTime.now().subtract(Duration(minutes: 25)),
    status: "Runtime Error",
    executionTimeMs: 124,
    memoryUsageKb: 12288,
    code: "// JavaScript solution code",
    time_stamp: Timestamp.fromDate(DateTime(2025, 3, 18, 10, 30, 0)),
  ),
  Submission(
    tags: ["optimized", "fast_execution", "efficient", "c++"],
    username: "competitive_coder",
    language: "C++",
    submittedAt: DateTime.now().subtract(Duration(hours: 1)),
    status: "Accepted",
    executionTimeMs: 32,
    memoryUsageKb: 7168,
    code: "// C++ optimized solution",
    time_stamp: Timestamp.fromDate(DateTime(2025, 3, 18, 10, 30, 0)),
  ),
];

class TagBadge extends StatelessWidget {
  final String label;

  const TagBadge({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    final Color color =
        Colors.primaries[label.hashCode % Colors.primaries.length];

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
              color: color, fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class AppColors {
  const AppColors();

  static const Color black = Color(0xFF242729);
  static const Color linkColor = Color(0xFF0077CC);
  static const Color tagText = Color(0xFF39739D);
  final Color orange = const Color(0xFFF48024);
  final Color gray = const Color(0xFFE4E6E8);
  final Color lightGray = const Color(0xFFF8F9F9);
  final Color tagBackground = const Color(0xFFE1ECF4);
}
