import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BuildPieChart extends StatelessWidget {
  final double pythonPercentage;
  final double javaPercentage;
  final double cppPercentage;
  const BuildPieChart(
      {required this.cppPercentage,
      required this.javaPercentage,
      required this.pythonPercentage,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: PieChart(
            PieChartData(
              sectionsSpace: 0,
              centerSpaceRadius: 40,
              sections: [
                PieChartSectionData(
                  color: Colors.teal,
                  value: pythonPercentage,
                  title: '${pythonPercentage.toStringAsFixed(1)}%',
                  radius: 100,
                  titleStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                PieChartSectionData(
                  color: Colors.amber,
                  value: javaPercentage,
                  title: '${javaPercentage.toStringAsFixed(1)}%',
                  radius: 100,
                  titleStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                PieChartSectionData(
                  color: Colors.pink,
                  value: cppPercentage,
                  title: '${cppPercentage.toStringAsFixed(1)}%',
                  radius: 100,
                  titleStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildIndicator(Colors.teal, 'Python', pythonPercentage),
              const SizedBox(height: 8),
              _buildIndicator(Colors.amber, 'Java', javaPercentage),
              const SizedBox(height: 8),
              _buildIndicator(Colors.pink, 'C++', cppPercentage),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIndicator(Color color, String text, double percentage) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          color: color,
        ),
        const SizedBox(width: 8),
        Text(
          '$text: ${percentage.toStringAsFixed(1)}%',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
