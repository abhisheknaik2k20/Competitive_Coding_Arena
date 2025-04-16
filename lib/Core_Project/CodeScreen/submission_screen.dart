import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:competitivecodingarena/Core_Project/CodeScreen/analyze_complexity.dart';
import 'package:competitivecodingarena/Core_Project/Problemset/examples/exampleprobs.dart';
import 'package:dev_icons/dev_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_syntax_view/flutter_syntax_view.dart';

class Submissions extends StatefulWidget {
  final Problem problem;
  const Submissions({super.key, required this.problem});
  @override
  State<Submissions> createState() => _SubmissionsState();
}

class _SubmissionsState extends State<Submissions>
    with SingleTickerProviderStateMixin {
  bool isLoading = true;
  bool noSolutionsAvailable = false;
  String selectedCategory = "Python";
  Syntax selectedSyntax = Syntax.DART;
  final Map<String, SolutionData> _solutionData = {
    "Python": SolutionData(),
    "Java": SolutionData(),
    "Cpp": SolutionData()
  };

  @override
  void initState() {
    super.initState();
    _fetchAllSolutions();
  }

  Future<void> _fetchAllSolutions() async {
    try {
      final String currentUserId =
          FirebaseAuth.instance.currentUser!.displayName!;
      final String problemId = widget.problem.id;
      final FirebaseFirestore db = FirebaseFirestore.instance;
      final results = await Future.wait([
        db
            .collection("problems")
            .doc(problemId)
            .collection("python solutions")
            .orderBy("executionTime")
            .get(),
        db
            .collection("problems")
            .doc(problemId)
            .collection("java solutions")
            .orderBy("executionTime")
            .get(),
        db
            .collection("problems")
            .doc(problemId)
            .collection("cpp solutions")
            .orderBy("executionTime")
            .get()
      ]);
      final docs = [results[0].docs, results[1].docs, results[2].docs];
      final int totalSolutions =
          docs[0].length + docs[1].length + docs[2].length;
      if (mounted) {
        setState(() {
          _solutionData["Python"]!.solutions = docs[0];
          _solutionData["Java"]!.solutions = docs[1];
          _solutionData["Cpp"]!.solutions = docs[2];
          if (totalSolutions > 0) {
            _solutionData["Python"]!.percentage =
                (docs[0].length / totalSolutions) * 100;
            _solutionData["Java"]!.percentage =
                (docs[1].length / totalSolutions) * 100;
            _solutionData["Cpp"]!.percentage =
                (docs[2].length / totalSolutions) * 100;
          }
          try {
            _solutionData["Python"]!.userSolution = docs[0]
                .cast<QueryDocumentSnapshot<Map<String, dynamic>>>()
                .firstWhere((doc) => doc.data()['name'] == currentUserId)
                .data()['solution'];
          } catch (_) {}
          try {
            _solutionData["Java"]!.userSolution = docs[1]
                .cast<QueryDocumentSnapshot<Map<String, dynamic>>>()
                .firstWhere((doc) => doc.data()['name'] == currentUserId)
                .data()['solution'];
          } catch (_) {}
          try {
            _solutionData["Cpp"]!.userSolution = docs[2]
                .cast<QueryDocumentSnapshot<Map<String, dynamic>>>()
                .firstWhere((doc) => doc.data()['name'] == currentUserId)
                .data()['solution'];
          } catch (_) {}
          isLoading = false;
          noSolutionsAvailable = totalSolutions == 0;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
          noSolutionsAvailable = true;
        });
      }
    }
  }

  SolutionData get currentSolutionData => _solutionData[selectedCategory]!;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(actions: [_buildSegmentedButton()]),
        body: isLoading
            ? const Center(child: CircularProgressIndicator(color: Colors.blue))
            : SizedBox(
                height: size.height,
                width: size.width,
                child: Row(children: [
                  Expanded(
                      child: Container(
                          padding: const EdgeInsets.all(5),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                    decoration: BoxDecoration(
                                        color: Colors.teal.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: Colors.white, width: 2)),
                                    height: size.height * 0.35,
                                    child: _buildPieChart()),
                                SizedBox(
                                    height: size.height * 0.5,
                                    child: _buildSolutionList())
                              ]))),
                  Expanded(
                      child: Container(
                          padding: const EdgeInsets.all(5),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildRuntimeChart(),
                                _buildAnalyzeComplexity()
                              ])))
                ])));
  }

  Widget _buildSegmentedButton() => Container(
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(7), boxShadow: [
        BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4))
      ]),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(7),
          child: Material(
              color: Colors.transparent,
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                _buildSegmentButton('Python', 0, DevIcons.pythonPlain),
                _buildSegmentButton('Java', 1, DevIcons.javaPlain),
                _buildSegmentButton('C++', 2, DevIcons.cplusplusPlain)
              ]))));

  Widget _buildSegmentButton(String label, int index, IconData icon) {
    final categoryName = _getCategoryName(index);
    bool isSelected = selectedCategory == categoryName;
    return InkWell(
        onTap: () {
          if (selectedCategory != categoryName) {
            setState(() {
              selectedCategory = categoryName;
              selectedSyntax = _getSyntax(index);
            });
          }
        },
        child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
                gradient: isSelected
                    ? LinearGradient(
                        colors: [Colors.blue.shade400, Colors.blue.shade600],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight)
                    : null,
                color: isSelected ? null : Colors.grey.shade800),
            child: Row(children: [
              Icon(icon,
                  color: isSelected ? Colors.white : Colors.grey.shade300,
                  size: 18),
              const SizedBox(width: 8),
              Text(label,
                  style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey.shade300,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 14))
            ])));
  }

  Widget _buildPieChart() {
    final percentages = [
      _solutionData["Cpp"]!.percentage,
      _solutionData["Java"]!.percentage,
      _solutionData["Python"]!.percentage
    ];
    return Row(children: [
      Expanded(
          flex: 2,
          child: PieChart(
              PieChartData(sectionsSpace: 0, centerSpaceRadius: 40, sections: [
            for (int i = 0; i < percentages.length; i++)
              PieChartSectionData(
                  color: Colors.primaries[i % Colors.primaries.length],
                  value: percentages[i],
                  title: '${percentages[i].toStringAsFixed(1)}%',
                  radius: 100,
                  titleStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white))
          ]))),
      Expanded(
          flex: 1,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildIndicator(Colors.primaries[0], 'C++', percentages[0]),
                _buildIndicator(Colors.primaries[1], 'Java', percentages[1]),
                _buildIndicator(Colors.primaries[2], 'Python', percentages[2])
              ]))
    ]);
  }

  Widget _buildIndicator(Color color, String text, double percentage) =>
      Row(children: [
        Container(width: 16, height: 16, color: color),
        const SizedBox(width: 8),
        Text('$text: ${percentage.toStringAsFixed(1)}%',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
      ]);

  Widget _buildSolutionList() => SolutionList(
      solutions: currentSolutionData.solutions,
      currentUserId: FirebaseAuth.instance.currentUser!.displayName!,
      selectedSyntax: selectedSyntax);

  Widget _buildRuntimeChart() => RuntimeDistributionChart(
      solutions: currentSolutionData.solutions,
      selectedCategory: selectedCategory);

  Widget _buildAnalyzeComplexity() => AnalyzeComplexity(
      key: ValueKey(selectedCategory),
      providedCode: currentSolutionData.userSolution,
      syntax: selectedSyntax);

  String _getCategoryName(int index) {
    switch (index) {
      case 0:
        return "Python";
      case 1:
        return "Java";
      case 2:
        return "Cpp";
      default:
        return "Python";
    }
  }

  Syntax _getSyntax(int index) {
    switch (index) {
      case 0:
        return Syntax.DART;
      case 1:
        return Syntax.JAVA;
      case 2:
        return Syntax.CPP;
      default:
        return Syntax.DART;
    }
  }
}

