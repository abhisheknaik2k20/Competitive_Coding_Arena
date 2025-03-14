import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class RuntimeDistributionChart extends StatefulWidget {
  final List<QueryDocumentSnapshot> solutions;
  final String selectedCategory;

  const RuntimeDistributionChart(
      {super.key, required this.solutions, required this.selectedCategory});

  @override
  State<RuntimeDistributionChart> createState() =>
      _RuntimeDistributionChartState();
}

class _RuntimeDistributionChartState extends State<RuntimeDistributionChart> {
  String cexecutionTime = 'N/A'; // Initialize with a default value

  @override
  Widget build(BuildContext context) {
    final String currentUserId =
        FirebaseAuth.instance.currentUser!.displayName!;

    // Check if the `runtimes` list is not empty and calculate the histogram
    List<double> runtimes = widget.solutions.map((s) {
      final data = s.data() as Map<String, dynamic>;
      final executionTime = data['executionTime'];
      final userId = data['name'];

      // Check if the userId matches the current user and update cexecutionTime accordingly
      if (userId == currentUserId) {
        setState(() {
          cexecutionTime = executionTime.toString(); // Ensure it's a string
        });
      }

      return double.tryParse(executionTime.toString()) ??
          200.0; // Default to 200 if parsing fails
    }).toList();

    if (runtimes.isEmpty) {
      // Handle the case where `runtimes` is empty to avoid calling `.first` or `.last`
      return const Center(
        child: Text(
          'No runtime data available.',
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    // Sort the runtimes
    runtimes.sort();

    final minRuntime = runtimes.first.floorToDouble();
    final maxRuntime = runtimes.last.ceilToDouble();
    final range = maxRuntime - minRuntime;
    const binCount = 20;
    final binSize = range / binCount;

    final histogramData = List.generate(binCount, (index) {
      final binStart = minRuntime + index * binSize;
      final binEnd = binStart + binSize;
      final count = runtimes.where((r) => r >= binStart && r < binEnd).length;
      final percentage = (count / runtimes.length) * 100;
      return FlSpot(binStart, percentage);
    });

    return Container(
      height: MediaQuery.sizeOf(context).height * 0.5,
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${widget.selectedCategory} Runtimes',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  'Your submission $cexecutionTime',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.bolt, color: Colors.purple, size: 18),
                Text(
                  'Analyze Complexity',
                  style: TextStyle(color: Colors.purple[300], fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots: histogramData,
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 4,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.blue.withOpacity(0.3),
                      ),
                    ),
                  ],
                  minY: 0,
                  maxY: histogramData
                          .map((spot) => spot.y)
                          .reduce((a, b) => a > b ? a : b) *
                      1.1,
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) => Text(
                          '${value.toInt()}%',
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 10),
                        ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              '${value.toInt()}ms',
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 10),
                            ),
                          );
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawHorizontalLine: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.grey[800],
                        strokeWidth: 1,
                      );
                    },
                  ),
                  borderData: FlBorderData(show: false),
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((LineBarSpot spot) {
                          return LineTooltipItem(
                            '${spot.y.toStringAsFixed(2)}% of solutions\nused ${spot.x.toStringAsFixed(0)}ms of runtime',
                            const TextStyle(color: Colors.white),
                          );
                        }).toList();
                      },
                    ),
                    handleBuiltInTouches: true,
                  ),
                  clipData: const FlClipData.all(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
