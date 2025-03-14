import 'dart:math';

List<String> journeys = [
  '10 Essential DP Patterns',
  '30 Days of JavaScript',
  'Programming Skills',
  'Algorithm I',
  'Algorithm II',
  'Data Structure I',
  'Data Structure II',
  'Graph Theory I',
  'Binary Search I',
  'Binary Search II',
  'SQL I',
  'SQL II',
  'System Design',
  'Object-Oriented Design',
  'Machine Learning 101',
  'Dynamic Programming I',
  'Stack I',
  'Heap I',
  'Tree I',
  'Advanced Algorithms',
  'Operating Systems Fundamentals',
  'Computer Networks Basics',
  'Web Development Bootcamp',
  'Mobile App Development',
  'Cloud Computing Essentials',
  'Cybersecurity Fundamentals',
  'Data Science Primer',
  'Artificial Intelligence Concepts',
  'Blockchain Basics',
  'DevOps Practices',
  'Microservices Architecture',
  'Front-end Frameworks',
  'Back-end Development',
  'Database Design and Management',
  'RESTful API Design',
  'Concurrency and Parallelism',
  'Functional Programming',
  'Software Testing and QA',
  'Agile Methodologies',
  'Big Data Processing',
  'Natural Language Processing',
  'Computer Vision Fundamentals',
  'Quantum Computing Primer'
];

List<String> allTopics = [
  'Arrays',
  'Strings',
  'Hash Table',
  'Dynamic Programming',
  'Math',
  'Sorting',
  'Greedy',
  'Depth-First Search',
  'Binary Search',
  'Breadth-First Search',
  'Tree',
  'Matrix',
  'Two Pointers',
  'Binary Tree',
  'Bit Manipulation',
  'Heap',
  'Stack',
  'Graph',
  'Prefix Sum',
  'Simulation',
  'Design',
  'Counting',
  'Backtracking',
  'Sliding Window',
  'Union Find',
  'Linked List',
  'Monotonic Stack',
  'Recursion',
  'Divide and Conquer',
  'Binary Search Tree',
  'Queue',
  'Memoization',
  'Topological Sort',
  'Segment Tree',
  'Binary Indexed Tree',
  'Data Structure Basics',
  'Algorithm'
];

String pickRandomTopic(List<String> topics) {
  final random = Random();
  return topics[random.nextInt(topics.length)];
}

String pickRandomString(List<String> strings) {
  if (strings.isEmpty) {
    throw ArgumentError('The list of strings cannot be empty');
  }
  final random = Random();
  return strings[random.nextInt(strings.length)];
}

List<String> reasons = ["interview", "learn"];
List<String> skill = ["Advanced", "Beginner", "Intermediate", "Expert"];