class SolutionData {
  List<QueryDocumentSnapshot> solutions = [];
  double percentage = 0.0;
  String? userSolution;
}

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
  String executionTime = 'N/A';
  late List<FlSpot> histogramData;
  late double maxY;

  @override
  void initState() {
    super.initState();
    _processData();
  }

  @override
  void didUpdateWidget(RuntimeDistributionChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.solutions != oldWidget.solutions ||
        widget.selectedCategory != oldWidget.selectedCategory) {
      _processData();
    }
  }

  void _processData() {
    final String currentUserId =
        FirebaseAuth.instance.currentUser!.displayName!;
    final runtimes = widget.solutions.map((s) {
      final data = s.data() as Map<String, dynamic>;
      final time = data['executionTime'];
      final userId = data['name'];
      if (userId == currentUserId) executionTime = time.toString();
      return double.tryParse(time.toString()) ?? 200.0;
    }).toList();
    if (runtimes.isEmpty) {
      histogramData = [];
      maxY = 0;
      return;
    }
    runtimes.sort();
    final minRuntime = runtimes.first.floorToDouble();
    final maxRuntime = runtimes.last.ceilToDouble();
    final range = maxRuntime - minRuntime;
    final binCount = range > 100 ? 20 : 10;
    final binSize = range / binCount;
    histogramData = [];
    double highestPercentage = 0;
    for (int i = 0; i < binCount; i++) {
      final binStart = minRuntime + i * binSize;
      final binEnd = binStart + binSize;
      final count = runtimes.where((r) => r >= binStart && r < binEnd).length;
      final percentage = (count / runtimes.length) * 100;
      if (percentage > 0) {
        histogramData.add(FlSpot(binStart, percentage));
        if (percentage > highestPercentage) {
          highestPercentage = percentage;
        }
      }
    }
    maxY = highestPercentage * 1.1;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.solutions.isEmpty) {
      return const Center(
          child: Text('No runtime data available.',
              style: TextStyle(color: Colors.white)));
    }
    return Container(
        height: MediaQuery.of(context).size.height * 0.5,
        decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white, width: 2)),
        child: Padding(
            padding: const EdgeInsets.all(16),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('${widget.selectedCategory} Runtimes',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold))
              ]),
              const SizedBox(height: 8),
              Row(children: [
                Text('Your submission $executionTime',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold)),
                const SizedBox(width: 8),
                const Icon(Icons.bolt, color: Colors.purple, size: 18),
                Text('Analyze Complexity',
                    style: TextStyle(color: Colors.purple[300], fontSize: 12))
              ]),
              const SizedBox(height: 10),
              Expanded(
                  child: histogramData.isEmpty
                      ? const Center(
                          child: Text('Insufficient data for visualization',
                              style: TextStyle(color: Colors.white)))
                      : LineChart(_buildChartData()))
            ])));
  }

  LineChartData _buildChartData() => LineChartData(
          lineBarsData: [
            LineChartBarData(
                spots: histogramData,
                isCurved: true,
                color: Colors.blue,
                barWidth: 4,
                isStrokeCapRound: true,
                dotData: const FlDotData(show: false),
                belowBarData: BarAreaData(
                    show: true, color: Colors.blue.withOpacity(0.3)))
          ],
          minY: 0,
          maxY: maxY,
          titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) => Text(
                          '${value.toInt()}%',
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 10)))),
              bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) => Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text('${value.toInt()}ms',
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 10))))),
              topTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false))),
          gridData: FlGridData(
              show: true,
              drawHorizontalLine: true,
              drawVerticalLine: false,
              getDrawingHorizontalLine: (value) =>
                  FlLine(color: Colors.grey[800], strokeWidth: 1)),
          borderData: FlBorderData(show: false),
          lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
                  getTooltipItems: (touchedSpots) => touchedSpots
                      .map((spot) => LineTooltipItem(
                          '${spot.y.toStringAsFixed(2)}% of solutions\nused ${spot.x.toStringAsFixed(0)}ms of runtime', const TextStyle(color: Colors.white)))
                      .toList()),
              handleBuiltInTouches: true),
          clipData: const FlClipData.all());
}

