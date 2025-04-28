// ignore_for_file: deprecated_member_use

import 'dart:math';

import 'package:competitivecodingarena/Core_Project/Community/Region_Based/search_screen.dart';
import 'package:faker/faker.dart' as faker_c;
import 'package:flutter/material.dart';

// Main Screen
class SkillClusteringScreen extends StatefulWidget {
  const SkillClusteringScreen({super.key});

  @override
  State<SkillClusteringScreen> createState() => _SkillClusteringScreenState();
}

class _SkillClusteringScreenState extends State<SkillClusteringScreen> {
  final List<ClusterData> _clusters = [
    ClusterData(
      name: 'Algorithm Experts',
      description: 'Members who excel at complex algorithm problems',
      members: 152,
      avgProblems: 234,
      avgRating: 2350,
      skills: ['Greedy Algorithms', 'Divide & Conquer', 'Sorting', 'Searching'],
      problems: {'easy': 95, 'medium': 85, 'hard': 72},
    ),
    ClusterData(
      name: 'Data Structure Wizards',
      description: 'Strong grasp of advanced data structures',
      members: 203,
      avgProblems: 187,
      avgRating: 2150,
      skills: ['Trees', 'Graphs', 'Heaps', 'Hash Tables', 'Linked Lists'],
      problems: {'easy': 98, 'medium': 82, 'hard': 65},
    ),
    ClusterData(
      name: 'DP Enthusiasts',
      description: 'Specialists in dynamic programming approaches',
      members: 127,
      avgProblems: 205,
      avgRating: 2240,
      skills: [
        'Dynamic Programming',
        'Memoization',
        'Tabulation',
        'State Machines'
      ],
      problems: {'easy': 91, 'medium': 87, 'hard': 78},
    ),
    ClusterData(
      name: 'Graph Theory Masters',
      description: 'Experts in solving complex graph problems',
      members: 98,
      avgProblems: 223,
      avgRating: 2410,
      skills: [
        'Graph Traversal',
        'Shortest Path',
        'Network Flow',
        'Topological Sort'
      ],
      problems: {'easy': 90, 'medium': 88, 'hard': 82},
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ScreenHeader(),
          const SizedBox(height: 4),
          Expanded(
            child: ClusterGrid(clusters: _clusters),
          )
        ],
      ),
    );
  }
}

// Screen Header Component
class ScreenHeader extends StatelessWidget {
  const ScreenHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              'Skill-Based Clustering',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Users grouped by similar skill patterns',
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.grey[700]
                : Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

// Cluster Grid Component
class ClusterGrid extends StatelessWidget {
  final List<ClusterData> clusters;

  const ClusterGrid({
    super.key,
    required this.clusters,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 3.0,
      ),
      itemCount: clusters.length,
      itemBuilder: (context, index) {
        return ClusterCard(data: clusters[index]);
      },
    );
  }
}

// Cluster Card Component
class ClusterCard extends StatelessWidget {
  final ClusterData data;

  const ClusterCard({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClusterHeader(
              name: data.name,
              description: data.description,
              members: data.members),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkillsSection(skills: data.skills),
                  const SizedBox(height: 8),
                  ProblemSolvingSection(problems: data.problems),
                ],
              ),
            ),
          ),
          ViewDetailsButton(
              onTap: () => viewInstitutionDetails(
                  Institution(
                      id: '',
                      name: data.name,
                      type: data.description,
                      description: data.description),
                  context)),
        ],
      ),
    );
  }

  void viewInstitutionDetails(Institution institution, BuildContext context) {
    final faker = faker_c.Faker();
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
      // Thadomal users remain the same
      {
        'id': 'ID${random.nextInt(9000) + 1000}',
        'name': 'Pranav Mahamunkar',
        'rating': '1200',
        'problemsSolved': 6,
        'profileImage': 'assets/avatars/shasdh.jpg',
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

// Cluster Header Component
class ClusterHeader extends StatelessWidget {
  final String name;
  final String description;
  final int members;

  const ClusterHeader(
      {super.key,
      required this.name,
      required this.description,
      required this.members});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.2),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[800],
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          MembersBadge(count: members),
        ],
      ),
    );
  }
}

// Members Badge Component
class MembersBadge extends StatelessWidget {
  final int count;

  const MembersBadge({
    super.key,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.people, size: 12, color: Colors.blue),
          const SizedBox(width: 4),
          Text(
            count.toString(),
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}

// Skills Section Component
class SkillsSection extends StatelessWidget {
  final List<String> skills;

  const SkillsSection({
    super.key,
    required this.skills,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Key Skills',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Wrap(
          spacing: 4,
          runSpacing: 4,
          children: skills.map((skill) => SkillChip(label: skill)).toList(),
        ),
      ],
    );
  }
}

// Skill Chip Component
class SkillChip extends StatelessWidget {
  final String label;

  const SkillChip({
    super.key,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 10,
          color: Colors.blue,
        ),
      ),
    );
  }
}

// Problem Solving Section Component
class ProblemSolvingSection extends StatelessWidget {
  final Map<String, int> problems;

  const ProblemSolvingSection({
    super.key,
    required this.problems,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Problem Solving',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        ProblemSolvingBar(problems: problems),
        const SizedBox(height: 2),
        Row(
          children: [
            LegendItem(label: 'Easy', color: Colors.green.shade300),
            const SizedBox(width: 6),
            LegendItem(label: 'Medium', color: Colors.amber.shade300),
            const SizedBox(width: 6),
            LegendItem(label: 'Hard', color: Colors.red.shade300),
          ],
        ),
      ],
    );
  }
}

// Problem Solving Bar Component
class ProblemSolvingBar extends StatelessWidget {
  final Map<String, int> problems;

  const ProblemSolvingBar({
    super.key,
    required this.problems,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 16,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Expanded(
            flex: problems['easy'] ?? 0,
            child: Container(color: Colors.green.shade300),
          ),
          Expanded(
            flex: problems['medium'] ?? 0,
            child: Container(color: Colors.amber.shade300),
          ),
          Expanded(
            flex: problems['hard'] ?? 0,
            child: Container(color: Colors.red.shade300),
          ),
        ],
      ),
    );
  }
}

// Legend Item Component
class LegendItem extends StatelessWidget {
  final String label;
  final Color color;

  const LegendItem({
    super.key,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}

class ViewDetailsButton extends StatelessWidget {
  final VoidCallback onTap;

  const ViewDetailsButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey.shade200)),
        ),
        child: const Center(
          child: Text(
            'View Details',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.blue,
            ),
          ),
        ),
      ),
    );
  }
}

// Data Model
class ClusterData {
  final String name;
  final String description;
  final int members;
  final int avgProblems;
  final int avgRating;
  final List<String> skills;
  final Map<String, int> problems;

  ClusterData({
    required this.name,
    required this.description,
    required this.members,
    required this.avgProblems,
    required this.avgRating,
    required this.skills,
    required this.problems,
  });
}
