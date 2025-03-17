import 'package:flutter_syntax_view/flutter_syntax_view.dart';

class StackOverFlowProblemClass {
  final String category;
  final String problem_title;
  final String problem_description;
  final String code;
  final Syntax syntax;
  int? problem_id;
  final List<String> tags;

  StackOverFlowProblemClass({
    required this.category,
    required this.problem_title,
    required this.problem_description,
    required this.code,
    required this.syntax,
    this.problem_id,
    required this.tags,
  });

  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'problem_title': problem_title,
      'problem_description': problem_description,
      'code': code,
      'syntax': syntax.toString(),
      'problem_id': problem_id,
      'tags': tags,
    };
  }

  factory StackOverFlowProblemClass.fromMap(Map<String, dynamic> map) {
    return StackOverFlowProblemClass(
      category: map['category'],
      problem_title: map['problem_title'] ?? '',
      problem_description: map['problem_description'] ?? '',
      code: map['code'] ?? '',
      syntax: _stringToSyntax(map['syntax'] ?? ''),
      problem_id: map['problem_id'],
      tags: List<String>.from(map['tags'] ?? []),
    );
  }

  static Syntax _stringToSyntax(String syntaxString) {
    try {
      return Syntax.values.firstWhere(
        (element) => element.toString() == 'Syntax.$syntaxString',
        orElse: () => Syntax.DART,
      );
    } catch (e) {
      return Syntax.DART;
    }
  }
}

List<String> categories = ['WEB/DEV', 'DSA', 'MOBILE'];

