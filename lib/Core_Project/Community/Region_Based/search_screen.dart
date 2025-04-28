import 'dart:math';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';

// Data models
class Institution {
  final String id;
  final String name;
  final String type;
  final String description;
  final List<String> tags;

  Institution({
    required this.id,
    required this.name,
    required this.type,
    required this.description,
    this.tags = const [],
  });
}

class Region {
  final String id;
  final String name;
  final List<String> subregions;
  final List<Institution> institutions;

  Region(
      {required this.id,
      required this.name,
      this.subregions = const [],
      this.institutions = const []});
}

enum ViewMode { regions, institutions }

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  late TextEditingController _searchController;
  String _searchQuery = '';
  List<Region> regions = [];
  List<Institution> allInstitutions = [];
  List<Region> _filteredRegions = [];
  List<Institution> _filteredInstitutions = [];
  FilterOptions _filterOptions = FilterOptions();
  bool _isAdvancedSearchVisible = false;
  ViewMode _currentViewMode = ViewMode.regions;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    initializeData();
    _filteredRegions = regions;
    _filteredInstitutions = allInstitutions;
  }

  void initializeData() {
    List<Institution> institutions = [
      Institution(
        id: 'inst1',
        name: 'Indian Institute of Technology Bombay',
        type: 'University',
        description: 'Premier engineering institute in India',
        tags: ['Research', 'Engineering', 'Technology'],
      ),
      Institution(
        id: 'inst2',
        name: 'Tata Consultancy Services',
        type: 'Company',
        description: 'Global IT services and consulting company',
        tags: ['Technology', 'Software', 'IT Services'],
      ),
      Institution(
        id: 'inst3',
        name: 'Indian Institute of Science',
        type: 'University',
        description: 'Top research institution for science and engineering',
        tags: ['Research', 'Science', 'Engineering'],
      ),
      Institution(
        id: 'inst4',
        name: 'All India Institute of Medical Sciences',
        type: 'University',
        description: 'Leading medical research and education institute',
        tags: ['Medical', 'Research', 'Healthcare'],
      ),
      Institution(
        id: 'inst5',
        name: 'Infosys',
        type: 'Company',
        description: 'Multinational IT services and consulting company',
        tags: ['Technology', 'Software', 'Cloud'],
      ),
      Institution(
        id: 'inst6',
        name: 'Indian Institute of Technology Delhi',
        type: 'University',
        description: 'One of India’s top engineering institutes',
        tags: ['Engineering', 'Technology', 'Research'],
      ),
      Institution(
        id: 'inst7',
        name: 'Wipro',
        type: 'Company',
        description: 'IT services and consulting corporation',
        tags: ['Technology', 'Software', 'IT Services'],
      ),
      Institution(
        id: 'inst8',
        name: 'National Institute of Technology Trichy',
        type: 'University',
        description: 'Top engineering institute in India',
        tags: ['Engineering', 'Research', 'Technology'],
      ),
      Institution(
        id: 'inst9',
        name: 'HCL Technologies',
        type: 'Company',
        description: 'Global IT services and software company',
        tags: ['Technology', 'Software', 'Consulting'],
      ),
      Institution(
        id: 'inst10',
        name: 'Indian Statistical Institute',
        type: 'University',
        description: 'Institute focused on statistics and data sciences',
        tags: ['Statistics', 'Mathematics', 'Research'],
      ),
      Institution(
        id: 'inst11',
        name: 'Birla Institute of Technology and Science Pilani',
        type: 'University',
        description: 'Premier private engineering and research institute',
        tags: ['Engineering', 'Research', 'Technology'],
      ),
      Institution(
        id: 'inst12',
        name: 'Reliance Industries',
        type: 'Company',
        description:
            'Conglomerate with interests in telecom, energy, and retail',
        tags: ['Business', 'Technology', 'Energy'],
      ),
      Institution(
        id: 'inst13',
        name: 'Indian Institute of Management Ahmedabad',
        type: 'University',
        description: 'India’s top business and management school',
        tags: ['Management', 'Business', 'Finance'],
      ),
      Institution(
        id: 'inst14',
        name: 'Vellore Institute of Technology',
        type: 'University',
        description: 'Private university known for technology and research',
        tags: ['Engineering', 'Research', 'Technology'],
      ),
      Institution(
        id: 'inst15',
        name: 'Mahindra & Mahindra',
        type: 'Company',
        description: 'Automobile and technology corporation',
        tags: ['Automobile', 'Technology', 'Manufacturing'],
      ),
      Institution(
        id: 'inst16',
        name: 'Indian Institute of Technology Kharagpur',
        type: 'University',
        description:
            'First IIT established in India, known for engineering and research',
        tags: ['Engineering', 'Research', 'Technology'],
      ),
      Institution(
        id: 'inst17',
        name: 'Indian Space Research Organisation',
        type: 'Company',
        description:
            'Government space agency responsible for India’s space exploration',
        tags: ['Aerospace', 'Research', 'Technology'],
      ),
      Institution(
        id: 'inst18',
        name: 'Ashoka University',
        type: 'University',
        description: 'Private liberal arts university with focus on research',
        tags: ['Liberal Arts', 'Research', 'Education'],
      ),
      Institution(
        id: 'inst19',
        name: 'Amazon India',
        type: 'Company',
        description:
            'E-commerce and cloud services giant with major operations in India',
        tags: ['E-commerce', 'Cloud', 'Technology'],
      ),
      Institution(
        id: 'inst20',
        name: 'Indian Institute of Technology Madras',
        type: 'University',
        description:
            'Top IIT known for innovation, research, and entrepreneurship',
        tags: ['Engineering', 'Research', 'Entrepreneurship'],
      ),
      Institution(
        id: 'inst21',
        name: 'Thadomal Shahani Engineering College',
        type: 'University',
        description:
            'One of Mumbai’s top private engineering colleges, known for technology and innovation',
        tags: ['Engineering', 'Technology', 'Education'],
      ),
    ];

    allInstitutions = institutions;
    List<Region> genregions = [
      Region(
        id: 'reg1',
        name: 'Mumbai Region',
        subregions: ['Mumbai, Maharashtra', 'Pune, Maharashtra'],
        institutions: institutions
            .where(
                (i) => i.id == 'inst1' || i.id == 'inst12' || i.id == 'inst21')
            .toList(),
      ),
      Region(
        id: 'reg2',
        name: 'Bangalore Region',
        subregions: ['Bangalore, Karnataka'],
        institutions: institutions
            .where((i) => i.id == 'inst3' || i.id == 'inst5' || i.id == 'inst7')
            .toList(),
      ),
      Region(
        id: 'reg3',
        name: 'Delhi NCR Region',
        subregions: ['New Delhi', 'Gurgaon', 'Noida'],
        institutions: institutions
            .where((i) => i.id == 'inst4' || i.id == 'inst6' || i.id == 'inst9')
            .toList(),
      ),
      Region(
        id: 'reg4',
        name: 'Chennai Region',
        subregions: ['Chennai, Tamil Nadu'],
        institutions: institutions
            .where((i) => i.id == 'inst8' || i.id == 'inst14')
            .toList(),
      ),
      Region(
        id: 'reg5',
        name: 'Kolkata Region',
        subregions: ['Kolkata, West Bengal'],
        institutions: institutions
            .where((i) => i.id == 'inst10' || i.id == 'inst16')
            .toList(),
      ),
      Region(
        id: 'reg6',
        name: 'Ahmedabad Region',
        subregions: ['Ahmedabad, Gujarat'],
        institutions: institutions.where((i) => i.id == 'inst13').toList(),
      ),
      Region(
        id: 'reg7',
        name: 'Pilani Region',
        subregions: ['Pilani, Rajasthan'],
        institutions: institutions.where((i) => i.id == 'inst11').toList(),
      ),
      Region(
        id: 'reg8',
        name: 'Hyderabad Region',
        subregions: ['Hyderabad, Telangana'],
        institutions: institutions.where((i) => i.id == 'inst17').toList(),
      ),
      Region(
        id: 'reg9',
        name: 'Pan India',
        subregions: ['Multiple Locations'],
        institutions: institutions
            .where((i) => i.id == 'inst2' || i.id == 'inst15')
            .toList(),
      ),
      Region(
        id: 'reg10',
        name: 'E-commerce Hubs',
        subregions: ['Bangalore', 'Hyderabad', 'Mumbai'],
        institutions: institutions.where((i) => i.id == 'inst19').toList(),
      ),
    ];
    regions = genregions;
  }

  void _performSearch(String query) {
    setState(() {
      _searchQuery = query;
      _applyFilters();
    });
  }

  void _applyFilters() {
    // Filter regions
    _filteredRegions = regions.where((region) {
      // Filter by search query
      bool matchesQuery = _searchQuery.isEmpty ||
          region.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          region.subregions.any((subregion) =>
              subregion.toLowerCase().contains(_searchQuery.toLowerCase())) ||
          region.institutions.any((institution) => institution.name
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()));

      // Filter by institution type if selected
      bool matchesType = !_filterOptions.filterByType ||
          region.institutions.any((institution) =>
              _filterOptions.selectedTypes.contains(institution.type));

      // Filter by tags if any selected
      bool matchesTags = _filterOptions.selectedTags.isEmpty ||
          region.institutions.any((institution) => institution.tags
              .any((tag) => _filterOptions.selectedTags.contains(tag)));

      return matchesQuery && matchesType && matchesTags;
    }).toList();

    _filteredInstitutions = allInstitutions.where((institution) {
      bool matchesQuery = _searchQuery.isEmpty ||
          institution.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          institution.description
              .toLowerCase()
              .contains(_searchQuery.toLowerCase());

      bool matchesType = !_filterOptions.filterByType ||
          _filterOptions.selectedTypes.contains(institution.type);

      bool matchesTags = _filterOptions.selectedTags.isEmpty ||
          institution.tags
              .any((tag) => _filterOptions.selectedTags.contains(tag));

      return matchesQuery && matchesType && matchesTags;
    }).toList();
  }

  void _toggleAdvancedSearch() {
    setState(() {
      _isAdvancedSearchVisible = !_isAdvancedSearchVisible;
    });
  }

  void _switchViewMode(ViewMode viewMode) {
    setState(() {
      _currentViewMode = viewMode;
      // Reset filters when changing view modes
      if (_filterOptions.isNotEmpty()) {
        _filterOptions = FilterOptions();
        _applyFilters();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search header
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Community Search',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              Divider(),
              SizedBox(
                  height: 40,
                  child: TextField(
                      controller: _searchController,
                      onChanged: _performSearch,
                      decoration: InputDecoration(
                          hintText: 'Search regions or institutions...',
                          prefixIcon:
                              const Icon(Icons.search, color: Colors.blue),
                          suffixIcon: IconButton(
                              icon: Icon(_isAdvancedSearchVisible
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down),
                              onPressed: _toggleAdvancedSearch,
                              tooltip: 'Advanced Search Options'),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                              borderRadius: BorderRadius.circular(12)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  BorderSide(color: Colors.blue, width: 2))))),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: _isAdvancedSearchVisible ? 180 : 0,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Filter by:',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Row(children: [
                          Checkbox(
                              value: _filterOptions.filterByType,
                              onChanged: (value) {
                                setState(() {
                                  _filterOptions.filterByType = value!;
                                  _applyFilters();
                                });
                              }),
                          const Text('Institution Type:'),
                          const SizedBox(width: 8),
                          DropdownButton<String>(
                              value: _filterOptions.selectedTypes.isEmpty
                                  ? null
                                  : _filterOptions.selectedTypes.first,
                              hint: const Text('Select type'),
                              onChanged: _filterOptions.filterByType
                                  ? (newValue) {
                                      setState(() {
                                        _filterOptions.selectedTypes = [
                                          newValue!
                                        ];
                                        _applyFilters();
                                      });
                                    }
                                  : null,
                              items: const [
                                DropdownMenuItem(
                                    value: 'University',
                                    child: Text('University')),
                                DropdownMenuItem(
                                    value: 'Company', child: Text('Company')),
                                DropdownMenuItem(
                                    value: 'Organization',
                                    child: Text('Organization'))
                              ])
                        ]),
                        const SizedBox(height: 8),
                        const Text('Popular Tags:'),
                        Wrap(
                          spacing: 8,
                          children: [
                            FilterChip(
                              label: const Text('Research'),
                              selected: _filterOptions.selectedTags
                                  .contains('Research'),
                              onSelected: (selected) {
                                setState(() {
                                  if (selected) {
                                    _filterOptions.selectedTags.add('Research');
                                  } else {
                                    _filterOptions.selectedTags
                                        .remove('Research');
                                  }
                                  _applyFilters();
                                });
                              },
                            ),
                            FilterChip(
                              label: const Text('Technology'),
                              selected: _filterOptions.selectedTags
                                  .contains('Technology'),
                              onSelected: (selected) {
                                setState(() {
                                  if (selected) {
                                    _filterOptions.selectedTags
                                        .add('Technology');
                                  } else {
                                    _filterOptions.selectedTags
                                        .remove('Technology');
                                  }
                                  _applyFilters();
                                });
                              },
                            ),
                            FilterChip(
                              label: const Text('Science'),
                              selected: _filterOptions.selectedTags
                                  .contains('Science'),
                              onSelected: (selected) {
                                setState(() {
                                  if (selected) {
                                    _filterOptions.selectedTags.add('Science');
                                  } else {
                                    _filterOptions.selectedTags
                                        .remove('Science');
                                  }
                                  _applyFilters();
                                });
                              },
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton.icon(
                            icon: const Icon(Icons.refresh),
                            label: const Text('Reset Filters'),
                            onPressed: () {
                              setState(() {
                                _filterOptions = FilterOptions();
                                _applyFilters();
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 650,
          padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 8.0),
          decoration: BoxDecoration(
              color: Colors.grey.shade100,
              border: Border(
                top: BorderSide(color: Colors.grey.shade300),
                bottom: BorderSide(color: Colors.grey.shade300),
              ),
              borderRadius: BorderRadius.circular(10)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 300,
                child: _buildViewModeButton(
                  title: 'Regions',
                  icon: Icons.public,
                  viewMode: ViewMode.regions,
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 300,
                child: _buildViewModeButton(
                  title: 'Institutions',
                  icon: Icons.business,
                  viewMode: ViewMode.institutions,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: _currentViewMode == ViewMode.regions
              ? _buildRegionsView()
              : _buildInstitutionsView(),
        ),
      ],
    );
  }

  Widget _buildViewModeButton(
      {required String title,
      required IconData icon,
      required ViewMode viewMode}) {
    final isSelected = _currentViewMode == viewMode;
    return ElevatedButton(
      onPressed: () => _switchViewMode(viewMode),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.blue : Colors.white,
        foregroundColor: isSelected ? Colors.white : Colors.black87,
        elevation: isSelected ? 2 : 0,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: isSelected ? Colors.blue : Colors.grey.shade300,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20, color: isSelected ? Colors.white : Colors.blue),
          const SizedBox(width: 8),
          Text(title),
        ],
      ),
    );
  }

  Widget _buildRegionsView() {
    return _filteredRegions.isEmpty
        ? const Center(
            child: Text('No regions found matching your criteria.'),
          )
        : ListView.builder(
            itemCount: _filteredRegions.length,
            itemBuilder: (context, index) {
              final region = _filteredRegions[index];
              return RegionTile(
                region: region,
                searchQuery: _searchQuery,
                onInstitutionTap: viewInstitutionDetails,
              );
            },
          );
  }

  Widget _buildInstitutionsView() {
    return _filteredInstitutions.isEmpty
        ? const Center(
            child: Text('No institutions found matching your criteria.'),
          )
        : ScrollConfiguration(
            behavior:
                ScrollConfiguration.of(context).copyWith(scrollbars: false),
            child: ListView.builder(
              itemCount: _filteredInstitutions.length,
              itemBuilder: (context, index) {
                final institution = _filteredInstitutions[index];
                return InstitutionTile(
                  institution: institution,
                  searchQuery: _searchQuery,
                  onTap: () => viewInstitutionDetails(institution),
                );
              },
            ),
          );
  }

  void viewInstitutionDetails(Institution institution) {
    final faker = Faker();
    final random = Random();
    // User data generation code remains the same
    final List<Map<String, dynamic>> users = List.generate(5, (index) {
      return {
        'id': 'ID${random.nextInt(9000) + 1000}',
        'name': faker.person.name(),
        'rating': random.nextInt(3000),
        'problemsSolved': random.nextInt(500),
        'profileImage': 'assets/avatars/$index.jpg',
        'joinDate':
            '${random.nextInt(5) + 2020}-0${random.nextInt(9) + 1}-1${random.nextInt(9)}',
        'topSkills': [
          'Greedy Algorithms',
          'Sorting',
          'Dynamic Programming',
          'Graphs',
          'Bit Manipulation'
        ]..shuffle(),
        'recentProblems': List.generate(
            3,
            (i) => {
                  'name': faker.lorem.words(2).join(' '),
                  'difficulty': ['Easy', 'Medium', 'Hard'][random.nextInt(3)],
                  'date': '2025-03-${random.nextInt(30) + 1}',
                }),
        'skillDistribution': {
          'Greedy Algorithms': random.nextInt(100),
          'Divide & Conquer': random.nextInt(100),
          'Sorting': random.nextInt(100),
          'Searching': random.nextInt(100),
          'Dynamic Programming': random.nextInt(100),
        },
      };
    });

    List<Map<String, dynamic>> thadomalUsers = [
      {
        'id': 'ID${random.nextInt(9000) + 1000}',
        'name': 'Pranav Mahamunkar',
        'rating': '1200',
        'problemsSolved': 6,
        'profileImage': 'assets/avatars/shasdh.jpg',
        'joinDate': '4th Feb 2025',
        'topSkills': [
          'Greedy Algorithms',
          'Sorting',
          'Dynamic Programming',
          'Graphs',
          'Bit Manipulation'
        ]..shuffle(),
        'recentProblems': List.generate(
          3,
          (i) => {
            'name': [
              'Two Sum',
              'Valid Parentheses',
              'Merge Two Sorted Lists',
              'Best Time to Buy and Sell Stock',
              'Maximum Subarray',
              'Longest Palindromic Substring',
              'Container With Most Water',
              'Merge Intervals',
              'LRU Cache',
              'Word Break',
              'Course Schedule',
              'Trapping Rain Water',
              'Median of Two Sorted Arrays',
              'Regular Expression Matching',
              'Serialize and Deserialize Binary Tree'
            ][random.nextInt(15)],
            'difficulty': ['Easy', 'Medium', 'Hard'][random.nextInt(3)],
            'date': '2025-03-${random.nextInt(30) + 1}',
          },
        ),
        'skillDistribution': {
          'Greedy Algorithms': random.nextInt(100),
          'Divide & Conquer': random.nextInt(100),
          'Sorting': random.nextInt(100),
          'Searching': random.nextInt(100),
          'Dynamic Programming': random.nextInt(100),
        },
      },
      {
        'id': 'ID${random.nextInt(9000) + 1000}',
        'name': 'Ritojnan Mukherjee',
        'rating': '1200',
        'problemsSolved': 6,
        'profileImage': 'assets/avatars/shasdh.jpg',
        'joinDate': '6th Feb 2025',
        'topSkills': [
          'Greedy Algorithms',
          'Sorting',
          'Dynamic Programming',
          'Graphs',
          'Bit Manipulation'
        ]..shuffle(),
        'recentProblems': List.generate(
          3,
          (i) => {
            'name': [
              'Two Sum',
              'Valid Parentheses',
              'Merge Two Sorted Lists',
              'Best Time to Buy and Sell Stock',
              'Maximum Subarray',
              'Longest Palindromic Substring',
              'Container With Most Water',
              'Merge Intervals',
              'LRU Cache',
              'Word Break',
              'Course Schedule',
              'Trapping Rain Water',
              'Median of Two Sorted Arrays',
              'Regular Expression Matching',
              'Serialize and Deserialize Binary Tree'
            ][random.nextInt(15)],
            'difficulty': ['Easy', 'Medium', 'Hard'][random.nextInt(3)],
            'date': '2025-03-${random.nextInt(30) + 1}',
          },
        ),
        'skillDistribution': {
          'Greedy Algorithms': random.nextInt(100),
          'Divide & Conquer': random.nextInt(100),
          'Sorting': random.nextInt(100),
          'Searching': random.nextInt(100),
          'Dynamic Programming': random.nextInt(100),
        },
      },
      {
        'id': 'ID${random.nextInt(9000) + 1000}',
        'name': 'Devang Mane',
        'rating': '800',
        'problemsSolved': 4,
        'profileImage': 'assets/avatars/shasdh.jpg',
        'joinDate': '3rd Feb 2025',
        'topSkills': [
          'Greedy Algorithms',
          'Sorting',
          'Dynamic Programming',
          'Graphs',
          'Bit Manipulation'
        ]..shuffle(),
        'recentProblems': List.generate(
          3,
          (i) => {
            'name': [
              'Two Sum',
              'Valid Parentheses',
              'Merge Two Sorted Lists',
              'Best Time to Buy and Sell Stock',
              'Maximum Subarray',
              'Longest Palindromic Substring',
              'Container With Most Water',
              'Merge Intervals',
              'LRU Cache',
              'Word Break',
              'Course Schedule',
              'Trapping Rain Water',
              'Median of Two Sorted Arrays',
              'Regular Expression Matching',
              'Serialize and Deserialize Binary Tree'
            ][random.nextInt(15)],
            'difficulty': ['Easy', 'Medium', 'Hard'][random.nextInt(3)],
            'date': '2025-03-${random.nextInt(30) + 1}',
          },
        ),
        'skillDistribution': {
          'Greedy Algorithms': random.nextInt(100),
          'Divide & Conquer': random.nextInt(100),
          'Sorting': random.nextInt(100),
          'Searching': random.nextInt(100),
          'Dynamic Programming': random.nextInt(100),
        },
      },
    ];

    bool isThadomal =
        institution.name == 'Thadomal Shahani Engineering College';
    showDialog(
        context: context,
        builder: (context) => Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              // FIXED: Set constraints to limit width and height
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 400,
                  maxHeight: MediaQuery.of(context).size.height * 0.8,
                ),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                  child: Text(institution.name,
                                      style: const TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold))),
                              IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () => Navigator.pop(context))
                            ]),
                        const SizedBox(height: 8),
                        Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                                color: Colors.blue.shade100,
                                borderRadius: BorderRadius.circular(8)),
                            child: Text(institution.type,
                                style: TextStyle(color: Colors.blue.shade800))),
                        const SizedBox(height: 16),
                        const Text('Members',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Expanded(
                            child: ListView.builder(
                                itemCount: isThadomal
                                    ? thadomalUsers.length
                                    : users.length,
                                itemBuilder: (context, index) {
                                  final user = isThadomal
                                      ? thadomalUsers[index]
                                      : users[index];
                                  return Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: ListTile(
                                        leading: CircleAvatar(
                                            backgroundColor: Colors.blue,
                                            child: Icon(
                                              Icons.account_circle,
                                              size: 40,
                                            )),
                                        title: Text(user['name']),
                                        subtitle: Text(
                                            'Rating: ${user['rating']}  |  Solved: ${user['problemsSolved']}'),
                                        onTap: () {
                                          showModalBottomSheet(
                                              context: context,
                                              isScrollControlled: true,
                                              shape:
                                                  const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.vertical(
                                                              top: Radius
                                                                  .circular(
                                                                      16))),
                                              builder: (context) {
                                                return Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            16),
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.7,
                                                    child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Text(
                                                                    user[
                                                                        'name'],
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            20,
                                                                        fontWeight:
                                                                            FontWeight.bold)),
                                                                IconButton(
                                                                    icon: const Icon(
                                                                        Icons
                                                                            .close),
                                                                    onPressed: () =>
                                                                        Navigator.pop(
                                                                            context))
                                                              ]),
                                                          const SizedBox(
                                                              height: 8),
                                                          Text(
                                                              'ID: ${user['id']} | Joined: ${user['joinDate']}'),
                                                          const SizedBox(
                                                              height: 12),
                                                          const Text(
                                                              'Top Skills',
                                                              style: TextStyle(
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                          Wrap(
                                                              spacing: 8,
                                                              children: (user[
                                                                          'topSkills']
                                                                      as List)
                                                                  .map<Widget>(
                                                                      (skill) => Chip(
                                                                          label:
                                                                              Text(skill)))
                                                                  .toList()),
                                                          const SizedBox(
                                                              height: 12),
                                                          const Text(
                                                              'Recent Problems',
                                                              style: TextStyle(
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                          Column(
                                                              children: (user[
                                                                          'recentProblems']
                                                                      as List)
                                                                  .map<Widget>((problem) => ListTile(
                                                                      title: Text(
                                                                          problem[
                                                                              'name']),
                                                                      subtitle:
                                                                          Text(
                                                                              '${problem['difficulty']} | Solved on: ${problem['date']}')))
                                                                  .toList()),
                                                          const Spacer(),
                                                          ElevatedButton(
                                                              style: ElevatedButton.styleFrom(
                                                                  padding: const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                          12)),
                                                              onPressed: () {
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(SnackBar(
                                                                        content:
                                                                            Text('Connecting with ${user['name']}...')));
                                                              },
                                                              child: const Text(
                                                                  'Connect'))
                                                        ]));
                                              });
                                        }),
                                  );
                                }))
                      ]),
                ),
              ),
            ));
  }
}

