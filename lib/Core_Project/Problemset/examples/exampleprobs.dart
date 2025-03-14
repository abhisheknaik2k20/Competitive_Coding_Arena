import 'package:cloud_firestore/cloud_firestore.dart';

class Problem {
  final String id;
  final String title;
  final String difficulty;
  final List<Map<String, dynamic>> content;
  final List<Map<String, dynamic>> testcases;
  final String status;
  final double acceptanceRate;
  final String frequency;

  Problem({
    required this.id,
    required this.title,
    required this.difficulty,
    required this.content,
    required this.testcases,
    required this.status,
    required this.acceptanceRate,
    required this.frequency,
  });
  factory Problem.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Problem(
      id: data['id'] ?? '',
      title: data['title'] ?? '',
      difficulty: data['difficulty'] ?? '',
      content: (data['content'] as List<dynamic>?)
              ?.map((item) => item as Map<String, dynamic>)
              .toList() ??
          [],
      testcases: (data['testcases'] as List<dynamic>?)
              ?.map((item) => item as Map<String, dynamic>)
              .toList() ??
          [],
      status: data['status'] ?? '',
      acceptanceRate: (data['acceptanceRate'] as num?)?.toDouble() ?? 0.0,
      frequency: data['frequency'] ?? '',
    );
  }
}