List<StackOverFlowProblemClass> stflow_problems = [
  StackOverFlowProblemClass(
      problem_id: 2,
      category: categories[1],
      problem_title: "Program Throws Segmentation Fault",
      problem_description:
          '''I'm trying to implement a program that finds the length of the longest substring without repeating characters for multiple test cases. The logic for the function seems correct, but when I run the program, it crashes with a segmentation fault.
I suspect there might be an issue with how I'm iterating through the test cases, but I’m not entirely sure. Can someone help me figure out what’s causing this and how to fix it?
''',
      code: '''
#include <iostream>
#include <unordered_map>
using namespace std;

int lengthOfLongestSubstring(string s) {
    unordered_map<char, int> charIndex;
    int maxLength = 0, left = 0;
    for (int right = 0; right < s.length(); right++) {
        if (charIndex.find(s[right]) != charIndex.end() && charIndex[s[right]] >= left) {
            left = charIndex[s[right]] + 1;
        }
        charIndex[s[right]] = right;
        maxLength = max(maxLength, right - left + 1);
    }
    return maxLength;
}
int main() {
    string test_cases[] = {"abcabcbb", "bbbbb", "pwwkew", "", "abcdef", "abba"};
    int num_cases = sizeof(test_cases) / sizeof(test_cases[0]);
    for (int i = 0; i <= num_cases; i++) {
        cout << "Test case: " << test_cases[i] << " -> ";
        cout << "Length of Longest Substring Without Repeating Characters: " << lengthOfLongestSubstring(test_cases[i]) << endl;
    }
    return 0;
}
      ''',
      syntax: Syntax.CPP,
      tags: ['C++', 'DSA']),
  StackOverFlowProblemClass(
      problem_id: 3,
      category: categories[1],
      problem_title: "Find Median of Two Sorted Arrays",
      problem_description:
          '''I'm trying to solve the classic "Median of Two Sorted Arrays" problem. Given two sorted arrays nums1 and nums2 of size m and n respectively, I need to find the median of the two sorted arrays.

The overall run time complexity should be O(log(m+n)).

I've implemented a solution in Java, but I'm not sure if it's the most efficient approach. I'm getting the correct output for the test cases I've tried, but I'd appreciate if someone could review my code and suggest any optimizations or point out any edge cases I might have missed.
''',
      code: '''
def find_median_sorted_arrays(nums1, nums2):
    if len(nums1) > len(nums2):
        nums1, nums2 = nums2, nums1
    
    x, y = len(nums1), len(nums2)
    low, high = 0, x
    
    while low <= high:
        partition_x = (low + high) // 2
        partition_y = (x + y + 1) // 2 - partition_x
        
        max_x = float('-inf') if partition_x == 0 else nums1[partition_x - 1]
        min_x = float('inf') if partition_x == x else nums1[partition_x]
        
        max_y = float('-inf') if partition_y == 0 else nums2[partition_y - 1]
        min_y = float('inf') if partition_y == y else nums2[partition_y]
        
        if max_x <= min_y and max_y <= min_x:
            if (x + y) % 2 == 0:
                return (max(max_x, max_y) + min(min_x, min_y)) / 2.0
            else:
                return max(max_x, max_y)
        elif max_x > min_y:
            high = partition_x - 1
        else:
            low = partition_x + 1
    
    raise ValueError("Input arrays are not sorted")

def main():
    test_cases = [
        ([1, 3], [2]),           
        ([1, 2], [3, 4]),        
        ([1, 2, 3], None),       
        ([1, 2, "3"], [4, 5, 6]) 
    ]
    
    for i, (nums1, nums2) in enumerate(test_cases):
        try:
            print(find_median_sorted_arrays(nums1, nums2))
        except Exception as e:
            print(f"{type(e).__name__}: {e}")

if __name__ == "__main__":
    main()
''',
      syntax: Syntax.SWIFT,
      tags: ['PYTHON', 'DSA', 'Binary Search', 'Arrays']),
  StackOverFlowProblemClass(
      problem_id: 5,
      category: categories[1],
      problem_title: "ZigZag Conversion Implementation",
      problem_description:
          '''I'm trying to solve the ZigZag Conversion problem. The problem asks to convert a string into a zigzag pattern and then read it line by line.

For example, the string "PAYPALISHIRING" written in a zigzag pattern with 3 rows looks like:
P   A   H   N
A P L S I I G
Y   I   R

And reading line by line, we get "PAHNAPLSIIGYIR".

I've implemented a solution in C++, but I'm not sure if it's optimal. I'm especially concerned about the time and space complexity. My current implementation uses a vector of strings to represent each row, but I'm wondering if there's a more efficient approach.

Could someone review my code and suggest improvements or point out any bugs?
''',
      code: '''
#include <iostream>
#include <vector>
#include <string>
using namespace std;

class Solution {
public:
    string convert(string s, int numRows) {
        if (numRows <= 1 || s.length() <= numRows) {
            return s;
        }
        
        vector<string> rows(numRows);
        int row = 0;
        bool goingDown = false;
        
        for (char c : s) {
            rows[row] += c;
            if (row == 0 || row == numRows - 1) {
                goingDown = !goingDown;
            }
            row += goingDown ? 1 : -1;
        }
        
        string result;
        for (string rowStr : rows) {
            result += rowStr;
        }
        
        return result;
    }
};

int main() {
    Solution solution;
    
    vector<pair<string, int>> test_cases = {
        {"PAYPALISHIRING", 3},
        {"PAYPALISHIRING", 4},
        {"A", 1},
        {"AB", 1},
        {"ABC", 2},
        {"ABCDEFGHIJKLMNOPQRSTUVWXYZ", 5}
    };
    
    for (const auto& test : test_cases) {
        cout << solution.convert(test.first, test.second) << endl;
    }
    
    return 0;
}
      ''',
      syntax: Syntax.CPP,
      tags: ['C++', 'String', 'Data Structures']),
  StackOverFlowProblemClass(
      problem_id: 8,
      category: categories[1],
      problem_title: "Palindrome Number Solution Crashing",
      problem_description:
          '''I'm trying to solve the Palindrome Number problem from LeetCode. The problem asks to determine whether an integer is a palindrome (reads the same forward and backward).

For example:
- 121 is a palindrome
- -121 is not a palindrome (from left to right, it reads -121, from right to left, it reads 121-)
- 10 is not a palindrome

I've implemented a solution that works for most test cases, but it's crashing with a segmentation fault for some inputs. I'm not sure what's causing this issue.

Here's my code. Can someone help me identify what's causing the segmentation fault?
''',
      code: '''
#include <iostream>
#include <vector>
using namespace std;

class Solution {
public:
    bool isPalindrome(int x) {
        if (x < 0) {
            return false;
        }
        vector<int> digits;
        int temp = x;
        
        while (temp > 0) {
            digits.push_back(temp % 10);
            temp /= 10;
        }
    
        int left = 0;
        int right = digits.size() - 1;
        while (left <= right) {
            if (digits[left] != digits[right]) {
                return false;
            }
            left++;
            right--;
        }
        
        return true;
    }
};

int main() {
    Solution solution;
    vector<int> testCases = {121, -121, 10, 12321, 0};
    for (int testCase : testCases) {
        cout << "Is " << testCase << " a palindrome? ";
        cout << (solution.isPalindrome(testCase) ? "true" : "false") << endl;
    }
    return 0;
}
      ''',
      syntax: Syntax.CPP,
      tags: [
        'C++',
        'Algorithms',
        'Integer',
        'Palindrome',
        'Segmentation Fault'
      ]),
  StackOverFlowProblemClass(
    category: categories[0],
    problem_title: "Invisible Counter",
    problem_description: '''
I'm trying to build a simple counter in React, but for some reason, the counter value isn't displaying on the screen. The buttons for increment and decrement seem to work, but I can't actually see the number update when I click them.

I'm using useState to manage the count, and the buttons are updating the state correctly. However, the count is either missing or not rendering properly inside the component. I’ve checked my code, but I can’t figure out what’s wrong.

Can someone help me fix this? I just want the counter to show the current count value while still allowing users to increment and decrement it. 
      ''',
    code: '''
function Counter() {
  // Initialize state
  const [count, setCount] = React.useState(0); 
  return React.createElement(
    'div', 
    { className: 'p-6 max-w-sm mx-auto bg-white rounded-xl shadow-lg flex flex-col items-center space-y-4' },
    [
      React.createElement('h2', { className: 'text-2xl font-bold text-purple-700', key: 'title' }, 'React Counter'),
      React.createElement('p', { className: 'text-gray-700', key: 'count' }, `Count:`),
      React.createElement('div', { className: 'flex space-x-3', key: 'buttons' }, [
        React.createElement(
          'button',
          { 
            className: 'px-4 py-2 bg-purple-600 text-white rounded-md hover:bg-purple-700',
            onClick: () => setCount(count + 1),
            key: 'inc-btn'
          },
          'Increment'
        ),
        React.createElement(
          'button',
          { 
            className: 'px-4 py-2 bg-gray-500 text-white rounded-md hover:bg-gray-600',
            onClick: () => setCount(count - 1),
            key: 'dec-btn'
          },
          'Decrement'
        )
      ])
    ]
  );
}
      ''',
    syntax: Syntax.JAVASCRIPT,
    tags: ["REACT", "JAVASCRIPT", "HTML", "CSS"],
  ),
  StackOverFlowProblemClass(
    category: categories[0],
    problem_title: "TODO-LIST Problem",
    code: '''
function App() {
  const [todos, setTodos] = useState([]);
  const [input, setInput] = useState('');
  
  const addTodo = () => {
    if (input.trim() !== '') {
      setTodos([...todos, { id: Date.now(), text: input, completed: false }]);
      setInput('');
    }
  };
  
  const toggleTodo = (id) => {
    setTodos(todos.map(todo => 
      todo.id === id ? { ...todo, completed: !todo.completed } : todo
    ));
  };
  
  const deleteTodo = (id) => {
    setTodos(todos.filter(todo => todo.id !== id));
  };
  
  return (
    <div className="max-w-md mx-auto p-4">
      <h1 className="text-2xl font-bold mb-4">Todo List</h1>
      
      <div className="flex mb-4">
        <input
          type="text"
          className="flex-1 border border-gray-300 p-2 rounded-l"
          value={input}
          onChange={(e) => setInput(e.target.value)}
          onKeyPress={(e) => e.key === 'Enter' && addTodo()}
          placeholder="Add a new task..."
        />
        <button 
          className="bg-green-500 text-white px-4 py-2 rounded-r"
          onClick={addTodo}
        >
          Add
        </button>
      </div>
      
      <ul className="space-y-2">
        {todos.map(todo => (
          <li 
            key={todo.id}
            className="flex items-center justify-between bg-white p-3 rounded shadow"
          >
            <div className="flex items-center">
              <input
                type="checkbox"
                checked={todo.completed}
                onChange={() => toggleTodo(todo.id)}
                className="mr-2"
              />
              <span style={{ textDecoration: todo.completed ? 'line-through' : 'none' }}>
                {todo.text}
              </span>
            </div>
            <button 
              onClick={() => deleteTodo(todo.id)}
              className="text-red-500 hover:text-red-700"
            >
              Delete
            </button>
          </li>
        ))}
      </ul>
    </div>
  );
}
''',
    problem_description: '''
I'm working on a simple React Todo List, and everything seems to be functioning fine except for one issue—the input field doesn't clear itself after adding a new task.
When I type something in the input field and press "Enter" or click the "Add" button, the new todo does get added to the list correctly, but the text I typed remains in the input field instead of clearing out. I expected it to reset to an empty string after submitting, but that’s not happening.
''',
    syntax: Syntax.JAVASCRIPT,
    tags: ["REACT", "JAVASCRIPT", "HTML", "CSS"],
  ),
  StackOverFlowProblemClass(
    category: categories[0],
    problem_title: "Tab Selection Problem",
    problem_description: '''
I've Implemented this react code for basic switching between the tabs on a WEB-Page but for some reason the screen doesn't seem update when the tab button is pressed. I’ve checked my code, but I can’t figure out what’s wrong.
Can someone help me fix this?
    ''',
    code: '''
function MyComponent() {
  const [activeTab, setActiveTab] = useState(1);
  const [content, setContent] = useState('This is the content for Tab 1');
  
  const handleTabChange = (tab) => {
    setActiveTab(tab);
    
    const tabContents = {
      1: "This is the content for Tab 1",
      2: "Tab 2 has different content that appears when selected",
      3: "The third tab shows this custom content"
    };
    
    setContent(tabContents[tab]);
  };
  
  return (
    <div className="max-w-md mx-auto p-4 bg-white rounded shadow">
      <div className="flex border-b">
        {[1, 2, 3].map(tab => (
          <button
            key={tab}
            className={`px-4 py-2 \${activeTab === tab 
              ? 'border-b-2 border-blue-500 text-blue-600' 
              : 'text-gray-600'}`}
            onClick={() => handleTabChange(tab)}
          >
            Tab {tab}
          </button>
        ))}
      </div>
      
      <div className="p-4">
        {content}
      </div>
    </div>
  );
}
 ''',
    syntax: Syntax.JAVASCRIPT,
    tags: ["REACT", "JAVASCRIPT", "HTML", "CSS"],
  )
];