class FilterOptions {
  bool filterByType;
  List<String> selectedTypes;
  List<String> selectedTags;

  FilterOptions(
      {this.filterByType = false,
      this.selectedTypes = const [],
      this.selectedTags = const []});

  bool isNotEmpty() =>
      filterByType || selectedTypes.isNotEmpty || selectedTags.isNotEmpty;
}

class RegionTile extends StatelessWidget {
  final Region region;
  final String searchQuery;
  final Function(Institution) onInstitutionTap;

  const RegionTile(
      {super.key,
      required this.region,
      required this.searchQuery,
      required this.onInstitutionTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        title: Text(region.name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        subtitle: Text(
            '${region.institutions.length} institutions • ${region.subregions.length} subregions'),
        leading: const CircleAvatar(
            backgroundColor: Colors.blue, child: Icon(Icons.public)),
        initiallyExpanded: searchQuery.isNotEmpty &&
            (region.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
                region.subregions.any((subregion) => subregion
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()))),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                spacing: 8,
                children: region.subregions.map((subregion) {
                  return Chip(
                    label: Text(subregion),
                    backgroundColor: searchQuery.isNotEmpty &&
                            subregion
                                .toLowerCase()
                                .contains(searchQuery.toLowerCase())
                        ? Colors.blue.shade100
                        : Colors.grey.shade200,
                  );
                }).toList(),
              ),
            ),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Institutions',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: region.institutions.length,
            itemBuilder: (context, index) {
              final institution = region.institutions[index];
              return ListTile(
                title: Text(institution.name),
                subtitle: Text(institution.type),
                leading: const Icon(Icons.business),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => onInstitutionTap(institution),
                selected: searchQuery.isNotEmpty &&
                    institution.name
                        .toLowerCase()
                        .contains(searchQuery.toLowerCase()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class InstitutionTile extends StatelessWidget {
  final Institution institution;
  final String searchQuery;
  final VoidCallback onTap;

  const InstitutionTile(
      {super.key,
      required this.institution,
      required this.searchQuery,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    bool isHighlighted = searchQuery.isNotEmpty &&
        institution.name.toLowerCase().contains(searchQuery.toLowerCase());

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: isHighlighted ? 4 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isHighlighted
            ? BorderSide(color: Theme.of(context).primaryColor, width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: institution.type == 'University'
                        ? Colors.blue.shade100
                        : Colors.green.shade100,
                    child: Icon(
                      institution.type == 'University'
                          ? Icons.school
                          : Icons.business,
                      color: institution.type == 'University'
                          ? Colors.blue.shade700
                          : Colors.green.shade700,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          institution.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            institution.type,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          institution.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, size: 16),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: institution.tags.map((tag) {
                  final isTagHighlighted = searchQuery.isNotEmpty &&
                      tag.toLowerCase().contains(searchQuery.toLowerCase());
                  return Chip(
                    label: Text(
                      tag,
                      style: TextStyle(
                        fontSize: 12,
                        color: isTagHighlighted
                            ? Colors.blue.shade700
                            : Colors.grey.shade700,
                      ),
                    ),
                    backgroundColor: isTagHighlighted
                        ? Colors.blue.shade100
                        : Colors.grey.shade200,
                    padding: EdgeInsets.zero,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
