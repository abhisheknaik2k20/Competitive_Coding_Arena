import 'package:flutter/material.dart';

class LeetCodeProfile extends StatelessWidget {
  const LeetCodeProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.only(left: 400, right: 400, top: 30, bottom: 30),
          child: Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileSection(),
                const SizedBox(height: 20),
                _buildStatsSection(),
                const SizedBox(height: 20),
                _buildProblemDifficultySection(),
                const SizedBox(height: 20),
                _buildSubmissionsGraph(),
                const SizedBox(height: 20),
                _buildCommunityStats(),
                const SizedBox(height: 20),
                _buildLanguagesSection(),
                const SizedBox(height: 20),
                _buildSkillsSection(),
                const SizedBox(height: 20),
                _buildRecentSubmissionsSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Row(
      children: [
        const CircleAvatar(
          radius: 30,
          backgroundColor: Colors.grey,
          child: Icon(Icons.person, size: 40),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Abhishek Naik',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const Text('Rank ~5,000,000',
                  style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size(double.infinity, 36),
                ),
                child: const Text('Edit Profile'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatsSection() {
    return SizedBox(
      height: 150,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatCircle('0/3237', 'Solved', Colors.cyan),
          _buildStatCircle('0', 'Attempting', Colors.orange),
        ],
      ),
    );
  }

  Widget _buildStatCircle(String text, String label, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 8),
          ),
          child:
              Center(child: Text(text, style: const TextStyle(fontSize: 18))),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildProblemDifficultySection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildDifficultyStatus('Easy', '0/814', Colors.green),
        _buildDifficultyStatus('Med.', '0/1700', Colors.yellow),
        _buildDifficultyStatus('Hard', '0/723', Colors.red),
      ],
    );
  }

  Widget _buildDifficultyStatus(String difficulty, String count, Color color) {
    return Column(
      children: [
        Text(difficulty, style: TextStyle(color: color)),
        Text(count),
      ],
    );
  }

  Widget _buildSubmissionsGraph() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('0 submissions in the past one year'),
        const SizedBox(height: 8),
        Container(
          height: 100,
          color: Colors.grey[800],
          child: const Center(child: Text('Submissions graph placeholder')),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            'Aug',
            'Sep',
            'Oct',
            'Nov',
            'Dec',
            'Jan',
            'Feb',
            'Mar',
            'Apr',
            'May',
            'Jun',
            'Jul'
          ]
              .map((month) => Text(month, style: const TextStyle(fontSize: 12)))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildCommunityStats() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Community Stats',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        _buildStatRow(Icons.visibility, 'Views', '0'),
        _buildStatRow(Icons.code, 'Solution', '0'),
        _buildStatRow(Icons.chat_bubble, 'Discuss', '0'),
        _buildStatRow(Icons.star, 'Reputation', '0'),
      ],
    );
  }

  Widget _buildStatRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.blue),
          const SizedBox(width: 8),
          Text(label),
          const Spacer(),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildLanguagesSection() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Languages',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text('Calculating...', style: TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _buildSkillsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Skills',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        _buildSkillRow('Advanced', Colors.red),
        _buildSkillRow('Intermediate', Colors.yellow),
        _buildSkillRow('Fundamental', Colors.green),
      ],
    );
  }

  Widget _buildSkillRow(String level, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Container(width: 10, height: 10, color: color),
          const SizedBox(width: 8),
          Text(level),
          const Spacer(),
          const Text('Not enough data', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildRecentSubmissionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: ['Recent AC', 'List', 'Solutions', 'Discuss']
              .map((tab) =>
                  Text(tab, style: const TextStyle(color: Colors.grey)))
              .toList(),
        ),
        const SizedBox(height: 16),
        const Center(
          child: Column(
            children: [
              Icon(Icons.bar_chart, size: 80, color: Colors.grey),
              Text('No recent submissions',
                  style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ],
    );
  }
}
