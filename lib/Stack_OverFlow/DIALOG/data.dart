import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_syntax_view/flutter_syntax_view.dart';

final List<String> categories = ['DSA', 'WEB/DEV', 'MOBILE'];
final List<String> availableLanguages = ['Python', 'C++', 'Java'];

final List<String> availableTags = [
  'Array',
  'String',
  'Hash Table',
  'Dynamic Programming',
  'Math',
  'Greedy',
  'Sorting',
  'Depth-First Search',
  'Binary Search',
  'Breadth-First Search',
  'Tree',
  'Matrix',
  'Two Pointers',
  'Bit Manipulation',
  'Stack',
  'Heap',
  'Graph',
  'Linked List',
  'Recursion',
  'Backtracking',
  'Trie',
  'Segment Tree',
  'Divide and Conquer',
  'Memoization',
  'Concurrency',
  'Multi-threading',
  'Design Patterns',
  'Database',
  'SQL',
  'ORM',
  'REST API',
  'GraphQL',
  'Networking',
  'WebSockets',
  'Caching',
  'Microservices',
  'DevOps',
  'CI/CD',
  'Containerization',
  'Docker',
  'Kubernetes',
  'Cloud Computing',
  'Firebase',
  'AWS',
  'Machine Learning',
  'Artificial Intelligence',
  'Blockchain',
  'Cybersecurity',
  'Cryptography',
  'Unit Testing',
  'Integration Testing',
  'TDD',
  'Version Control',
  'Git',
  'Flutter',
  'React',
  'Node.js',
  'Django',
  'Spring Boot'
];
Color getColorFromTag(String tag) {
  int hash = tag.hashCode;
  return Colors.primaries[hash % Colors.primaries.length];
}

Syntax getSyntaxfunc(String language) {
  switch (language.toLowerCase()) {
    case "c++":
      return Syntax.CPP;
    case "python":
      return Syntax.SWIFT;
    case "java":
      return Syntax.JAVA;
    default:
      return Syntax.DART;
  }
}

Color getDifficultyColor(String difficulty) {
  switch (difficulty) {
    case 'Easy':
      return Colors.green;
    case 'Medium':
      return Colors.orange;
    case 'Hard':
      return Colors.red;
    case 'Expert':
      return Colors.purple;
    default:
      return Colors.grey[800]!;
  }
}




        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //   content: Text(message),
    //   backgroundColor: Colors.red,
    // ));