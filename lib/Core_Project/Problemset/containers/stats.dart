import 'package:easy_pie_chart/easy_pie_chart.dart';
import 'package:flutter/material.dart';

class PersonalStats extends StatefulWidget {
  const PersonalStats({super.key});

  @override
  State<PersonalStats> createState() => _PersonalStatsState();
}

class _PersonalStatsState extends State<PersonalStats> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        final availableHeight = constraints.maxHeight;
        final chartSize = _calculateChartSize(availableWidth, availableHeight);

        return Container(
          padding: EdgeInsets.only(
              bottom: chartSize * 0.2,
              top: chartSize * 0.1,
              left: chartSize * 0.1,
              right: chartSize * 0.1),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: isDarkMode
                ? Colors.white.withOpacity(0.1)
                : Colors.blue.withOpacity(0.4),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              FittedBox(
                child: Text(
                  'Progress',
                  style: TextStyle(
                    fontSize: chartSize * 0.15,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
              ),
              SizedBox(height: chartSize * 0.08),
              // Main content
              Flexible(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Left side: Pie Chart
                    Expanded(
                      flex: 3,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: EasyPieChart(
                          style: TextStyle(
                            fontSize: chartSize * 0.1,
                            color: isDarkMode ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                          size: chartSize,
                          borderEdge: StrokeCap.butt,
                          start: -180,
                          children: [
                            PieData(value: 20, color: Colors.teal.shade400),
                            PieData(value: 5, color: Colors.amber.shade400),
                            PieData(value: 5, color: Colors.pink.shade400),
                            PieData(
                              value: 70,
                              color: (isDarkMode ? Colors.white : Colors.black)
                                  .withOpacity(0.1),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Right side: Statistics
                    Expanded(
                      flex: 2,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildDifficultyRow(
                              'Easy',
                              '20',
                              '56',
                              Colors.teal.shade400,
                              isDarkMode,
                              chartSize,
                            ),
                            SizedBox(height: chartSize * 0.08),
                            _buildDifficultyRow(
                              'Medium',
                              '5',
                              '56',
                              Colors.amber.shade400,
                              isDarkMode,
                              chartSize,
                            ),
                            SizedBox(height: chartSize * 0.08),
                            _buildDifficultyRow(
                              'Hard',
                              '5',
                              '56',
                              Colors.pink.shade400,
                              isDarkMode,
                              chartSize,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  double _calculateChartSize(double width, double height) {
    final minDimension = width < height ? width : height;
    return minDimension * 0.35; // Reduced from 0.4 to accommodate title
  }

  Widget _buildDifficultyRow(
    String difficulty,
    String solved,
    String total,
    Color color,
    bool isDarkMode,
    double baseSize,
  ) {
    final fontSize = baseSize * 0.12;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: baseSize * 0.06,
          height: baseSize * 0.06,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: baseSize * 0.04),
        Text(
          difficulty,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w500,
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
        SizedBox(width: baseSize * 0.04),
        Text(
          '$solved/$total',
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
            color: isDarkMode ? Colors.white70 : Colors.black54,
          ),
        ),
      ],
    );
  }
}
