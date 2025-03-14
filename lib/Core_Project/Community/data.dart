final List<Map<String, dynamic>> skillClusteringData = [
  // Algorithm Experts Cluster
  {
    'clusterName': 'Algorithm Experts',
    'users': [
      {
        'id': 'AE001',
        'name': 'Alex Johnson',
        'rating': 2450,
        'problemsSolved': 276,
        'profileImage': 'assets/images/profiles/alex_j.png',
        'joinDate': '2022-04-15',
        'topSkills': ['Greedy Algorithms', 'Divide & Conquer', 'Binary Search'],
        'recentProblems': [
          {
            'name': 'Maximum Subarray',
            'difficulty': 'Medium',
            'date': '2025-03-10'
          },
          {
            'name': 'Merge K Sorted Lists',
            'difficulty': 'Hard',
            'date': '2025-03-05'
          },
          {
            'name': 'Quick Sort Implementation',
            'difficulty': 'Medium',
            'date': '2025-03-01'
          }
        ],
        'skillDistribution': {
          'Greedy Algorithms': 92,
          'Divide & Conquer': 88,
          'Sorting': 95,
          'Searching': 90,
          'Dynamic Programming': 75
        }
      },
      {
        'id': 'AE002',
        'name': 'Maria Zhang',
        'rating': 2510,
        'problemsSolved': 312,
        'profileImage': 'assets/images/profiles/maria_z.png',
        'joinDate': '2021-11-23',
        'topSkills': ['Sorting', 'Searching', 'Recursion'],
        'recentProblems': [
          {
            'name': 'Kth Largest Element',
            'difficulty': 'Medium',
            'date': '2025-03-12'
          },
          {
            'name': 'Minimum Time to Complete Tasks',
            'difficulty': 'Hard',
            'date': '2025-03-07'
          },
          {
            'name': 'Search in Rotated Array',
            'difficulty': 'Medium',
            'date': '2025-03-02'
          }
        ],
        'skillDistribution': {
          'Greedy Algorithms': 85,
          'Divide & Conquer': 96,
          'Sorting': 98,
          'Searching': 97,
          'Dynamic Programming': 82
        }
      },
      {
        'id': 'AE003',
        'name': 'David Kumar',
        'rating': 2390,
        'problemsSolved': 254,
        'profileImage': 'assets/images/profiles/david_k.png',
        'joinDate': '2022-08-05',
        'topSkills': ['Divide & Conquer', 'Binary Search', 'Recursion'],
        'recentProblems': [
          {
            'name': 'Median of Two Sorted Arrays',
            'difficulty': 'Hard',
            'date': '2025-03-09'
          },
          {
            'name': 'Find Peak Element',
            'difficulty': 'Medium',
            'date': '2025-03-04'
          },
          {
            'name': 'Quickselect Algorithm',
            'difficulty': 'Hard',
            'date': '2025-02-28'
          }
        ],
        'skillDistribution': {
          'Greedy Algorithms': 87,
          'Divide & Conquer': 94,
          'Sorting': 89,
          'Searching': 95,
          'Dynamic Programming': 78
        }
      }
    ]
  },

  // Data Structure Wizards Cluster
  {
    'clusterName': 'Data Structure Wizards',
    'users': [
      {
        'id': 'DSW001',
        'name': 'Sarah Chen',
        'rating': 2280,
        'problemsSolved': 203,
        'profileImage': 'assets/images/profiles/sarah_c.png',
        'joinDate': '2022-05-18',
        'topSkills': ['Trees', 'Graphs', 'Hash Tables'],
        'recentProblems': [
          {
            'name': 'LRU Cache Implementation',
            'difficulty': 'Medium',
            'date': '2025-03-11'
          },
          {
            'name': 'Serialize and Deserialize Binary Tree',
            'difficulty': 'Hard',
            'date': '2025-03-06'
          },
          {
            'name': 'Graph Valid Tree',
            'difficulty': 'Medium',
            'date': '2025-03-01'
          }
        ],
        'skillDistribution': {
          'Trees': 94,
          'Graphs': 90,
          'Heaps': 85,
          'Hash Tables': 92,
          'Linked Lists': 88
        }
      },
      {
        'id': 'DSW002',
        'name': 'Michael Patel',
        'rating': 2190,
        'problemsSolved': 187,
        'profileImage': 'assets/images/profiles/michael_p.png',
        'joinDate': '2022-09-12',
        'topSkills': ['Heaps', 'Linked Lists', 'Trees'],
        'recentProblems': [
          {
            'name': 'Merge Two Binary Trees',
            'difficulty': 'Easy',
            'date': '2025-03-10'
          },
          {
            'name': 'Top K Frequent Elements',
            'difficulty': 'Medium',
            'date': '2025-03-05'
          },
          {
            'name': 'Implement Trie',
            'difficulty': 'Medium',
            'date': '2025-02-28'
          }
        ],
        'skillDistribution': {
          'Trees': 91,
          'Graphs': 82,
          'Heaps': 95,
          'Hash Tables': 83,
          'Linked Lists': 93
        }
      },
      {
        'id': 'DSW003',
        'name': 'Emma Rodriguez',
        'rating': 2170,
        'problemsSolved': 195,
        'profileImage': 'assets/images/profiles/emma_r.png',
        'joinDate': '2022-06-30',
        'topSkills': ['Graphs', 'Hash Tables', 'Trees'],
        'recentProblems': [
          {'name': 'Clone Graph', 'difficulty': 'Medium', 'date': '2025-03-12'},
          {
            'name': 'Design HashMap',
            'difficulty': 'Easy',
            'date': '2025-03-07'
          },
          {
            'name': 'Balanced Binary Tree',
            'difficulty': 'Easy',
            'date': '2025-03-02'
          }
        ],
        'skillDistribution': {
          'Trees': 89,
          'Graphs': 96,
          'Heaps': 80,
          'Hash Tables': 93,
          'Linked Lists': 84
        }
      }
    ]
  },

  // DP Enthusiasts Cluster
  {
    'clusterName': 'DP Enthusiasts',
    'users': [
      {
        'id': 'DPE001',
        'name': 'James Wilson',
        'rating': 2380,
        'problemsSolved': 231,
        'profileImage': 'assets/images/profiles/james_w.png',
        'joinDate': '2022-03-25',
        'topSkills': ['Dynamic Programming', 'Memoization', 'Tabulation'],
        'recentProblems': [
          {
            'name': 'Longest Increasing Subsequence',
            'difficulty': 'Medium',
            'date': '2025-03-11'
          },
          {'name': 'Coin Change', 'difficulty': 'Medium', 'date': '2025-03-06'},
          {'name': 'Edit Distance', 'difficulty': 'Hard', 'date': '2025-03-01'}
        ],
        'skillDistribution': {
          'Dynamic Programming': 97,
          'Memoization': 95,
          'Tabulation': 94,
          'State Machines': 88,
          'Greedy Algorithms': 79
        }
      },
      {
        'id': 'DPE002',
        'name': 'Aisha Patel',
        'rating': 2260,
        'problemsSolved': 204,
        'profileImage': 'assets/images/profiles/aisha_p.png',
        'joinDate': '2022-07-14',
        'topSkills': ['State Machines', 'Dynamic Programming', 'Tabulation'],
        'recentProblems': [
          {
            'name': 'House Robber',
            'difficulty': 'Medium',
            'date': '2025-03-10'
          },
          {
            'name': 'Unique Paths',
            'difficulty': 'Medium',
            'date': '2025-03-05'
          },
          {
            'name': 'Palindrome Partitioning',
            'difficulty': 'Hard',
            'date': '2025-02-28'
          }
        ],
        'skillDistribution': {
          'Dynamic Programming': 92,
          'Memoization': 88,
          'Tabulation': 91,
          'State Machines': 96,
          'Greedy Algorithms': 75
        }
      },
      {
        'id': 'DPE003',
        'name': 'Carlos Mendez',
        'rating': 2310,
        'problemsSolved': 218,
        'profileImage': 'assets/images/profiles/carlos_m.png',
        'joinDate': '2022-05-03',
        'topSkills': ['Memoization', 'Dynamic Programming', 'State Machines'],
        'recentProblems': [
          {
            'name': 'Maximum Product Subarray',
            'difficulty': 'Medium',
            'date': '2025-03-12'
          },
          {
            'name': 'Minimum Path Sum',
            'difficulty': 'Medium',
            'date': '2025-03-07'
          },
          {
            'name': 'Wildcard Matching',
            'difficulty': 'Hard',
            'date': '2025-03-02'
          }
        ],
        'skillDistribution': {
          'Dynamic Programming': 94,
          'Memoization': 97,
          'Tabulation': 89,
          'State Machines': 92,
          'Greedy Algorithms': 80
        }
      }
    ]
  },

  // Graph Theory Masters Cluster
  {
    'clusterName': 'Graph Theory Masters',
    'users': [
      {
        'id': 'GTM001',
        'name': 'Olivia Kim',
        'rating': 2540,
        'problemsSolved': 247,
        'profileImage': 'assets/images/profiles/olivia_k.png',
        'joinDate': '2022-02-11',
        'topSkills': ['Network Flow', 'Shortest Path', 'Graph Traversal'],
        'recentProblems': [
          {
            'name': 'Network Delay Time',
            'difficulty': 'Medium',
            'date': '2025-03-11'
          },
          {
            'name': 'Minimum Spanning Tree',
            'difficulty': 'Hard',
            'date': '2025-03-06'
          },
          {
            'name': 'Course Schedule',
            'difficulty': 'Medium',
            'date': '2025-03-01'
          }
        ],
        'skillDistribution': {
          'Graph Traversal': 92,
          'Shortest Path': 95,
          'Network Flow': 98,
          'Topological Sort': 93,
          'Dynamic Programming': 86
        }
      },
      {
        'id': 'GTM002',
        'name': 'Rahul Gupta',
        'rating': 2430,
        'problemsSolved': 235,
        'profileImage': 'assets/images/profiles/rahul_g.png',
        'joinDate': '2022-04-28',
        'topSkills': ['Topological Sort', 'Graph Traversal', 'Shortest Path'],
        'recentProblems': [
          {
            'name': 'Alien Dictionary',
            'difficulty': 'Hard',
            'date': '2025-03-10'
          },
          {
            'name': 'Evaluate Division',
            'difficulty': 'Medium',
            'date': '2025-03-05'
          },
          {'name': 'Word Ladder', 'difficulty': 'Hard', 'date': '2025-02-28'}
        ],
        'skillDistribution': {
          'Graph Traversal': 94,
          'Shortest Path': 92,
          'Network Flow': 88,
          'Topological Sort': 97,
          'Dynamic Programming': 83
        }
      },
      {
        'id': 'GTM003',
        'name': 'Sophie Miller',
        'rating': 2490,
        'problemsSolved': 241,
        'profileImage': 'assets/images/profiles/sophie_m.png',
        'joinDate': '2022-06-15',
        'topSkills': ['Shortest Path', 'Network Flow', 'Topological Sort'],
        'recentProblems': [
          {
            'name': 'Cheapest Flights Within K Stops',
            'difficulty': 'Medium',
            'date': '2025-03-12'
          },
          {
            'name': 'Critical Connections',
            'difficulty': 'Hard',
            'date': '2025-03-07'
          },
          {
            'name': 'Reconstruct Itinerary',
            'difficulty': 'Medium',
            'date': '2025-03-02'
          }
        ],
        'skillDistribution': {
          'Graph Traversal': 90,
          'Shortest Path': 96,
          'Network Flow': 94,
          'Topological Sort': 91,
          'Dynamic Programming': 85
        }
      }
    ]
  }
];

