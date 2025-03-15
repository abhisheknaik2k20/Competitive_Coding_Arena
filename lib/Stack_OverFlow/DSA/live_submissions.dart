import 'package:competitivecodingarena/Stack_OverFlow/DSA/preview_submission.dart';
import 'package:competitivecodingarena/Stack_OverFlow/DSA/submission_class.dart';
import 'package:flutter/material.dart';

class LiveSubmissions extends StatefulWidget {
  final double width;

  const LiveSubmissions({
    required this.width,
    super.key,
  });

  @override
  State<LiveSubmissions> createState() => _LiveSubmissionsState();
}

class _LiveSubmissionsState extends State<LiveSubmissions> {
  List<Submission> _submissions = [];
  bool _isLoading = true;
  String _filterStatus = "All";

  // Stack Overflow color scheme
  final Color soOrange = Color(0xFFF48024);
  final Color soBlack = Color(0xFF242729);
  final Color soGray = Color(0xFFE4E6E8);
  final Color soLightGray = Color(0xFFF8F9F9);
  final Color soTagBackground = Color(0xFFE1ECF4);
  final Color soTagText = Color(0xFF39739D);
  final Color soLinkColor = Color(0xFF0077CC);

  @override
  void initState() {
    super.initState();
    _fetchSubmissions();
  }

  Future<void> _fetchSubmissions() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      _submissions = [
        Submission(
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
        ),
        Submission(
          username: "flutter_dev",
          language: "Python",
          submittedAt: DateTime.now().subtract(Duration(minutes: 8)),
          status: "Wrong Answer",
          executionTimeMs: 67,
          memoryUsageKb: 10240,
          code: "# Python solution code",
        ),
        Submission(
          username: "algorithm_guru",
          language: "Java",
          submittedAt: DateTime.now().subtract(Duration(minutes: 15)),
          status: "Time Limit Exceeded",
          executionTimeMs: 2500,
          memoryUsageKb: 15360,
          code: "// Java solution code",
        ),
        Submission(
          username: "new_coder123",
          language: "C++",
          submittedAt: DateTime.now().subtract(Duration(minutes: 20)),
          status: "Compilation Error",
          executionTimeMs: 0,
          memoryUsageKb: 0,
          code: "// C++ solution with syntax error",
        ),
        Submission(
          username: "js_ninja",
          language: "JavaScript",
          submittedAt: DateTime.now().subtract(Duration(minutes: 25)),
          status: "Runtime Error",
          executionTimeMs: 124,
          memoryUsageKb: 12288,
          code: "// JavaScript solution code",
        ),
        Submission(
          username: "competitive_coder",
          language: "C++",
          submittedAt: DateTime.now().subtract(Duration(hours: 1)),
          status: "Accepted",
          executionTimeMs: 32,
          memoryUsageKb: 7168,
          code: "// C++ optimized solution",
        ),
      ];
      _isLoading = false;
    });
  }

  void _viewSubmissionCode(Submission submission) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: PreviewSubmission(width: widget.width, submission: submission),
      ),
    );
  }

  String _formatTimeAgo(DateTime dateTime) {
    final Duration difference = DateTime.now().difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  List<Submission> _getFilteredSubmissions() {
    return _submissions.where((submission) {
      bool statusMatch =
          _filterStatus == "All" || submission.status == _filterStatus;

      return statusMatch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredSubmissions = _getFilteredSubmissions();
    final List<String> statuses = [
      "All",
      "Accepted",
      "Wrong Answer",
      "Time Limit Exceeded",
      "Runtime Error",
      "Compilation Error"
    ];

    return Container(
      width: widget.width * 0.3,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(3),
        border: Border.all(color: soGray),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: soLightGray,
              border: Border(bottom: BorderSide(color: soGray)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Live Submissions",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: soBlack,
                    fontFamily: 'Arial',
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: soTagBackground,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Text(
                    "Problem",
                    style: TextStyle(
                      color: soTagText,
                      fontSize: 11,
                      fontFamily: 'Arial',
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: "Status",
                      labelStyle: TextStyle(
                        color: Color(0xFF6A737C),
                        fontSize: 13,
                        fontFamily: 'Arial',
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(3),
                        borderSide: BorderSide(color: soGray),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(3),
                        borderSide: BorderSide(color: soLinkColor),
                      ),
                    ),
                    value: _filterStatus,
                    items: statuses
                        .map((status) => DropdownMenuItem(
                              value: status,
                              child: Text(
                                status,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontFamily: 'Arial',
                                ),
                              ),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _filterStatus = value!;
                      });
                    },
                  ),
                ),
                SizedBox(width: 8),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(soOrange),
                    ),
                  )
                : filteredSubmissions.isEmpty
                    ? Center(
                        child: Text(
                          "No submissions match the current filters",
                          style: TextStyle(
                            color: Color(0xFF6A737C),
                            fontStyle: FontStyle.italic,
                            fontFamily: 'Arial',
                          ),
                        ),
                      )
                    : ListView.separated(
                        padding: EdgeInsets.all(12),
                        itemCount: filteredSubmissions.length,
                        separatorBuilder: (context, index) => Divider(
                          color: soGray,
                          height: 1,
                        ),
                        itemBuilder: (context, index) {
                          final submission = filteredSubmissions[index];
                          return InkWell(
                            onTap: () => _viewSubmissionCode(submission),
                            borderRadius: BorderRadius.circular(3),
                            child: Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color:
                                    index % 2 == 0 ? Colors.white : soLightGray,
                                borderRadius: BorderRadius.circular(3),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 10,
                                            backgroundColor: Colors.primaries[
                                                submission.username.hashCode %
                                                    Colors.primaries.length],
                                            child: Text(
                                              submission.username[0]
                                                  .toUpperCase(),
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 6),
                                          Text(
                                            submission.username,
                                            style: TextStyle(
                                              color: soLinkColor,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 13,
                                              fontFamily: 'Arial',
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        _formatTimeAgo(submission.submittedAt),
                                        style: TextStyle(
                                          color: Color(0xFF6A737C),
                                          fontSize: 11,
                                          fontFamily: 'Arial',
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      PreviewSubmission(
                                        width: widget.width,
                                        submission: submission,
                                      ).getStatusBadge(submission.status),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: soTagBackground,
                                          borderRadius:
                                              BorderRadius.circular(3),
                                        ),
                                        child: Text(
                                          submission.language,
                                          style: TextStyle(
                                            color: soTagText,
                                            fontSize: 11,
                                            fontFamily: 'Arial',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    "${submission.executionTimeMs} ms, ${submission.memoryUsageKb / 1024} MB",
                                    style: TextStyle(
                                      color: Color(0xFF6A737C),
                                      fontSize: 11,
                                      fontStyle: FontStyle.italic,
                                      fontFamily: 'Arial',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