List<Problem> problemexample = [
  Problem(
    id: '1',
    title: "Two Sum",
    status: "Solved",
    acceptanceRate: 47.5,
    difficulty: "Easy",
    frequency: "High",
    content: [
      {'text': 'Two Sum\n\n', 'fontSize': 24, 'isBold': true},
      {'text': 'Easy\n\n', 'color': 'green', 'isBold': true},
      {
        'text':
            'Given an array of integers nums and an integer target, return indices of the two numbers such that they add up to target.\n\n'
      },
      {
        'text':
            'You may assume that each input would have exactly one solution, and you may not use the same element twice.\n\n'
      },
      {'text': 'You can return the answer in any order.\n\n'},
      {'text': 'Constraints:\n', 'isBold': true},
      {'text': '• 2 <= nums.length <= 10^4\n'},
      {'text': '• -10^9 <= nums[i] <= 10^9\n'},
      {'text': '• -10^9 <= target <= 10^9\n'},
      {'text': '• Only one valid answer exists.\n'},
    ],
    testcases: [
      {
        'title': 'Test Case 1',
        'input': [2, 7, 11, 15],
        'target': 9,
        'output': [0, 1],
        'explain': 'Because nums[0] + nums[1] == 9, we return [0, 1].'
      },
      {
        'title': 'Test Case 2',
        'input': [3, 2, 4],
        'target': 6,
        'output': [1, 2],
        'explain': 'Because nums[1] + nums[2] == 6, we return [1, 2].'
      },
      {
        'title': 'Test Case 3',
        'input': [3, 3],
        'target': 6,
        'output': [0, 1],
        'explain': 'Because nums[0] + nums[1] == 6, we return [0, 1].'
      },
    ],
  ),
  Problem(
    id: '2',
    title: "Add Two Numbers",
    status: "Unsolved",
    acceptanceRate: 36.4,
    difficulty: "Medium",
    frequency: "High",
    content: [
      {'text': 'Add Two Numbers\n\n', 'fontSize': 24, 'isBold': true},
      {'text': 'Medium\n\n', 'color': 'orange', 'isBold': true},
      {
        'text':
            'You are given two non-empty linked lists representing two non-negative integers. The digits are stored in reverse order, and each of their nodes contains a single digit. Add the two numbers and return the sum as a linked list.\n\n'
      },
      {
        'text':
            'You may assume the two numbers do not contain any leading zero, except the number 0 itself.\n\n'
      },
      {'text': 'Constraints:\n', 'isBold': true},
      {
        'text':
            '• The number of nodes in each linked list is in the range [1, 100].\n'
      },
      {'text': '• 0 <= Node.val <= 9\n'},
      {
        'text':
            '• It is guaranteed that the list represents a number that does not have leading zeros.\n'
      },
    ],
    testcases: [
      {
        'title': 'Test Case 1',
        'input': [2, 4, 3],
        'input2': [5, 6, 4],
        'output': [7, 0, 8],
        'explain': '342 + 465 = 807, so the result is [7, 0, 8].'
      },
      {
        'title': 'Test Case 2',
        'input': [0],
        'input2': [0],
        'output': [0],
        'explain': '0 + 0 = 0, so the result is [0].'
      },
      {
        'title': 'Test Case 3',
        'input': [9, 9, 9, 9, 9, 9, 9],
        'input2': [9, 9, 9, 9],
        'output': [8, 9, 9, 9, 0, 0, 0, 1],
        'explain':
            '9999999 + 9999 = 10009998, so the result is [8, 9, 9, 9, 0, 0, 0, 1].'
      },
    ],
  ),
  Problem(
    id: '3',
    title: "Longest Substring Without Repeating Characters",
    status: "Unsolved",
    acceptanceRate: 30.8,
    difficulty: "Medium",
    frequency: "High",
    content: [
      {
        'text': 'Longest Substring Without Repeating Characters\n\n',
        'fontSize': 24,
        'isBold': true
      },
      {'text': 'Medium\n\n', 'color': 'orange', 'isBold': true},
      {
        'text':
            'Given a string s, find the length of the longest substring without repeating characters.\n\n'
      },
      {'text': 'Constraints:\n', 'isBold': true},
      {'text': '• 0 <= s.length <= 5 * 10^4\n'},
      {
        'text': '• s consists of English letters, digits, symbols and spaces.\n'
      },
    ],
    testcases: [
      {
        'title': 'Test Case 1',
        'input': "abcabcbb",
        'output': 3,
        'explain': 'The answer is "abc", with the length of 3.'
      },
      {
        'title': 'Test Case 2',
        'input': "bbbbb",
        'output': 1,
        'explain': 'The answer is "b", with the length of 1.'
      },
      {
        'title': 'Test Case 3',
        'input': "pwwkew",
        'output': 3,
        'explain': 'The answer is "wke", with the length of 3.'
      },
    ],
  ),
  Problem(
    id: '4',
    title: "Median of Two Sorted Arrays",
    status: "Unsolved",
    acceptanceRate: 29.4,
    difficulty: "Hard",
    frequency: "High",
    content: [
      {
        'text': 'Median of Two Sorted Arrays\n\n',
        'fontSize': 24,
        'isBold': true
      },
      {'text': 'Hard\n\n', 'color': 'red', 'isBold': true},
      {
        'text':
            'Given two sorted arrays nums1 and nums2 of size m and n respectively, return the median of the two sorted arrays.\n\n'
      },
      {'text': 'The overall run time complexity should be O(log (m+n)).\n\n'},
      {'text': 'Constraints:\n', 'isBold': true},
      {'text': '• nums1.length == m\n'},
      {'text': '• nums2.length == n\n'},
      {'text': '• 0 <= m, n <= 1000\n'},
      {'text': '• 1 <= m + n <= 2000\n'},
      {'text': '• -10^6 <= nums1[i], nums2[i] <= 10^6\n'},
    ],
    testcases: [
      {
        'title': 'Test Case 1',
        'input': [1, 3],
        'input2': [2],
        'output': 2.0,
        'explain': 'The median is 2.0.'
      },
      {
        'title': 'Test Case 2',
        'input': [1, 2],
        'input2': [3, 4],
        'output': 2.5,
        'explain': 'The median is (2 + 3) / 2 = 2.5.'
      },
      {
        'title': 'Test Case 3',
        'input': [0, 0],
        'input2': [0, 0],
        'output': 0.0,
        'explain': 'The median is 0.0.'
      },
    ],
  ),
  Problem(
    id: '5',
    title: "Longest Palindromic Substring",
    status: "Unsolved",
    acceptanceRate: 31.2,
    difficulty: "Medium",
    frequency: "High",
    content: [
      {
        'text': 'Longest Palindromic Substring\n\n',
        'fontSize': 24,
        'isBold': true
      },
      {'text': 'Medium\n\n', 'color': 'orange', 'isBold': true},
      {
        'text':
            'Given a string s, return the longest palindromic substring in s.\n\n'
      },
      {'text': 'Constraints:\n', 'isBold': true},
      {'text': '• 1 <= s.length <= 1000\n'},
      {'text': '• s consist of only digits and English letters.\n'},
    ],
    testcases: [
      {
        'title': 'Test Case 1',
        'input': "babad",
        'output': "bab",
        'explain': '"aba" is also a valid answer.'
      },
      {
        'title': 'Test Case 2',
        'input': "cbbd",
        'output': "bb",
        'explain': 'The answer is "bb".'
      },
      {
        'title': 'Test Case 3',
        'input': "a",
        'output': "a",
        'explain': 'The answer is "a".'
      },
    ],
  ),
  Problem(
    id: '6',
    title: "Zigzag Conversion",
    status: "Unsolved",
    acceptanceRate: 40.7,
    difficulty: "Medium",
    frequency: "Medium",
    content: [
      {'text': 'Zigzag Conversion\n\n', 'fontSize': 24, 'isBold': true},
      {'text': 'Medium\n\n', 'color': 'orange', 'isBold': true},
      {
        'text':
            'The string "PAYPALISHIRING" is written in a zigzag pattern on a given number of rows like this: (you may want to display this pattern in a fixed font for better legibility)\n\n'
      },
      {'text': 'P   A   H   N\nA P L S I I G\nY   I   R\n\n'},
      {
        'text':
            'Write the code that will take a string and make this conversion given a number of rows:\n\n'
      },
      {'text': 'string convert(string s, int numRows);\n\n'},
      {'text': 'Constraints:\n', 'isBold': true},
      {'text': '• 1 <= s.length <= 1000\n'},
      {
        'text':
            '• s consists of English letters (lower-case and upper-case), and digits.\n'
      },
    ],
    testcases: [
      {
        'title': 'Test Case 1',
        'input': "PAYPALISHIRING",
        'input2': 3,
        'output': "PAHNAPLSIIGYIR",
        'explain': 'The converted string is "PAHNAPLSIIGYIR".'
      },
      {
        'title': 'Test Case 2',
        'input': "PAYPALISHIRING",
        'input2': 4,
        'output': "PINALSIGYAHRPI",
        'explain': 'The converted string is "PINALSIGYAHRPI".'
      },
      {
        'title': 'Test Case 3',
        'input': "A",
        'input2': 1,
        'output': "A",
        'explain': 'The converted string is "A".'
      },
    ],
  ),
  Problem(
    id: '7',
    title: "Reverse Integer",
    status: "Solved",
    acceptanceRate: 26.5,
    difficulty: "Easy",
    frequency: "High",
    content: [
      {'text': 'Reverse Integer\n\n', 'fontSize': 24, 'isBold': true},
      {'text': 'Easy\n\n', 'color': 'green', 'isBold': true},
      {
        'text':
            'Given a signed 32-bit integer x, return x with its digits reversed. If reversing x causes the value to go outside the signed 32-bit integer range [-2^31, 2^31 - 1], then return 0.\n\n'
      },
      {
        'text':
            'Assume the environment does not allow you to store 64-bit integers (signed or unsigned).\n\n'
      },
      {'text': 'Constraints:\n', 'isBold': true},
      {'text': '• -2^31 <= x <= 2^31 - 1\n'},
    ],
    testcases: [
      {
        'title': 'Test Case 1',
        'input': 123,
        'output': 321,
        'explain': 'The reversed integer is 321.'
      },
      {
        'title': 'Test Case 2',
        'input': -123,
        'output': -321,
        'explain': 'The reversed integer is -321.'
      },
      {
        'title': 'Test Case 3',
        'input': 120,
        'output': 21,
        'explain': 'The reversed integer is 21.'
      },
    ],
  ),
  Problem(
    id: '8',
    title: "String to Integer (atoi)",
    status: "Unsolved",
    acceptanceRate: 18.7,
    difficulty: "Medium",
    frequency: "Medium",
    content: [
      {'text': 'String to Integer (atoi)\n\n', 'fontSize': 24, 'isBold': true},
      {'text': 'Medium\n\n', 'color': 'orange', 'isBold': true},
      {
        'text':
            'Implement the myAtoi(string s) function, which converts a string to a 32-bit signed integer (similar to C/C++\'s atoi function).\n\n'
      },
      {
        'text':
            'The algorithm needs to handle whitespace, optional leading \'+\' or \'-\' signs, and possible numeric overflow.\n\n'
      },
      {'text': 'Constraints:\n', 'isBold': true},
      {'text': '• 0 <= s.length <= 200\n'},
      {
        'text':
            '• s consists of English letters (upper-case and lower-case), digits, \' \', \'+\', \'-\', and \'.\'.\n'
      },
    ],
    testcases: [
      {
        'title': 'Test Case 1',
        'input': "42",
        'output': 42,
        'explain': 'The string is converted to 42.'
      },
      {
        'title': 'Test Case 2',
        'input': "   -42",
        'output': -42,
        'explain': 'The string is converted to -42.'
      },
      {
        'title': 'Test Case 3',
        'input': "4193 with words",
        'output': 4193,
        'explain':
            'The string is converted to 4193, ignoring the following words.'
      },
    ],
  ),
  Problem(
    id: '9',
    title: "Palindrome Number",
    status: "Solved",
    acceptanceRate: 46.5,
    difficulty: "Easy",
    frequency: "High",
    content: [
      {'text': 'Palindrome Number\n\n', 'fontSize': 24, 'isBold': true},
      {'text': 'Easy\n\n', 'color': 'green', 'isBold': true},
      {
        'text':
            'Given an integer x, return true if x is a palindrome, and false otherwise.\n\n'
      },
      {
        'text':
            'A number is a palindrome if it reads the same forward and backward.\n\n'
      },
      {'text': 'Constraints:\n', 'isBold': true},
      {'text': '• -2^31 <= x <= 2^31 - 1\n'},
    ],
    testcases: [
      {
        'title': 'Test Case 1',
        'input': 121,
        'output': true,
        'explain': '121 is a palindrome.'
      },
      {
        'title': 'Test Case 2',
        'input': -121,
        'output': false,
        'explain': '-121 is not a palindrome because of the negative sign.'
      },
      {
        'title': 'Test Case 3',
        'input': 10,
        'output': false,
        'explain':
            '10 is not a palindrome because it does not read the same forward and backward.'
      },
    ],
  ),
  Problem(
    id: '10',
    title: "Container With Most Water",
    status: "Unsolved",
    acceptanceRate: 51.2,
    difficulty: "Medium",
    frequency: "High",
    content: [
      {'text': 'Container With Most Water\n\n', 'fontSize': 24, 'isBold': true},
      {'text': 'Medium\n\n', 'color': 'orange', 'isBold': true},
      {
        'text':
            'Given n non-negative integers a1, a2, ..., an, where each represents a point at coordinate (i, ai). n vertical lines are drawn such that the two endpoints of the line i are at (i, ai) and (i, 0). Find two lines that together with the x-axis forms a container, such that the container contains the most water.\n\n'
      },
      {'text': 'Constraints:\n', 'isBold': true},
      {'text': '• n == height.length\n'},
      {'text': '• 2 <= n <= 10^5\n'},
      {'text': '• 0 <= height[i] <= 10^4\n'},
    ],
    testcases: [
      {
        'title': 'Test Case 1',
        'input': [1, 8, 6, 2, 5, 4, 8, 3, 7],
        'output': 49,
        'explain':
            'The most water can be contained between the second and the last line, with an area of 49.'
      },
      {
        'title': 'Test Case 2',
        'input': [1, 1],
        'output': 1,
        'explain':
            'The most water can be contained between the two lines, with an area of 1.'
      },
      {
        'title': 'Test Case 3',
        'input': [4, 3, 2, 1, 4],
        'output': 16,
        'explain':
            'The most water can be contained between the first and the last line, with an area of 16.'
      },
    ],
  ),
  // Additional problems go here (just copy and change the details as per each problem)
];
