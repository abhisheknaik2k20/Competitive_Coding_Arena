import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:competitivecodingarena/Core_Project/CodeScreen/blackscreen.dart';
import 'package:competitivecodingarena/Core_Project/Problemset/containers/companies.dart';
import 'package:competitivecodingarena/Core_Project/Problemset/examples/exampleprobs.dart';
import 'package:competitivecodingarena/Core_Project/Problemset/containers/stats.dart';
import 'package:competitivecodingarena/Snackbars&Pbars/snackbars.dart';

class ProblemsetMenu extends StatefulWidget {
  final Size size;
  const ProblemsetMenu({required this.size, super.key});

  @override
  State<ProblemsetMenu> createState() => _ProblemsetMenuState();
}

class _ProblemsetMenuState extends State<ProblemsetMenu>
    with SingleTickerProviderStateMixin {
  List<Problem> problems = [];
  List<Problem> filteredProblems = [];
  String searchQuery = "";
  String difficultyFilter = "All";
  String statusFilter = "All";
  String frequencyFilter = "All";
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    if (mounted) {
      fetchProblemsFromFirestore();
      _animationController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
      )..forward();
    }
  }

  Future<void> fetchProblemsFromFirestore() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final CollectionReference problemsCollection =
        firestore.collection('problems');

    try {
      QuerySnapshot querySnapshot = await problemsCollection.get();
      List<Problem> fetchedProblems =
          querySnapshot.docs.map((doc) => Problem.fromFirestore(doc)).toList();
      if (mounted) {
        setState(() {
          problems = fetchedProblems;
          filteredProblems = problems;
          _animationController.forward(from: 0.0);
        });
      }
    } on FirebaseException catch (e) {
      if (mounted) {
        setState(() {
          showSnackBar(context, e.code);
        });
      }
    }
  }

  void filterProblems() {
    setState(() {
      filteredProblems = problems.where((problem) {
        bool matchesSearch =
            problem.title.toLowerCase().contains(searchQuery.toLowerCase());
        bool matchesDifficulty =
            difficultyFilter == "All" || problem.difficulty == difficultyFilter;
        bool matchesStatus =
            statusFilter == "All" || problem.status == statusFilter;
        bool matchesFrequency =
            frequencyFilter == "All" || problem.frequency == frequencyFilter;
        return matchesSearch &&
            matchesDifficulty &&
            matchesStatus &&
            matchesFrequency;
      }).toList();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Row(
        children: [
          SizedBox(width: widget.size.width * 0.127),
          Container(
            padding: EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.blue.withOpacity(0.4)
                  : Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            height: 550,
            width: widget.size.width * 0.5,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 35,
                    child: TextField(
                      onChanged: (value) {
                        searchQuery = value;
                        filterProblems();
                      },
                      cursorHeight: 15.0,
                      style: const TextStyle(fontSize: 10),
                      decoration: const InputDecoration(
                        labelText: "Search",
                        labelStyle: TextStyle(
                            fontSize: 10, fontWeight: FontWeight.bold),
                        prefixIcon: Icon(
                          Icons.search,
                          size: 10,
                        ),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Difficulty',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          height: 35,
                          child: buildDropdownFilter(
                              "Difficulty",
                              ["All", "Easy", "Medium", "Hard"],
                              difficultyFilter, (value) {
                            setState(() {
                              difficultyFilter = value!;
                              filterProblems();
                            });
                          }),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          'Status',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          height: 35,
                          child: buildDropdownFilter(
                              "Status",
                              ["All", "Solved", "Attempted", "Todo"],
                              statusFilter, (value) {
                            setState(() {
                              statusFilter = value!;
                              filterProblems();
                            });
                          }),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          'Frequency',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          height: 35,
                          child: buildDropdownFilter(
                              "Frequency",
                              ["All", "High", "Medium", "Low"],
                              frequencyFilter, (value) {
                            setState(() {
                              frequencyFilter = value!;
                              filterProblems();
                            });
                          }),
                        ),
                      ],
                    ),
                  ],
                ),
                Expanded(
                  child: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context)
                        .copyWith(scrollbars: false),
                    child: ListView.builder(
                      itemCount: filteredProblems.length,
                      itemBuilder: (context, index) {
                        Problem problem = filteredProblems[index];
                        return AnimatedBuilder(
                          animation: _animationController,
                          builder: (context, child) {
                            final double animationValue = CurvedAnimation(
                              parent: _animationController,
                              curve: Curves.easeInOut,
                            ).value;
                            return Transform.translate(
                              offset: Offset(0, 50 * (1 - animationValue)),
                              child: Opacity(
                                opacity: animationValue,
                                child: child,
                              ),
                            );
                          },
                          child: ListTile(
                            minVerticalPadding: 10,
                            title: Text(
                              problem.title,
                              style: const TextStyle(
                                  fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              "Acceptance: ${problem.acceptanceRate.toStringAsFixed(1)}%",
                              style: const TextStyle(
                                  fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                            trailing: Text(
                              problem.difficulty,
                              style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: problem.difficulty == 'Easy'
                                      ? Colors.teal
                                      : problem.difficulty == 'Medium'
                                          ? Colors.amber
                                          : Colors.pink),
                            ),
                            leading: Icon(
                              size: 15,
                              problem.status == "Solved"
                                  ? Icons.circle
                                  : problem.status == 'Attempted'
                                      ? Icons.circle
                                      : Icons.circle_outlined,
                              color: problem.status == "Solved"
                                  ? Colors.green
                                  : problem.status == 'Attempted'
                                      ? Colors.amber
                                      : Colors.grey,
                            ),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => BlackScreen(
                                  teamid: null,
                                  isOnline: false,
                                  problem: problem,
                                  size: MediaQuery.sizeOf(context),
                                ),
                              ));
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 5),
          Container(
            padding: const EdgeInsets.all(5),
            height: 600,
            width: widget.size.width * 0.199,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [Companies(), PersonalStats()],
            ),
          )
        ],
      ),
    );
  }

  Widget buildDropdownFilter(String label, List<String> items,
      String currentValue, void Function(String?) onChanged) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: DropdownButton<String>(
        value: currentValue,
        onChanged: onChanged,
        items: items.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: const TextStyle(fontSize: 10),
            ),
          );
        }).toList(),
        hint: Text(
          label,
          style: const TextStyle(fontSize: 10),
        ),
      ),
    );
  }
}

class FadeSlidePageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;

  FadeSlidePageRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var begin = const Offset(1.0, 0.0);
            var end = Offset.zero;
            var curve = Curves.easeInOutCubic;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            var fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(parent: animation, curve: curve),
            );

            return FadeTransition(
              opacity: fadeAnimation,
              child: SlideTransition(
                position: offsetAnimation,
                child: child,
              ),
            );
          },
          transitionDuration: const Duration(milliseconds: 500),
        );
}