// Additional detailed user profiles for potential popup/detail views
final List<Map<String, dynamic>> detailedUserProfiles = [
  {
    'id': 'AE001',
    'name': 'Alex Johnson',
    'fullName': 'Alexander Johnson',
    'title': 'Senior Algorithm Engineer',
    'company': 'TechSolutions Inc.',
    'education': 'M.S. Computer Science, Stanford University',
    'bio':
        'Passionate about efficient algorithms and optimization problems. Regularly contributes to open-source algorithm libraries.',
    'rating': 2450,
    'problemsSolved': 276,
    'profileImage': 'assets/images/profiles/alex_j.png',
    'joinDate': '2022-04-15',
    'location': 'San Francisco, CA',
    'achievements': [
      'Weekly Contest Winner (3 times)',
      'Top 100 in Global Leaderboard',
      'Algorithm Challenge Champion 2024'
    ],
    'badges': [
      {'name': 'Problem Solver', 'level': 'Gold'},
      {'name': 'Greedy Master', 'level': 'Platinum'},
      {'name': 'Binary Search Expert', 'level': 'Gold'}
    ],
    'completedCourses': [
      'Advanced Algorithm Design',
      'Competitive Programming Masterclass',
      'System Design for Performance'
    ],
    'problemSolvingStats': {
      'easy': {'solved': 95, 'total': 100, 'averageTime': '5m 23s'},
      'medium': {'solved': 129, 'total': 150, 'averageTime': '18m 42s'},
      'hard': {'solved': 52, 'total': 75, 'averageTime': '42m 15s'}
    },
    'skillDistribution': {
      'Greedy Algorithms': 92,
      'Divide & Conquer': 88,
      'Sorting': 95,
      'Searching': 90,
      'Dynamic Programming': 75
    },
    'recentSubmissions': [
      {
        'problem': 'Maximum Subarray',
        'status': 'Accepted',
        'runtime': '0.3ms',
        'memory': '42MB',
        'date': '2025-03-10'
      },
      {
        'problem': 'Merge K Sorted Lists',
        'status': 'Accepted',
        'runtime': '1.2ms',
        'memory': '48MB',
        'date': '2025-03-05'
      },
      {
        'problem': 'Quick Sort Implementation',
        'status': 'Accepted',
        'runtime': '0.8ms',
        'memory': '45MB',
        'date': '2025-03-01'
      }
    ],
    'learningPath': {
      'currentCourse': 'Advanced Graph Algorithms',
      'progress': 75,
      'nextRecommendation': 'Network Flow Algorithms'
    },
    'favorites': {
      'topics': ['Binary Search', 'Greedy Algorithms', 'Heap Operations'],
      'problems': [
        'Median of Two Sorted Arrays',
        'Minimum Spanning Tree',
        'Merge Intervals'
      ]
    }
  }
];
