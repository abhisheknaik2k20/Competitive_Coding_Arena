import 'package:competitivecodingarena/API_KEYS/api.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_syntax_view/flutter_syntax_view.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:convert';
import 'dart:math' as math;

class AnalyzeComplexity extends StatefulWidget {
  final String? providedCode;
  final Syntax? syntax;
  const AnalyzeComplexity({this.providedCode, this.syntax, super.key});
  @override
  State<AnalyzeComplexity> createState() => _AnalyzeComplexityState();
}

class _AnalyzeComplexityState extends State<AnalyzeComplexity> {
  final TextEditingController _codeController = TextEditingController();
  String _timeComplexity = '';
  String _spaceComplexity = '';
  String _improvements = '';
  List<FlSpot>? _complexityData;
  bool _isLoading = false;
  bool _isEditing = false;
  String _errorMessage = '';
  static const int _maxInputSize = 10;
  static const int _pointCount = 20;
  @override
  void initState() {
    super.initState();
    if (widget.providedCode != null) {
      _codeController.text = widget.providedCode!;
    }
  }

  @override
  void didUpdateWidget(AnalyzeComplexity oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.providedCode != oldWidget.providedCode &&
        widget.providedCode != null) {
      _codeController.text = widget.providedCode!;
    }
  }

  List<FlSpot> _generateComplexityGraph(String bigONotation) {
    final String notation = bigONotation.toLowerCase().replaceAll(' ', '');
    final List<FlSpot> spots = [];
    final double step = _maxInputSize / _pointCount;
    for (int i = 0; i <= _pointCount; i++) {
      final double x = i * step;
      spots.add(FlSpot(x, _calculateComplexity(x, notation)));
    }
    return spots;
  }

  double _calculateComplexity(double n, String notation) {
    switch (notation) {
      case 'o(1)':
        return 1;
      case 'o(logn)':
        return n == 0 ? 0 : math.log(n + 1);
      case 'o(n)':
        return n;
      case 'o(nlogn)':
        return n * (n == 0 ? 0 : math.log(n + 1));
      case 'o(n²)':
      case 'o(n^2)':
        return n * n;
      case 'o(2^n)':
        return math.pow(2, n).toDouble();
      case 'o(n!)':
        return n <= 1 ? n : n * _calculateComplexity(n - 1, 'o(n!)');
      default:
        return n;
    }
  }

  Future<void> _analyzeComplexity() async {
    if (_codeController.text.isEmpty) return;
    setState(() {
      _isLoading = true;
      _errorMessage = '';
      _timeComplexity = '';
      _spaceComplexity = '';
      _improvements = '';
      _complexityData = null;
    });
    try {
      final model =
          GenerativeModel(model: 'gemini-1.5-pro', apiKey: ApiKeys().geminiAPI);
      final prompt = '''
You are a code complexity analyzer. Analyze the following code and respond with ONLY a JSON object in the exact format shown below. Do not include any additional text, explanations, or formatting.

Code to analyze:
${_codeController.text}

Required JSON format:
{
  "Time_Complexity": return_complexity,
  "Space_Complexity": return_space_complexity,
  "Improvements": return_improvement
}

Rules:
- Time_Complexity and Space_Complexity should be in Big O notation (e.g., "O(n)", "O(1)", "O(n²)")
- Improvements should be a single line
- Do not include any text before or after the JSON object
- Ensure the response is valid JSON
''';
      final response = await model.generateContent([Content.text(prompt)]);
      final String? rawText = response.text;
      if (rawText == null || rawText.isEmpty) {
        throw Exception('No response received from Gemini API');
      }
      String cleanedResponse = rawText.trim();
      if (cleanedResponse.startsWith('```') &&
          cleanedResponse.endsWith('```')) {
        cleanedResponse = cleanedResponse
            .substring(3, cleanedResponse.length - 3)
            .replaceAll('```json', '')
            .trim();
      }
      if (cleanedResponse.toLowerCase().startsWith('json')) {
        cleanedResponse = cleanedResponse.substring(4).trim();
      }
      final Map<String, dynamic> jsonResponse = jsonDecode(cleanedResponse);
      final timeComplexity = jsonResponse['Time_Complexity'];
      final spaceComplexity = jsonResponse['Space_Complexity'];
      final improvements = jsonResponse['Improvements'];
      if (timeComplexity == null ||
          spaceComplexity == null ||
          improvements == null) {
        throw const FormatException('Missing required fields in response');
      }
      setState(() {
        _timeComplexity = timeComplexity;
        _spaceComplexity = spaceComplexity;
        _improvements = improvements;
        _complexityData = _generateComplexityGraph(timeComplexity);
      });
    } catch (e) {
      setState(() => _errorMessage = 'Error: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) => Container(
      height: MediaQuery.of(context).size.height * 0.4,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white, width: 2)),
      child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            _buildCodeEditor(),
            const SizedBox(height: 16),
            _buildActionButtons(),
            const SizedBox(height: 24),
            if (_errorMessage.isNotEmpty) _buildErrorMessage(),
            if (_timeComplexity.isNotEmpty) _buildAnalysisResults()
          ])));

  Widget _buildCodeEditor() => Container(
      alignment: Alignment.center,
      height: 300,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(10)),
      child: _isEditing
          ? TextField(
              controller: _codeController,
              maxLines: null,
              decoration: const InputDecoration(
                  hintText: 'Enter or paste your code here',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16)),
              style: const TextStyle(fontFamily: 'Courier', fontSize: 14))
          : SyntaxView(
              code: _codeController.text,
              syntax: widget.syntax ?? Syntax.DART,
              syntaxTheme: SyntaxTheme.vscodeDark(),
              fontSize: 14.0,
              withZoom: true,
              withLinesCount: true));

  Widget _buildActionButtons() =>
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        ElevatedButton.icon(
            onPressed: () => setState(() => _isEditing = !_isEditing),
            icon: Icon(_isEditing ? Icons.visibility : Icons.edit),
            label: Text(_isEditing ? 'View Code' : 'Edit Code'),
            style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue[700],
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 22),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)))),
        ElevatedButton.icon(
            onPressed: _isLoading ? null : _analyzeComplexity,
            icon: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.white)))
                : const Icon(Icons.analytics),
            label: Text(_isLoading ? 'Analyzing...' : 'Analyze Complexity'),
            style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.green[700],
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 22),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5))))
      ]);

  Widget _buildErrorMessage() => Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
          color: Colors.red[100], borderRadius: BorderRadius.circular(10)),
      child: Text(_errorMessage, style: const TextStyle(color: Colors.red)));

  Widget _buildAnalysisResults() =>
      Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        const Text('Complexity Analysis:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text('Time Complexity: $_timeComplexity'),
        Text('Space Complexity: $_spaceComplexity'),
        const SizedBox(height: 16),
        const Text('Suggested Improvements:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Text(_improvements),
        if (_complexityData != null) ...[
          const SizedBox(height: 24),
          _buildComplexityChart()
        ]
      ]);

  Widget _buildComplexityChart() => Container(
      padding: const EdgeInsets.all(16),
      height: 300,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Time Complexity Growth',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Expanded(
            child: LineChart(LineChartData(
                gridData: const FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    horizontalInterval: 1,
                    verticalInterval: 1),
                titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 30,
                            interval: 2,
                            getTitlesWidget: (value, meta) =>
                                Text('n=${value.toInt()}'))),
                    leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 50,
                            interval: 2,
                            getTitlesWidget: (value, meta) =>
                                Text('T(n)${value.toInt()}'))),
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false))),
                borderData: FlBorderData(show: true),
                lineBarsData: [
                  LineChartBarData(
                      spots: _complexityData!,
                      isCurved: true,
                      color: Colors.blue[700],
                      barWidth: 3,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                          show: true,
                          color: Colors.blue[200]!.withOpacity(0.3)))
                ],
                minY: 0)))
      ]));

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }
}
