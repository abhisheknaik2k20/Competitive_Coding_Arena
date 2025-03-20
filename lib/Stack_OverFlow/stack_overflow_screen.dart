import 'package:competitivecodingarena/Stack_OverFlow/problem_class.dart';
import 'package:competitivecodingarena/Stack_OverFlow/stack_screen_data.dart';
import 'package:dev_icons/dev_icons.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StackOverflowHomePage extends StatefulWidget {
  const StackOverflowHomePage({super.key});

  @override
  State<StackOverflowHomePage> createState() => _StackOverflowHomePageState();
}

class _StackOverflowHomePageState extends State<StackOverflowHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<TabItem> _tabs = [
    TabItem(icon: DevIcons.cplusplusLine, label: 'DSA', color: Colors.amber),
    TabItem(icon: DevIcons.html5Plain, label: 'WEB/DEV', color: Colors.blue),
    TabItem(icon: DevIcons.flutterPlain, label: 'MOBILE', color: Colors.teal),
  ];
  final CollectionReference _problemsCollection =
      FirebaseFirestore.instance.collection('stack_overflow_problems');
  List<StackOverFlowProblemClass> _allProblems = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging && mounted) setState(() {});
    });
    _fetchProblemsFromFirebase();
  }

  Future<void> _fetchProblemsFromFirebase() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      QuerySnapshot querySnapshot = await _problemsCollection.get();
      List<StackOverFlowProblemClass> problems = querySnapshot.docs.map((doc) {
        return StackOverFlowProblemClass.fromMap(
            doc.data() as Map<String, dynamic>);
      }).toList();
      if (mounted) {
        setState(() {
          _allProblems = problems;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Error fetching problems: $e';
          _isLoading = false;
        });
      }
      print('Error fetching problems: $e');
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.89,
      width: MediaQuery.of(context).size.width * 0.7,
      child: Column(
        children: [
          const SizedBox(height: 10),
          _buildAppBar(),
          _buildHeaderSection(),
          _buildCategoryNavBar(),
          Expanded(
            child: _isLoading
                ? _buildLoadingIndicator()
                : _errorMessage.isNotEmpty
                    ? _buildErrorMessage()
                    : TabBarView(
                        controller: _tabController,
                        children: ['DSA', 'WEB/DEV', 'MOBILE'].map((category) {
                          List<StackOverFlowProblemClass> tabProblems =
                              _allProblems
                                  .where(
                                      (problem) => problem.category == category)
                                  .toList();
                          return tabProblems.isEmpty
                              ? _buildEmptyState(category)
                              : _buildProblemsList(tabProblems);
                        }).toList(),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Loading questions...'),
        ],
      ),
    );
  }

  Widget _buildErrorMessage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          Text(_errorMessage, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _fetchProblemsFromFirebase,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String category) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.question_answer_outlined,
              size: 48, color: Colors.grey),
          const SizedBox(height: 16),
          Text('No questions found in $category category'),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add),
            label: const Text('Ask a question'),
          ),
        ],
      ),
    );
  }

  Widget _buildProblemsList(List<StackOverFlowProblemClass> problems) {
    return ListView.builder(
      itemCount: problems.length,
      itemBuilder: (context, index) => BuildQuestionItem(
        stflow_instance: problems[index],
      ),
    );
  }

  Widget _buildAppBar() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: 90,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            child: Image.asset('assets/images/stflow.png', height: 80),
          ),
          const SizedBox(width: 12),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "stack",
                  style: TextStyle(
                    fontSize: 40,
                    color: isDark ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                TextSpan(
                  text: "overflow",
                  style: TextStyle(
                    fontSize: 40,
                    color: Colors.blue.shade600,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCategoryNavBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Column(
        children: [
          TabBar(
            controller: _tabController,
            isScrollable: true,
            indicatorWeight: 1,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorColor: Colors.transparent,
            labelColor: _tabs[_tabController.index].color,
            tabs: _tabs
                .map((tab) => _buildTabItem(
                    tab, _tabs.indexOf(tab) == _tabController.index))
                .toList(),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Spacer(),
              _buildActionButton(Icons.filter_list, 'Filter'),
              const SizedBox(width: 16),
              _buildActionButton(Icons.sort, 'Newest'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: isDark ? Colors.grey.shade300 : Colors.blue),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.blue),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 4),
          const Icon(Icons.arrow_drop_down, size: 20),
        ],
      ),
    );
  }

  Widget _buildTabItem(TabItem tab, bool isSelected) {
    return Tab(
      height: 50,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? tab.color.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(tab.icon,
                size: 20, color: isSelected ? tab.color : Colors.grey),
            const SizedBox(width: 8),
            Text(
              tab.label,
              style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'All Questions',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  
                  _isLoading ? '...' : '${_allProblems.length}',
                  style: const TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.bold),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: 500,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search for questions...',
                    hintStyle: const TextStyle(color: Colors.blueAccent),
                    prefixIcon: Icon(Icons.search, color: Colors.blue.shade600),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.blue),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue)),
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Row(
                children: [
                  const Icon(Icons.trending_up, color: Colors.green, size: 18),
                  const SizedBox(width: 4),
                  Text(
                    _isLoading
                        ? 'Loading...'
                        : '${_allProblems.length} questions',
                    style: TextStyle(
                      color: isDark ? Colors.grey[300] : Colors.grey[900],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade600,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  elevation: 2,
                ),
                icon: const Icon(Icons.add_circle_outline, color: Colors.white),
                label: const Text('Ask Question'),
              ),
            ],
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
