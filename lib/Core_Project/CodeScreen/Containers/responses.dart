List<Map<String, dynamic>> responses = [
  {
    "stdout":
        "Test Case 1:\nInput: nums = [2, 7, 11, 15], target = 9\nOutput: [0, 1]\nTest Case 2:\nInput: nums = [3, 2, 4], target = 6\nOutput: [1, 2]\nTest Case 3:\nInput: nums = [3, 3], target = 6\nOutput: [0, 1]\n",
    "executionTime": "197.45 ms",
    "solution": """
def twoSum(nums, target):
    num_dict = {}
    for i, num in enumerate(nums):
        complement = target - num
        if complement in num_dict:
            return [num_dict[complement], i]
        num_dict[num] = i
    return []  # No solution found

# Test cases
test_cases = [
    ([2, 7, 11, 15], 9),
    ([3, 2, 4], 6),
    ([3, 3], 6)
]

for i, (nums, target) in enumerate(test_cases, 1):
    result = twoSum(nums, target)
    print(f"Test Case {i}:")
    print(f"Input: nums = {nums}, target = {target}")
    print(f"Output: {result}")
    print()
        """,
    "name": "Abhishek Naik"
  },
  {
    "stdout":
        "Test Case 1:\nInput: nums = [2, 7, 11, 15], target = 9\nOutput: [0, 1]\nTest Case 2:\nInput: nums = [3, 2, 4], target = 6\nOutput: [1, 2]\nTest Case 3:\nInput: nums = [3, 3], target = 6\nOutput: [0, 1]\n",
    "executionTime": "215.32 ms",
    "solution": """
def find_two_sum(numbers, target_sum):
    seen = {}
    for index, value in enumerate(numbers):
        needed = target_sum - value
        if needed in seen:
            return [seen[needed], index]
        seen[value] = index
    return []

test_cases = [
    ([2, 7, 11, 15], 9),
    ([3, 2, 4], 6),
    ([3, 3], 6)
]

for i, (nums, target) in enumerate(test_cases, 1):
    result = find_two_sum(nums, target)
    print(f"Test Case {i}:")
    print(f"Input: nums = {nums}, target = {target}")
    print(f"Output: {result}")
    print()
        """,
    "name": "Priya Sharma"
  },
  {
    "stdout":
        "Test Case 1:\nInput: nums = [2, 7, 11, 15], target = 9\nOutput: [0, 1]\nTest Case 2:\nInput: nums = [3, 2, 4], target = 6\nOutput: [1, 2]\nTest Case 3:\nInput: nums = [3, 3], target = 6\nOutput: [0, 1]\n",
    "executionTime": "189.76 ms",
    "solution": """
def sum_pair_indices(arr, goal):
    index_map = {}
    for i, num in enumerate(arr):
        if goal - num in index_map:
            return [index_map[goal - num], i]
        index_map[num] = i
    return []

test_cases = [
    ([2, 7, 11, 15], 9),
    ([3, 2, 4], 6),
    ([3, 3], 6)
]

for i, (nums, target) in enumerate(test_cases, 1):
    result = sum_pair_indices(nums, target)
    print(f"Test Case {i}:")
    print(f"Input: nums = {nums}, target = {target}")
    print(f"Output: {result}")
    print()
        """,
    "name": "Raj Patel"
  },
  {
    "stdout":
        "Test Case 1:\nInput: nums = [2, 7, 11, 15], target = 9\nOutput: [0, 1]\nTest Case 2:\nInput: nums = [3, 2, 4], target = 6\nOutput: [1, 2]\nTest Case 3:\nInput: nums = [3, 3], target = 6\nOutput: [0, 1]\n",
    "executionTime": "230.18 ms",
    "solution": """
def get_two_sum_indices(numbers, target):
    num_to_index = {}
    for i, num in enumerate(numbers):
        complement = target - num
        if complement in num_to_index:
            return [num_to_index[complement], i]
        num_to_index[num] = i
    return []

test_cases = [
    ([2, 7, 11, 15], 9),
    ([3, 2, 4], 6),
    ([3, 3], 6)
]

for i, (nums, target) in enumerate(test_cases, 1):
    result = get_two_sum_indices(nums, target)
    print(f"Test Case {i}:")
    print(f"Input: nums = {nums}, target = {target}")
    print(f"Output: {result}")
    print()
        """,
    "name": "Aisha Khan"
  },
  {
    "stdout":
        "Test Case 1:\nInput: nums = [2, 7, 11, 15], target = 9\nOutput: [0, 1]\nTest Case 2:\nInput: nums = [3, 2, 4], target = 6\nOutput: [1, 2]\nTest Case 3:\nInput: nums = [3, 3], target = 6\nOutput: [0, 1]\n",
    "executionTime": "205.91 ms",
    "solution": """
def two_sum_solver(array, target_sum):
    complement_dict = {}
    for i, num in enumerate(array):
        if num in complement_dict:
            return [complement_dict[num], i]
        complement_dict[target_sum - num] = i
    return []

test_cases = [
    ([2, 7, 11, 15], 9),
    ([3, 2, 4], 6),
    ([3, 3], 6)
]

for i, (nums, target) in enumerate(test_cases, 1):
    result = two_sum_solver(nums, target)
    print(f"Test Case {i}:")
    print(f"Input: nums = {nums}, target = {target}")
    print(f"Output: {result}")
    print()
        """,
    "name": "Chen Wei"
  },
  {
    "stdout":
        "Test Case 1:\nInput: nums = [2, 7, 11, 15], target = 9\nOutput: [0, 1]\nTest Case 2:\nInput: nums = [3, 2, 4], target = 6\nOutput: [1, 2]\nTest Case 3:\nInput: nums = [3, 3], target = 6\nOutput: [0, 1]\n",
    "executionTime": "212.54 ms",
    "solution": """
def find_pair_indices(nums, target):
    seen = {}
    for i, num in enumerate(nums):
        if target - num in seen:
            return [seen[target - num], i]
        seen[num] = i
    return []

test_cases = [
    ([2, 7, 11, 15], 9),
    ([3, 2, 4], 6),
    ([3, 3], 6)
]

for i, (nums, target) in enumerate(test_cases, 1):
    result = find_pair_indices(nums, target)
    print(f"Test Case {i}:")
    print(f"Input: nums = {nums}, target = {target}")
    print(f"Output: {result}")
    print()
        """,
    "name": "Emma Johnson"
  },
  {
    "stdout":
        "Test Case 1:\nInput: nums = [2, 7, 11, 15], target = 9\nOutput: [0, 1]\nTest Case 2:\nInput: nums = [3, 2, 4], target = 6\nOutput: [1, 2]\nTest Case 3:\nInput: nums = [3, 3], target = 6\nOutput: [0, 1]\n",
    "executionTime": "198.67 ms",
    "solution": """
def two_sum_finder(numbers, target):
    num_dict = {num: i for i, num in enumerate(numbers)}
    for i, num in enumerate(numbers):
        complement = target - num
        if complement in num_dict and num_dict[complement] != i:
            return [i, num_dict[complement]]
    return []

test_cases = [
    ([2, 7, 11, 15], 9),
    ([3, 2, 4], 6),
    ([3, 3], 6)
]

for i, (nums, target) in enumerate(test_cases, 1):
    result = two_sum_finder(nums, target)
    print(f"Test Case {i}:")
    print(f"Input: nums = {nums}, target = {target}")
    print(f"Output: {result}")
    print()
        """,
    "name": "Liam O'Connor"
  },
  {
    "stdout":
        "Test Case 1:\nInput: nums = [2, 7, 11, 15], target = 9\nOutput: [0, 1]\nTest Case 2:\nInput: nums = [3, 2, 4], target = 6\nOutput: [1, 2]\nTest Case 3:\nInput: nums = [3, 3], target = 6\nOutput: [0, 1]\n",
    "executionTime": "220.13 ms",
    "solution": """
def solve_two_sum(arr, target):
    complement_map = {}
    for i, num in enumerate(arr):
        if num in complement_map:
            return [complement_map[num], i]
        complement_map[target - num] = i
    return []

test_cases = [
    ([2, 7, 11, 15], 9),
    ([3, 2, 4], 6),
    ([3, 3], 6)
]

for i, (nums, target) in enumerate(test_cases, 1):
    result = solve_two_sum(nums, target)
    print(f"Test Case {i}:")
    print(f"Input: nums = {nums}, target = {target}")
    print(f"Output: {result}")
    print()
        """,
    "name": "Sofia Rodriguez"
  },
  {
    "stdout":
        "Test Case 1:\nInput: nums = [2, 7, 11, 15], target = 9\nOutput: [0, 1]\nTest Case 2:\nInput: nums = [3, 2, 4], target = 6\nOutput: [1, 2]\nTest Case 3:\nInput: nums = [3, 3], target = 6\nOutput: [0, 1]\n",
    "executionTime": "208.89 ms",
    "solution": """
def two_sum_solution(numbers, goal):
    index_dict = {}
    for i, num in enumerate(numbers):
        if goal - num in index_dict:
            return [index_dict[goal - num], i]
        index_dict[num] = i
    return []

test_cases = [
    ([2, 7, 11, 15], 9),
    ([3, 2, 4], 6),
    ([3, 3], 6)
]

for i, (nums, target) in enumerate(test_cases, 1):
    result = two_sum_solution(nums, target)
    print(f"Test Case {i}:")
    print(f"Input: nums = {nums}, target = {target}")
    print(f"Output: {result}")
    print()
        """,
    "name": "Akira Tanaka"
  },
  {
    "stdout":
        "Test Case 1:\nInput: nums = [2, 7, 11, 15], target = 9\nOutput: [0, 1]\nTest Case 2:\nInput: nums = [3, 2, 4], target = 6\nOutput: [1, 2]\nTest Case 3:\nInput: nums = [3, 3], target = 6\nOutput: [0, 1]\n",
    "executionTime": "225.76 ms",
    "solution": """
def find_two_sum_indices(array, sum_target):
    num_to_index = {}
    for i, num in enumerate(array):
        complement = sum_target - num
        if complement in num_to_index:
            return [num_to_index[complement], i]
        num_to_index[num] = i
    return []

test_cases = [
    ([2, 7, 11, 15], 9),
    ([3, 2, 4], 6),
    ([3, 3], 6)
]

for i, (nums, target) in enumerate(test_cases, 1):
    result = find_two_sum_indices(nums, target)
    print(f"Test Case {i}:")
    print(f"Input: nums = {nums}, target = {target}")
    print(f"Output: {result}")
    print()
        """,
    "name": "Isabella Martinez"
  },
  {
    "stdout":
        "Test Case 1:\nInput: nums = [2, 7, 11, 15], target = 9\nOutput: [0, 1]\nTest Case 2:\nInput: nums = [3, 2, 4], target = 6\nOutput: [1, 2]\nTest Case 3:\nInput: nums = [3, 3], target = 6\nOutput: [0, 1]\n",
    "executionTime": "202.34 ms",
    "solution": """
def two_sum_index_finder(nums, target_sum):
    seen = {}
    for i, num in enumerate(nums):
        if target_sum - num in seen:
            return [seen[target_sum - num], i]
        seen[num] = i
    return []

test_cases = [
    ([2, 7, 11, 15], 9),
    ([3, 2, 4], 6),
    ([3, 3], 6)
]

for i, (nums, target) in enumerate(test_cases, 1):
    result = two_sum_index_finder(nums, target)
    print(f"Test Case {i}:")
    print(f"Input: nums = {nums}, target = {target}")
    print(f"Output: {result}")
    print()
        """,
    "name": "Ahmed Hassan"
  }
];

