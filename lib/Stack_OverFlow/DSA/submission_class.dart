class Submission {
  final String username;
  final String language;
  final DateTime submittedAt;
  final String status;
  final int executionTimeMs;
  final int memoryUsageKb;
  final String code;

  Submission({
    required this.username,
    required this.language,
    required this.submittedAt,
    required this.status,
    required this.executionTimeMs,
    required this.memoryUsageKb,
    required this.code,
  });
}