class SolutionList extends StatefulWidget {
  final List<QueryDocumentSnapshot> solutions;
  final String currentUserId;
  final Syntax selectedSyntax;

  const SolutionList(
      {super.key,
      required this.solutions,
      required this.selectedSyntax,
      required this.currentUserId});

  @override
  State<SolutionList> createState() => _SolutionListState();
}

class _SolutionListState extends State<SolutionList> {
  final TextEditingController _searchController = TextEditingController();
  List<QueryDocumentSnapshot> filteredSolutions = [];
  final Map<String, Map<String, int>> _similarityCache = {};
  @override
  void initState() {
    super.initState();
    _initializeFilteredSolutions();
  }

  @override
  void didUpdateWidget(SolutionList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.solutions != oldWidget.solutions) {
      _initializeFilteredSolutions();
    }
  }

  void _initializeFilteredSolutions() =>
      setState(() => filteredSolutions = List.from(widget.solutions));

  void _filterSolutions(String query) {
    if (query.isEmpty) {
      setState(() => filteredSolutions = List.from(widget.solutions));
      return;
    }
    final lowercaseQuery = query.toLowerCase();
    setState(() {
      filteredSolutions = widget.solutions.where((solution) {
        final data = solution.data() as Map<String, dynamic>;
        final name = data['name'].toString().toLowerCase();
        return name.contains(lowercaseQuery);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.1),
          border: Border.all(color: Colors.white, width: 2),
          borderRadius: BorderRadius.circular(10)),
      child: Column(children: [
        Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                    hintText: 'Search by name',
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    filled: true,
                    fillColor: Colors.grey[800],
                    border:
                        const OutlineInputBorder(borderSide: BorderSide.none)),
                style: const TextStyle(color: Colors.white),
                onChanged: _filterSolutions)),
        Expanded(
            child: ListView.builder(
                itemCount: filteredSolutions.length,
                itemBuilder: (context, index) {
                  var data =
                      filteredSolutions[index].data() as Map<String, dynamic>;
                  bool isCurrentUserSolution =
                      data['name'] == widget.currentUserId;
                  String solutionCode = data['solution'] ?? 'No code available';
                  return Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      color: isCurrentUserSolution
                          ? Colors.teal[700]
                          : Colors.grey[850],
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: ExpansionTile(
                          leading: CircleAvatar(
                              backgroundColor: isCurrentUserSolution
                                  ? Colors.amber
                                  : Colors.blue,
                              child: Text('${index + 1}',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold))),
                          title: Text("Solution by ${data["name"]}",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18)),
                          subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 8),
                                _buildInfoRow(
                                    Icons.timer,
                                    "Execution Time: ${data['executionTime']}",
                                    Colors.blue[300]!),
                                const SizedBox(height: 4),
                                if (data['name'] != widget.currentUserId &&
                                    filteredSolutions.isNotEmpty)
                                  _buildInfoRow(
                                      Icons.code,
                                      "Similarity: ${_calculateSimilarityCached(solutionCode, filteredSolutions.first.get('solution'))}%",
                                      Colors.blue[300]!)
                              ]),
                          children: [
                            Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: SyntaxView(
                                    code: solutionCode,
                                    syntax: widget.selectedSyntax,
                                    syntaxTheme: SyntaxTheme.monokaiSublime(),
                                    fontSize: 12.0,
                                    withZoom: true,
                                    withLinesCount: true)),
                            OverflowBar(
                                alignment: MainAxisAlignment.end,
                                children: [
                                  TextButton.icon(
                                      icon: const Icon(Icons.thumb_up,
                                          color: Colors.green),
                                      label: Text('${data['likes'] ?? 0}'),
                                      onPressed: null),
                                  TextButton.icon(
                                      icon: const Icon(Icons.comment,
                                          color: Colors.blue),
                                      label: Text(
                                          '${data['comments']?.length ?? 0}'),
                                      onPressed: null)
                                ])
                          ]));
                }))
      ]));

  Widget _buildInfoRow(IconData icon, String text, Color color) =>
      Row(children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(text, style: TextStyle(color: color))
      ]);

  int _calculateSimilarityCached(String code1, String code2) {
    final key1 = '${code1.hashCode}-${code2.hashCode}';
    final key2 = '${code2.hashCode}-${code1.hashCode}';
    if (_similarityCache.containsKey(key1)) {
      return _similarityCache[key1]!['similarity']!;
    }
    if (_similarityCache.containsKey(key2)) {
      return _similarityCache[key2]!['similarity']!;
    }
    List<String> tokens1 = _tokenize(code1);
    List<String> tokens2 = _tokenize(code2);
    Set<String> set1 = Set<String>.from(tokens1);
    Set<String> set2 = Set<String>.from(tokens2);
    int intersectionSize = set1.intersection(set2).length;
    int unionSize = set1.union(set2).length;
    int similarity = ((intersectionSize / unionSize) * 100).toInt();
    _similarityCache[key1] = {'similarity': similarity};
    return similarity;
  }

  List<String> _tokenize(String code) => code
      .replaceAll(RegExp(r'(//.*)|(/\*.*?\*/)', dotAll: true), '')
      .replaceAll(RegExp(r'\s+'), '')
      .toLowerCase()
      .split(RegExp(r'([{}(),.;=+\-*/])'));

  @override
  void dispose() {
    _searchController.dispose();
    _similarityCache.clear();
    super.dispose();
  }
}