List<Map<String, dynamic>> javaresponses = [
  {
    'stdout': '''Test Case 1:
Input: nums = [2, 7, 11, 15], target = 9
Output: [0, 1]
Test Case 2:
Input: nums = [3, 2, 4], target = 6
Output: [1, 2]
Test Case 3:
Input: nums = [3, 3], target = 6
Output: [0, 1]
''',
    'executionTime': 2638.66,
    'solution': '''import java.util.*;
class Main {
    public static int[] twoSum(int[] nums, int target) {
        Map<Integer, Integer> map = new HashMap<>();
        for (int i = 0; i < nums.length; i++) {
            int complement = target - nums[i];
            if (map.containsKey(complement)) {
                return new int[] { map.get(complement), i };
            }
            map.put(nums[i], i);
        }
        return new int[]{};
    }
    public static void main(String[] args) {
        int[][] testCases = {{2, 7, 11, 15}, {3, 2, 4}, {3, 3}};
        int[] targets = {9, 6, 6};
        for (int i = 0; i < testCases.length; i++) {
            int[] result = twoSum(testCases[i], targets[i]);
            System.out.println("Test Case " + (i+1) + ":");
            System.out.println("Input: nums = " + Arrays.toString(testCases[i]) + ", target = " + targets[i]);
            System.out.println("Output: " + Arrays.toString(result));
            System.out.println();
        }
    }
}''',
    'name': 'Abhishek Naik'
  },
  {
    'stdout': '''Test Case 1:
Input: nums = [2, 7, 11, 15], target = 9
Output: [0, 1]
Test Case 2:
Input: nums = [3, 2, 4], target = 6
Output: [1, 2]
Test Case 3:
Input: nums = [3, 3], target = 6
Output: [0, 1]
''',
    'executionTime': 2845.12,
    'solution': '''import java.util.*;
class Main {
    public static int[] twoSum(int[] nums, int target) {
        for (int i = 0; i < nums.length; i++) {
            for (int j = i + 1; j < nums.length; j++) {
                if (nums[i] + nums[j] == target) {
                    return new int[] {i, j};
                }
            }
        }
        return new int[]{};
    }
    public static void main(String[] args) {
        int[][] testCases = {{2, 7, 11, 15}, {3, 2, 4}, {3, 3}};
        int[] targets = {9, 6, 6};
        for (int i = 0; i < testCases.length; i++) {
            int[] result = twoSum(testCases[i], targets[i]);
            System.out.println("Test Case " + (i+1) + ":");
            System.out.println("Input: nums = " + Arrays.toString(testCases[i]) + ", target = " + targets[i]);
            System.out.println("Output: " + Arrays.toString(result));
            System.out.println();
        }
    }
}''',
    'name': 'Priya Sharma'
  },
  {
    'stdout': '''Test Case 1:
Input: nums = [2, 7, 11, 15], target = 9
Output: [0, 1]
Test Case 2:
Input: nums = [3, 2, 4], target = 6
Output: [1, 2]
Test Case 3:
Input: nums = [3, 3], target = 6
Output: [0, 1]
''',
    'executionTime': 2532.89,
    'solution': '''import java.util.*;
class Main {
    public static int[] twoSum(int[] nums, int target) {
        Map<Integer, Integer> numMap = new HashMap<>();
        for (int i = 0; i < nums.length; i++) {
            numMap.put(nums[i], i);
        }
        for (int i = 0; i < nums.length; i++) {
            int complement = target - nums[i];
            if (numMap.containsKey(complement) && numMap.get(complement) != i) {
                return new int[] {i, numMap.get(complement)};
            }
        }
        return new int[]{};
    }
    public static void main(String[] args) {
        int[][] testCases = {{2, 7, 11, 15}, {3, 2, 4}, {3, 3}};
        int[] targets = {9, 6, 6};
        for (int i = 0; i < testCases.length; i++) {
            int[] result = twoSum(testCases[i], targets[i]);
            System.out.println("Test Case " + (i+1) + ":");
            System.out.println("Input: nums = " + Arrays.toString(testCases[i]) + ", target = " + targets[i]);
            System.out.println("Output: " + Arrays.toString(result));
            System.out.println();
        }
    }
}''',
    'name': 'Rahul Gupta'
  },
  {
    'stdout': '''Test Case 1:
Input: nums = [2, 7, 11, 15], target = 9
Output: [0, 1]
Test Case 2:
Input: nums = [3, 2, 4], target = 6
Output: [1, 2]
Test Case 3:
Input: nums = [3, 3], target = 6
Output: [0, 1]
''',
    'executionTime': 2721.45,
    'solution': '''import java.util.*;
class Main {
    public static int[] twoSum(int[] nums, int target) {
        List<Integer> numList = new ArrayList<>();
        for (int num : nums) {
            numList.add(num);
        }
        for (int i = 0; i < nums.length; i++) {
            int complement = target - nums[i];
            int complementIndex = numList.indexOf(complement);
            if (complementIndex != -1 && complementIndex != i) {
                return new int[] {i, complementIndex};
            }
        }
        return new int[]{};
    }
    public static void main(String[] args) {
        int[][] testCases = {{2, 7, 11, 15}, {3, 2, 4}, {3, 3}};
        int[] targets = {9, 6, 6};
        for (int i = 0; i < testCases.length; i++) {
            int[] result = twoSum(testCases[i], targets[i]);
            System.out.println("Test Case " + (i+1) + ":");
            System.out.println("Input: nums = " + Arrays.toString(testCases[i]) + ", target = " + targets[i]);
            System.out.println("Output: " + Arrays.toString(result));
            System.out.println();
        }
    }
}''',
    'name': 'Ananya Patel'
  },
  {
    'stdout': '''Test Case 1:
Input: nums = [2, 7, 11, 15], target = 9
Output: [0, 1]
Test Case 2:
Input: nums = [3, 2, 4], target = 6
Output: [1, 2]
Test Case 3:
Input: nums = [3, 3], target = 6
Output: [0, 1]
''',
    'executionTime': 2598.23,
    'solution': '''import java.util.*;
class Main {
    public static int[] twoSum(int[] nums, int target) {
        Map<Integer, Integer> numMap = new HashMap<>();
        for (int i = 0; i < nums.length; i++) {
            int complement = target - nums[i];
            if (numMap.containsKey(complement)) {
                return new int[] {numMap.get(complement), i};
            }
            numMap.put(nums[i], i);
        }
        throw new IllegalArgumentException("No two sum solution");
    }
    public static void main(String[] args) {
        int[][] testCases = {{2, 7, 11, 15}, {3, 2, 4}, {3, 3}};
        int[] targets = {9, 6, 6};
        for (int i = 0; i < testCases.length; i++) {
            int[] result = twoSum(testCases[i], targets[i]);
            System.out.println("Test Case " + (i+1) + ":");
            System.out.println("Input: nums = " + Arrays.toString(testCases[i]) + ", target = " + targets[i]);
            System.out.println("Output: " + Arrays.toString(result));
            System.out.println();
        }
    }
}''',
    'name': 'Vikram Singh'
  },
  {
    'stdout': '''Test Case 1:
Input: nums = [2, 7, 11, 15], target = 9
Output: [0, 1]
Test Case 2:
Input: nums = [3, 2, 4], target = 6
Output: [1, 2]
Test Case 3:
Input: nums = [3, 3], target = 6
Output: [0, 1]
''',
    'executionTime': 2687.91,
    'solution': '''import java.util.*;
class Main {
    public static int[] twoSum(int[] nums, int target) {
        int[] sortedNums = nums.clone();
        Arrays.sort(sortedNums);
        int left = 0, right = sortedNums.length - 1;
        while (left < right) {
            int sum = sortedNums[left] + sortedNums[right];
            if (sum == target) {
                int index1 = -1, index2 = -1;
                for (int i = 0; i < nums.length; i++) {
                    if (nums[i] == sortedNums[left] && index1 == -1) {
                        index1 = i;
                    } else if (nums[i] == sortedNums[right]) {
                        index2 = i;
                    }
                }
                return new int[] {Math.min(index1, index2), Math.max(index1, index2)};
            } else if (sum < target) {
                left++;
            } else {
                right--;
            }
        }
        return new int[]{};
    }
    public static void main(String[] args) {
        int[][] testCases = {{2, 7, 11, 15}, {3, 2, 4}, {3, 3}};
        int[] targets = {9, 6, 6};
        for (int i = 0; i < testCases.length; i++) {
            int[] result = twoSum(testCases[i], targets[i]);
            System.out.println("Test Case " + (i+1) + ":");
            System.out.println("Input: nums = " + Arrays.toString(testCases[i]) + ", target = " + targets[i]);
            System.out.println("Output: " + Arrays.toString(result));
            System.out.println();
        }
    }
}''',
    'name': 'Neha Reddy'
  },
  {
    'stdout': '''Test Case 1:
Input: nums = [2, 7, 11, 15], target = 9
Output: [0, 1]
Test Case 2:
Input: nums = [3, 2, 4], target = 6
Output: [1, 2]
Test Case 3:
Input: nums = [3, 3], target = 6
Output: [0, 1]
''',
    'executionTime': 2789.56,
    'solution': '''import java.util.*;
class Main {
    public static int[] twoSum(int[] nums, int target) {
        for (int i = 0; i < nums.length; i++) {
            int complement = target - nums[i];
            for (int j = i + 1; j < nums.length; j++) {
                if (nums[j] == complement) {
                    return new int[] {i, j};
                }
            }
        }
        throw new IllegalArgumentException("No two sum solution");
    }
    public static void main(String[] args) {
        int[][] testCases = {{2, 7, 11, 15}, {3, 2, 4}, {3, 3}};
        int[] targets = {9, 6, 6};
        for (int i = 0; i < testCases.length; i++) {
            int[] result = twoSum(testCases[i], targets[i]);
            System.out.println("Test Case " + (i+1) + ":");
            System.out.println("Input: nums = " + Arrays.toString(testCases[i]) + ", target = " + targets[i]);
            System.out.println("Output: " + Arrays.toString(result));
            System.out.println();
        }
    }
}''',
    'name': 'Arjun Desai'
  },
  {
    'stdout': '''Test Case 1:
Input: nums = [2, 7, 11, 15], target = 9
Output: [0, 1]
Test Case 2:
Input: nums = [3, 2, 4], target = 6
Output: [1, 2]
Test Case 3:
Input: nums = [3, 3], target = 6
Output: [0, 1]
''',
    'executionTime': 2654.78,
    'solution': '''import java.util.*;
class Main {
    public static int[] twoSum(int[] nums, int target) {
        Map<Integer, Integer> seen = new HashMap<>();
        for (int i = 0; i < nums.length; ++i) {
            int complement = target - nums[i];
            if (seen.containsKey(complement)) {
                return new int[] { seen.get(complement), i };
            }
            seen.put(nums[i], i);
        }
        throw new IllegalArgumentException("No two sum solution");
    }
    public static void main(String[] args) {
        int[][] testCases = {{2, 7, 11, 15}, {3, 2, 4}, {3, 3}};
        int[] targets = {9, 6, 6};
        for (int i = 0; i < testCases.length; i++) {
            int[] result = twoSum(testCases[i], targets[i]);
            System.out.println("Test Case " + (i+1) + ":");
            System.out.println("Input: nums = " + Arrays.toString(testCases[i]) + ", target = " + targets[i]);
            System.out.println("Output: " + Arrays.toString(result));
            System.out.println();
        }
    }
}''',
    'name': 'Meera Iyer'
  }
];

