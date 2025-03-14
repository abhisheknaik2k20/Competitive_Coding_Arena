import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:competitivecodingarena/AWS/Call_Logic/compiler_call.dart';
import 'package:competitivecodingarena/Snackbars&Pbars/snackbars.dart';
import 'package:competitivecodingarena/Welcome/recommender/options.dart';

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({super.key});

  @override
  _PreferencesScreenState createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  int _currentStep = 0;
  final int _totalSteps = 4;

  Map<String, dynamic> preferences = {
    'reason': '',
    'skillLevel': '',
    'topics': <String>[],
    'journey': <String>[],
  };

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(child: _buildMainContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Image.asset(
            "assets/images/logo.png",
            width: 50,
          ),
          const SizedBox(width: 15),
          const Text(
            'LeetCode',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          const Spacer(),
          _buildProgressIndicator(),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      width: 100,
      height: 10,
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(5),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: (_currentStep + 1) / _totalSteps,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: _buildCurrentStep(),
          ),
          _buildActionButton(),
        ],
      ),
    );
  }

  Widget _buildActionButton() {
    bool isOptionSelected = _isCurrentStepOptionSelected();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: isOptionSelected ? Colors.blue : Colors.grey,
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: isOptionSelected
            ? () async {
                if (_currentStep < _totalSteps - 1) {
                  setState(() {
                    _currentStep++;
                  });
                } else {
                  showCircularbar(context);
                  try {
                    Map<String, dynamic> getdata = await invokeLambdaFunction();
                    Map<String, dynamic> body = jsonDecode(getdata['body']);
                    List<dynamic> programmingRoadmap =
                        body['programming_roadmap'];
                    List<Map<String, dynamic>> roadmapWithProgress =
                        programmingRoadmap.map((step) {
                      return {
                        'title': step,
                        'progress': 0,
                      };
                    }).toList();
                    print(
                        'Programming Roadmap with Progress: $roadmapWithProgress');
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .update({"roadmap": roadmapWithProgress});
                    Navigator.of(context).pop();
                  } catch (e) {
                    print("Error invoking Lambda function: $e");
                  }
                }
              }
            : null,
        child: Text(_currentStep < _totalSteps - 1 ? 'Next' : 'Start'),
      ),
    );
  }

  bool _isCurrentStepOptionSelected() {
    switch (_currentStep) {
      case 0:
        return preferences['reason'].isNotEmpty;
      case 1:
        return preferences['skillLevel'].isNotEmpty;
      case 2:
        return preferences['topics'].isNotEmpty;
      case 3:
        return preferences['journey'].isNotEmpty;
      default:
        return false;
    }
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _buildReasonStep();
      case 1:
        return _buildSkillLevelStep();
      case 2:
        return _buildTopicsStep();
      case 3:
        return _buildJourneyStep();
      default:
        return Container();
    }
  }

  Widget _buildReasonStep() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Hi LeetCoder,',
            style: TextStyle(
              color: Colors.blue[300],
              fontSize: 28,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'What brought you here?',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w300,
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          _buildOptionButton(
            'Learn and enhance coding skills',
            Icons.code,
            'learn',
          ),
          const SizedBox(height: 20),
          _buildOptionButton(
            'Prepare for interviews and get job offers',
            Icons.work,
            'interview',
          ),
        ],
      ),
    );
  }

  Widget _buildOptionButton(String text, IconData icon, String value) {
    bool isSelected = preferences['reason'] == value;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 500,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue.withOpacity(0.2) : Colors.grey[900],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: isSelected ? Colors.blue : Colors.grey[800]!,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color:
                isSelected ? Colors.blue.withOpacity(0.3) : Colors.transparent,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => setState(() => preferences['reason'] = value),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.blue : Colors.white,
              size: 28,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: Colors.blue,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillLevelStep() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Your Coding Expertise',
            style: TextStyle(
              color: Colors.blue[300],
              fontSize: 28,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Which option best describes your skill level?',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w300,
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            alignment: WrapAlignment.center,
            children: [
              _buildSkillLevelOption(
                  'Beginner', 'print("Hello LeetCoder")', Icons.emoji_objects),
              _buildSkillLevelOption(
                  'Intermediate', '// Binary Tree', Icons.account_tree),
              _buildSkillLevelOption('Advanced', '// Graph', Icons.hub),
              _buildSkillLevelOption(
                  'Expert', '// System Design', Icons.architecture),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSkillLevelOption(String level, String code, IconData icon) {
    bool isSelected = preferences['skillLevel'] == level;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue.withOpacity(0.2) : Colors.grey[900],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: isSelected ? Colors.blue : Colors.grey[800]!,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color:
                isSelected ? Colors.blue.withOpacity(0.3) : Colors.transparent,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => setState(() => preferences['skillLevel'] = level),
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.blue : Colors.white,
                size: 36,
              ),
              const SizedBox(height: 12),
              Text(
                level,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                code,
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopicsStep() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Choose the topics you are interested in.',
            style: TextStyle(
                color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: [for (String topic in allTopics) _buildTopicChip(topic)],
          ),
        ],
      ),
    );
  }

  Widget _buildTopicChip(String topic) {
    bool isSelected = preferences['topics'].contains(topic);
    return FilterChip(
      label: Text(topic),
      backgroundColor: Colors.white.withOpacity(0.2),
      selectedColor: Colors.blue,
      checkmarkColor: Colors.white,
      selected: isSelected,
      onSelected: (bool selected) {
        setState(() {
          if (selected) {
            preferences['topics'].add(topic);
          } else {
            preferences['topics'].remove(topic);
          }
        });
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
  }

  Widget _buildJourneyStep() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(
          height: 20,
        ),
        Text(
          'Start your LeetCode Journey now!',
          style: TextStyle(
            color: Colors.blue[300],
            fontSize: 28,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        const Text(
          'Choose the courses you might want to try',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w300,
            letterSpacing: 0.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 30),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 1.8,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
            ),
            itemCount: journeys.length,
            itemBuilder: (context, index) =>
                _buildJourneyOption(journeys[index], index),
          ),
        ),
      ],
    );
  }

  Widget _buildJourneyOption(String title, int index) {
    bool isSelected = preferences['journey'].contains(title);
    return InkWell(
      onTap: () {
        setState(() {
          if (isSelected) {
            preferences['journey'].remove(title);
          } else {
            preferences['journey'].add(title);
          }
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.withOpacity(0.2) : Colors.grey[800],
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey[700]!,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.map,
              color: isSelected ? Colors.blue : Colors.white,
              size: 40,
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),
            Text(
              isSelected ? 'Selected' : 'Tap to select',
              style: TextStyle(
                color: isSelected ? Colors.blue[300] : Colors.grey[400],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
