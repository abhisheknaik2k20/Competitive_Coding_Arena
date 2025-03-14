import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_syntax_view/flutter_syntax_view.dart';

class SolutionList extends StatefulWidget {
  final List<QueryDocumentSnapshot> solutions;
  final String currentUserId;
  final Syntax selectedSyntax;

  const SolutionList({
    super.key,
    required this.solutions,
    required this.selectedSyntax,
    required this.currentUserId,
  });

  @override
  State<SolutionList> createState() => _SolutionListState();
}

class _SolutionListState extends State<SolutionList> {
  final TextEditingController _searchController = TextEditingController();
  List<QueryDocumentSnapshot> filteredSolutions = [];

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

  void _initializeFilteredSolutions() {
    setState(() {
      filteredSolutions = List.from(widget.solutions);
    });
  }

  void _filterSolutions(String query) {
    setState(() {
      filteredSolutions = widget.solutions.where((solution) {
        final data = solution.data() as Map<String, dynamic>;
        final name = data['name'].toString().toLowerCase();
        return name.contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        border: Border.all(color: Colors.white, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by name',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[800],
                border: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
              ),
              style: const TextStyle(color: Colors.white),
              onChanged: _filterSolutions,
            ),
          ),
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
                  margin:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  color: isCurrentUserSolution
                      ? Colors.teal[700]
                      : Colors.grey[850],
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: ExpansionTile(
                    leading: CircleAvatar(
                      backgroundColor:
                          isCurrentUserSolution ? Colors.amber : Colors.blue,
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text(
                      "Solution by ${data["name"]}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        _buildInfoRow(
                          Icons.timer,
                          "Execution Time: ${data['executionTime']}",
                          Colors.blue[300]!,
                        ),
                        const SizedBox(height: 4),
                        _buildInfoRow(
                          Icons.code,
                          data['name'] !=
                                  FirebaseAuth.instance.currentUser!.displayName
                              ? "Similarity: ${calculateSimilarity(solutionCode, widget.solutions.first.get('solution'))}%"
                              : " ",
                          Colors.blue[300]!,
                        ),
                      ],
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SyntaxView(
                          code: solutionCode,
                          syntax: widget.selectedSyntax,
                          syntaxTheme: SyntaxTheme.monokaiSublime(),
                          fontSize: 12.0,
                          withZoom: true,
                          withLinesCount: true,
                        ),
                      ),
                      OverflowBar(
                        alignment: MainAxisAlignment.end,
                        children: [
                          TextButton.icon(
                            icon:
                                const Icon(Icons.thumb_up, color: Colors.green),
                            label: Text('${data['likes'] ?? 0}'),
                            onPressed: () {
                              // Implement like functionality
                            },
                          ),
                          TextButton.icon(
                            icon: const Icon(Icons.comment, color: Colors.blue),
                            label: Text('${data['comments']?.length ?? 0}'),
                            onPressed: () {
                              // Navigate to comments section
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(text, style: TextStyle(color: color)),
      ],
    );
  }

  int calculateSimilarity(String code1, String code2) {
    List<String> tokens1 = _tokenize(code1);
    List<String> tokens2 = _tokenize(code2);

    Set<String> set1 = Set<String>.from(tokens1);
    Set<String> set2 = Set<String>.from(tokens2);

    int intersectionSize = set1.intersection(set2).length;
    int unionSize = set1.union(set2).length;

    return ((intersectionSize / unionSize) * 100).toInt();
  }

  List<String> _tokenize(String code) {
    code = code.replaceAll(RegExp(r'//.*'), '');
    code = code.replaceAll(RegExp(r'/\*.*?\*/', dotAll: true), '');
    code = code.replaceAll(RegExp(r'\s+'), '');
    code = code.toLowerCase();
    return code.split(RegExp(r'([{}(),.;=+\-*/])'));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