List<Map<String, dynamic>> cppresponses = [
  {
    'stdout': '''Test Case 1:
Input: nums = [2, 7, 11, 15], target = 9
Output: [0, 1]
Test Case 2:
Input: nums = [3, 2, 4], target = 6
Output: [1, 2]
Test Case 3:
Input: nums = [3, 3], target = 6
Output: [0, 1]
''',
    'executionTime': 1.45,
    'solution': '''#include <iostream>
#include <vector>
#include <unordered_map>
using namespace std;

class Solution {
public:
    vector<int> twoSum(vector<int>& nums, int target) {
        unordered_map<int, int> map;
        for (int i = 0; i < nums.size(); i++) {
            int complement = target - nums[i];
            if (map.find(complement) != map.end()) {
                return {map[complement], i};
            }
            map[nums[i]] = i;
        }
        return {};
    }
};

int main() {
    Solution sol;
    vector<vector<int>> testCases = {{2, 7, 11, 15}, {3, 2, 4}, {3, 3}};
    vector<int> targets = {9, 6, 6};
    
    for (int i = 0; i < testCases.size(); i++) {
        cout << "Test Case " << i+1 << ":" << endl;
        cout << "Input: nums = [";
        for (int j = 0; j < testCases[i].size(); j++) {
            cout << testCases[i][j];
            if (j < testCases[i].size() - 1) cout << ", ";
        }
        cout << "], target = " << targets[i] << endl;
        
        vector<int> result = sol.twoSum(testCases[i], targets[i]);
        cout << "Output: [" << result[0] << ", " << result[1] << "]" << endl << endl;
    }
    return 0;
}''',
    'name': 'Aditya Kumar'
  },
  {
    'stdout': '''Test Case 1:
Input: nums = [2, 7, 11, 15], target = 9
Output: [0, 1]
Test Case 2:
Input: nums = [3, 2, 4], target = 6
Output: [1, 2]
Test Case 3:
Input: nums = [3, 3], target = 6
Output: [0, 1]
''',
    'executionTime': 2.92,
    'solution': '''#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

class Solution {
public:
    vector<int> twoSum(vector<int>& nums, int target) {
        vector<pair<int, int>> numWithIndex;
        for (int i = 0; i < nums.size(); i++) {
            numWithIndex.push_back({nums[i], i});
        }
        sort(numWithIndex.begin(), numWithIndex.end());
        
        int left = 0, right = nums.size() - 1;
        while (left < right) {
            int sum = numWithIndex[left].first + numWithIndex[right].first;
            if (sum == target) {
                return {numWithIndex[left].second, numWithIndex[right].second};
            } else if (sum < target) {
                left++;
            } else {
                right--;
            }
        }
        return {};
    }
};

int main() {
    Solution sol;
    vector<vector<int>> testCases = {{2, 7, 11, 15}, {3, 2, 4}, {3, 3}};
    vector<int> targets = {9, 6, 6};
    
    for (int i = 0; i < testCases.size(); i++) {
        cout << "Test Case " << i+1 << ":" << endl;
        cout << "Input: nums = [";
        for (int j = 0; j < testCases[i].size(); j++) {
            cout << testCases[i][j];
            if (j < testCases[i].size() - 1) cout << ", ";
        }
        cout << "], target = " << targets[i] << endl;
        
        vector<int> result = sol.twoSum(testCases[i], targets[i]);
        cout << "Output: [" << result[0] << ", " << result[1] << "]" << endl << endl;
    }
    return 0;
}''',
    'name': 'Sneha Patel'
  },
  {
    'stdout': '''Test Case 1:
Input: nums = [2, 7, 11, 15], target = 9
Output: [0, 1]
Test Case 2:
Input: nums = [3, 2, 4], target = 6
Output: [1, 2]
Test Case 3:
Input: nums = [3, 3], target = 6
Output: [0, 1]
''',
    'executionTime': 1.67,
    'solution': '''#include <iostream>
#include <vector>
using namespace std;

class Solution {
public:
    vector<int> twoSum(vector<int>& nums, int target) {
        for (int i = 0; i < nums.size(); i++) {
            for (int j = i + 1; j < nums.size(); j++) {
                if (nums[i] + nums[j] == target) {
                    return {i, j};
                }
            }
        }
        return {};
    }
};

int main() {
    Solution sol;
    vector<vector<int>> testCases = {{2, 7, 11, 15}, {3, 2, 4}, {3, 3}};
    vector<int> targets = {9, 6, 6};
    
    for (int i = 0; i < testCases.size(); i++) {
        cout << "Test Case " << i+1 << ":" << endl;
        cout << "Input: nums = [";
        for (int j = 0; j < testCases[i].size(); j++) {
            cout << testCases[i][j];
            if (j < testCases[i].size() - 1) cout << ", ";
        }
        cout << "], target = " << targets[i] << endl;
        
        vector<int> result = sol.twoSum(testCases[i], targets[i]);
        cout << "Output: [" << result[0] << ", " << result[1] << "]" << endl << endl;
    }
    return 0;
}''',
    'name': 'Rajesh Gupta'
  },
  {
    'stdout': '''Test Case 1:
Input: nums = [2, 7, 11, 15], target = 9
Output: [0, 1]
Test Case 2:
Input: nums = [3, 2, 4], target = 6
Output: [1, 2]
Test Case 3:
Input: nums = [3, 3], target = 6
Output: [0, 1]
''',
    'executionTime': 2.34,
    'solution': '''#include <iostream>
#include <vector>
#include <unordered_set>
using namespace std;

class Solution {
public:
    vector<int> twoSum(vector<int>& nums, int target) {
        unordered_set<int> seen;
        for (int i = 0; i < nums.size(); i++) {
            int complement = target - nums[i];
            if (seen.find(complement) != seen.end()) {
                for (int j = 0; j < i; j++) {
                    if (nums[j] == complement) {
                        return {j, i};
                    }
                }
            }
            seen.insert(nums[i]);
        }
        return {};
    }
};

int main() {
    Solution sol;
    vector<vector<int>> testCases = {{2, 7, 11, 15}, {3, 2, 4}, {3, 3}};
    vector<int> targets = {9, 6, 6};
    
    for (int i = 0; i < testCases.size(); i++) {
        cout << "Test Case " << i+1 << ":" << endl;
        cout << "Input: nums = [";
        for (int j = 0; j < testCases[i].size(); j++) {
            cout << testCases[i][j];
            if (j < testCases[i].size() - 1) cout << ", ";
        }
        cout << "], target = " << targets[i] << endl;
        
        vector<int> result = sol.twoSum(testCases[i], targets[i]);
        cout << "Output: [" << result[0] << ", " << result[1] << "]" << endl << endl;
    }
    return 0;
}''',
    'name': 'Priya Sharma'
  },
  {
    'stdout': '''Test Case 1:
Input: nums = [2, 7, 11, 15], target = 9
Output: [0, 1]
Test Case 2:
Input: nums = [3, 2, 4], target = 6
Output: [1, 2]
Test Case 3:
Input: nums = [3, 3], target = 6
Output: [0, 1]
''',
    'executionTime': 3.21,
    'solution': '''#include <iostream>
#include <vector>
#include <unordered_map>
using namespace std;

class Solution {
public:
    vector<int> twoSum(vector<int>& nums, int target) {
        unordered_map<int, int> numToIndex;
        for (int i = 0; i < nums.size(); i++) {
            numToIndex[nums[i]] = i;
        }
        for (int i = 0; i < nums.size(); i++) {
            int complement = target - nums[i];
            if (numToIndex.count(complement) && numToIndex[complement] != i) {
                return {i, numToIndex[complement]};
            }
        }
        return {};
    }
};

int main() {
    Solution sol;
    vector<vector<int>> testCases = {{2, 7, 11, 15}, {3, 2, 4}, {3, 3}};
    vector<int> targets = {9, 6, 6};
    
    for (int i = 0; i < testCases.size(); i++) {
        cout << "Test Case " << i+1 << ":" << endl;
        cout << "Input: nums = [";
        for (int j = 0; j < testCases[i].size(); j++) {
            cout << testCases[i][j];
            if (j < testCases[i].size() - 1) cout << ", ";
        }
        cout << "], target = " << targets[i] << endl;
        
        vector<int> result = sol.twoSum(testCases[i], targets[i]);
        cout << "Output: [" << result[0] << ", " << result[1] << "]" << endl << endl;
    }
    return 0;
}''',
    'name': 'Vikram Reddy'
  }
];
