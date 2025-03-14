import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SubmissionGraphPage extends StatelessWidget {
  final String problemId;
  final String language;
  final String name;

  const SubmissionGraphPage({
    super.key,
    required this.problemId,
    required this.language,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<GraphData>(
      future: fetchSubmissionData(problemId, language, name),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.submissions.isEmpty) {
          return const Center(child: Text('No submission data available.'));
        }

        return Center(
          child: SubmissionGraph(data: snapshot.data!),
        );
      },
    );
  }

  Future<GraphData> fetchSubmissionData(
      String problemId, String language, String userId) async {
    final submissionsSnapshot = await FirebaseFirestore.instance
        .collection("problems")
        .doc(problemId)
        .collection("${language.toLowerCase()} solutions")
        .get();

    List<double> runtimes = [];
    double? userRuntime;
    for (var doc in submissionsSnapshot.docs) {
      double executionTime = double.parse(doc['executionTime'].toString());
      runtimes.add(executionTime);
      if (doc['name'] == userId) {
        userRuntime = executionTime;
      }
    }

    runtimes.sort((a, b) => a.compareTo(b)); // Sort in ascending order
    int totalSubmissions = runtimes.length;

    List<SubmissionData> distributionData = [];
    for (int i = 0; i <= 100; i += 2) {
      int index = (i / 100 * totalSubmissions).round();
      if (index < totalSubmissions) {
        distributionData.add(SubmissionData(
          runtime: runtimes[index],
          percentile: i.toDouble(),
        ));
      }
    }

    double userPercentile = userRuntime != null
        ? (runtimes.indexOf(userRuntime) / totalSubmissions) * 100
        : -1;

    return GraphData(
      submissions: distributionData,
      userRuntime: userRuntime,
      userPercentile: userPercentile,
    );
  }
}

class SubmissionGraph extends StatelessWidget {
  final GraphData data;

  const SubmissionGraph({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(300, 200),
      painter: SubmissionGraphPainter(data: data),
    );
  }
}

class SubmissionGraphPainter extends CustomPainter {
  final GraphData data;

  SubmissionGraphPainter({required this.data});

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()
      ..color = const Color(0xFF1E1E1E)
      ..style = PaintingStyle.fill;

    // Draw background
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    final axisPaint = Paint()
      ..color = Colors.grey[700]!
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final barPaint = Paint()
      ..color = Colors.blue[700]!
      ..style = PaintingStyle.fill;

    final userBarPaint = Paint()
      ..color = Colors.blue[300]!
      ..style = PaintingStyle.fill;

    // Draw axes
    canvas.drawLine(
        Offset(0, size.height), Offset(size.width, size.height), axisPaint);
    canvas.drawLine(Offset(0, size.height), const Offset(0, 0), axisPaint);

    if (data.submissions.isEmpty) return;

    // Calculate bar width and spacing
    double barWidth = size.width / (data.submissions.length * 1.2);
    double spacing = barWidth * 0.2;

    // Draw bars
    for (int i = 0; i < data.submissions.length; i++) {
      double x = i * (barWidth + spacing);
      double barHeight =
          (data.submissions[i].runtime / data.submissions.last.runtime) *
              size.height;

      Rect barRect =
          Rect.fromLTWH(x, size.height - barHeight, barWidth, barHeight);
      canvas.drawRect(barRect, barPaint);
    }

    // Draw user's bar if available
    if (data.userRuntime != null && data.userPercentile >= 0) {
      int userIndex =
          (data.userPercentile / 100 * data.submissions.length).round();
      double x = userIndex * (barWidth + spacing);
      double barHeight =
          (data.userRuntime! / data.submissions.last.runtime) * size.height;

      Rect userBarRect =
          Rect.fromLTWH(x, size.height - barHeight, barWidth, barHeight);
      canvas.drawRect(userBarRect, userBarPaint);
    }

    // Draw labels
    const textStyle = TextStyle(color: Colors.white, fontSize: 10);
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    // Y-axis labels (Runtime in ms)
    for (int i = 0; i <= 4; i++) {
      final runtime =
          (i * data.submissions.last.runtime / 4).toStringAsFixed(0);
      textPainter.text = TextSpan(text: '${runtime}ms', style: textStyle);
      textPainter.layout();
      textPainter.paint(
          canvas, Offset(-35, size.height - (i / 4 * size.height) - 5));
    }

    // X-axis labels (Percentile)
    for (int i = 0; i <= 4; i++) {
      final percentile = (i * 25).toString();
      textPainter.text = TextSpan(text: '$percentile%', style: textStyle);
      textPainter.layout();
      textPainter.paint(
          canvas, Offset((i / 4) * size.width - 10, size.height + 5));
    }

    // User's percentile label
    if (data.userPercentile >= 0) {
      textPainter.text = TextSpan(
        text:
            'Your runtime: ${data.userRuntime!.toStringAsFixed(0)}ms (${data.userPercentile.toStringAsFixed(2)} percentile)',
        style: const TextStyle(
            color: Colors.blue, fontSize: 12, fontWeight: FontWeight.bold),
      );
      textPainter.layout();
      textPainter.paint(canvas, const Offset(10, 10));
    }
  }

  @override
  bool shouldRepaint(covariant SubmissionGraphPainter oldDelegate) {
    return oldDelegate.data != data;
  }
}

class GraphData {
  final List<SubmissionData> submissions;
  final double? userRuntime;
  final double userPercentile;

  GraphData(
      {required this.submissions,
      this.userRuntime,
      required this.userPercentile});
}

class SubmissionData {
  final double runtime;
  final double percentile;

  SubmissionData({required this.runtime, required this.percentile});
}
