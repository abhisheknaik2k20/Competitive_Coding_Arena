import numpy as np
from sklearn.metrics.pairwise import cosine_similarity
from collections import Counter
import datetime
import json

class LeetCodeRecommender:
    def __init__(self):
        self.users = {}
        self.topics = set([
            'Arrays', 'Strings', 'Hash Table', 'Dynamic Programming', 'Math',
            'Sorting', 'Greedy', 'Depth-First Search', 'Binary Search',
            'Breadth-First Search', 'Tree', 'Matrix', 'Two Pointers', 'Binary Tree',
            'Bit Manipulation', 'Heap', 'Stack', 'Graph', 'Prefix Sum',
            'Simulation', 'Design', 'Counting', 'Backtracking', 'Sliding Window',
            'Union Find', 'Linked List', 'Monotonic Stack', 'Recursion',
            'Divide and Conquer', 'Trie', 'Binary Search Tree', 'Queue', 'Memoization',
            'Topological Sort', 'Segment Tree', 'Binary Indexed Tree',
            'Data Structure Basics', 'Algorithm'
        ])
        self.journeys = set([
            '10 Essential DP Patterns', '30 Days of JavaScript',
            'Programming Skills', 'Algorithm I', 'Algorithm II',
            'Data Structure I', 'Data Structure II', 'Graph Theory I',
            'Binary Search I', 'Binary Search II', 'SQL I', 'SQL II',
            'System Design', 'Object-Oriented Design', 'Machine Learning 101',
            'Dynamic Programming I', 'Stack I', 'Heap I', 'Tree I',
            'Advanced Algorithms', 'Operating Systems Fundamentals',
            'Computer Networks Basics', 'Web Development Bootcamp',
            'Mobile App Development', 'Cloud Computing Essentials',
            'Cybersecurity Fundamentals', 'Data Science Primer',
            'Artificial Intelligence Concepts', 'Blockchain Basics',
            'DevOps Practices', 'Microservices Architecture',
            'Front-end Frameworks', 'Back-end Development',
            'Database Design and Management', 'RESTful API Design',
            'Concurrency and Parallelism', 'Functional Programming',
            'Software Testing and QA', 'Agile Methodologies',
            'Big Data Processing', 'Natural Language Processing',
            'Computer Vision Fundamentals', 'Quantum Computing Primer'
        ])
        self.topic_matrix = None
        self.journey_matrix = None
        self.difficulty_levels = ['Beginner', 'Intermediate', 'Advanced']

    def add_user(self, user_id, preferences):
        preferences['topics'] = set(preferences['topics'])
        preferences['journey'] = set(preferences['journey'])
        preferences['last_active'] = datetime.datetime.now()
        self.users[user_id] = preferences
        self.topics.update(preferences['topics'])
        self.journeys.update(preferences['journey'])

    def build_matrices(self):
        n_users = len(self.users)
        n_topics = len(self.topics)
        n_journeys = len(self.journeys)

        self.topic_matrix = np.zeros((n_users, n_topics))
        self.journey_matrix = np.zeros((n_users, n_journeys))

        topic_index = {topic: i for i, topic in enumerate(self.topics)}
        journey_index = {journey: i for i, journey in enumerate(self.journeys)}

        for i, (user_id, prefs) in enumerate(self.users.items()):
            for topic in prefs['topics']:
                self.topic_matrix[i, topic_index[topic]] = 1
            for journey in prefs['journey']:
                self.journey_matrix[i, journey_index[journey]] = 1

    def calculate_time_decay(self, last_active):
        days_since_active = (datetime.datetime.now() - last_active).days
        return np.exp(-days_since_active / 30)  # 30-day half-life

    def recommend(self, user_id, n_recommendations=10):
        if user_id not in self.users:
            return "User not found"

        user_index = list(self.users.keys()).index(user_id)
        user_prefs = self.users[user_id]

        time_decay = self.calculate_time_decay(user_prefs['last_active'])
        topic_similarities = cosine_similarity(self.topic_matrix[user_index:user_index+1], self.topic_matrix)[0] * time_decay
        journey_similarities = cosine_similarity(self.journey_matrix[user_index:user_index+1], self.journey_matrix)[0] * time_decay

        combined_similarities = 0.6 * topic_similarities + 0.4 * journey_similarities

        similar_users = sorted(
            [(i, score) for i, score in enumerate(combined_similarities) if i != user_index],
            key=lambda x: x[1],
            reverse=True
        )[:n_recommendations]

        recommendations = {
            'roadmap': Counter(),
            'journeys': Counter(),
            'explanations': []
        }

        # Always recommend Arrays, Strings, and Data Structure Basics first
        always_recommend = ['Arrays', 'Strings', 'Data Structure Basics']
        for topic in always_recommend:
            if topic not in user_prefs['topics']:
                recommendations['roadmap'][topic] = float('inf')  # Ensure these are at the top
                recommendations['explanations'].append(f"Always recommending {topic} as it's fundamental.")

        for similar_user_index, similarity_score in similar_users:
            similar_user_id = list(self.users.keys())[similar_user_index]
            similar_user_prefs = self.users[similar_user_id]

            new_topics = set(similar_user_prefs['topics']) - set(user_prefs['topics']) - set(always_recommend)
            new_journeys = set(similar_user_prefs['journey']) - set(user_prefs['journey'])

            for topic in new_topics:
                recommendations['roadmap'][topic] += similarity_score
            for journey in new_journeys:
                recommendations['journeys'][journey] += similarity_score

            if new_topics or new_journeys:
                explanation = f"Based on similarity with user (score: {similarity_score:.2f}):"
                if new_topics:
                    explanation += f" Suggested roadmap topics: {topic}."
                if new_journeys:
                    explanation += f" Recommended journeys: {journey}."
                recommendations['explanations'].append(explanation)
            
        user_difficulty = self.difficulty_levels.index(user_prefs['skillLevel'])
        for topic in self.topics - set(user_prefs['topics']) - set(always_recommend):
            if topic == 'Algorithm' and user_difficulty < 2:
                recommendations['roadmap'][topic] += 1
                recommendations['explanations'].append(f"Added {topic} to roadmap based on your skill level.")

        # Ensure at least 10 topics in the roadmap
        if len(recommendations['roadmap']) < 10:
            additional_topics = list(self.topics - set(user_prefs['topics']) - set(recommendations['roadmap'].keys()) - set(always_recommend))
            additional_topics = sorted(additional_topics, key=lambda x: len(set(x.split()) & set(user_prefs['topics'])), reverse=True)
            for topic in additional_topics[:10 - len(recommendations['roadmap'])]:
                recommendations['roadmap'][topic] = 0.1
                recommendations['explanations'].append(f"Added {topic} to complete your roadmap.")

        # Combine always_recommend topics with other recommendations
        final_roadmap = always_recommend + [topic for topic, _ in recommendations['roadmap'].most_common() if topic not in always_recommend]

        return {
            'programming_roadmap': final_roadmap[:n_recommendations],
            'recommended_journeys': [journey for journey, _ in recommendations['journeys'].most_common(n_recommendations)],
            'explanations': recommendations['explanations'][:n_recommendations]
        }

    def provide_feedback(self, user_id, topic=None, journey=None, rating=None):
        if user_id not in self.users:
            return "User not found"

        if topic:
            self.users[user_id]['topics'].add(topic)
        if journey:
            self.users[user_id]['journey'].add(journey)
        
        self.users[user_id]['last_active'] = datetime.datetime.now()

        if rating:
            pass

        self.build_matrices()

        return "Feedback recorded successfully"

def lambda_handler(event, context):
    # Parse the input event
    user_data = event.get('user_data', {})
    
    # Initialize the recommender
    recommender = LeetCodeRecommender()
    
    # Add sample users (in a real scenario, you'd load this data from a database)
    users_data = [
    ('user1', {'reason': 'learn', 'skillLevel': 'Intermediate', 'topics': ['Dynamic Programming', 'Arrays'], 'journey': ['10 Essential DP Patterns']}),
    ('user2', {'reason': 'interview', 'skillLevel': 'Advanced', 'topics': ['Data Structure Basics', 'Algorithms', 'Graph'], 'journey': ['Programming Skills', 'Algorithm II']}),
    ('user3', {'reason': 'learn', 'skillLevel': 'Beginner', 'topics': ['Arrays', 'Strings', 'Hash Table'], 'journey': ['Data Structure I']}),
    ('user4', {'reason': 'hobby', 'skillLevel': 'Intermediate', 'topics': ['Binary Search', 'Tree', 'Graph'], 'journey': ['Binary Search I', 'Tree I']}),
    ('user5', {'reason': 'career', 'skillLevel': 'Advanced', 'topics': ['Dynamic Programming', 'Greedy', 'Backtracking'], 'journey': ['Dynamic Programming I', 'Advanced Algorithms']}),
    ('user6', {'reason': 'learn', 'skillLevel': 'Beginner', 'topics': ['Two Pointers', 'Stack', 'Heap'], 'journey': ['Stack I', 'Heap I']}),
    ('user7', {'reason': 'interview', 'skillLevel': 'Intermediate', 'topics': ['Sliding Window', 'Union Find', 'Recursion'], 'journey': ['Algorithm I', 'Graph Theory I']}),
    ('user8', {'reason': 'career', 'skillLevel': 'Advanced', 'topics': ['Math', 'Sorting', 'Greedy'], 'journey': ['Algorithm I', 'Algorithm II']}),
    ('user9', {'reason': 'hobby', 'skillLevel': 'Beginner', 'topics': ['Bit Manipulation', 'Binary Tree'], 'journey': ['Tree I', 'Binary Search I']}),
    ('user10', {'reason': 'learn', 'skillLevel': 'Intermediate', 'topics': ['Breadth-First Search', 'Backtracking'], 'journey': ['Graph Theory I', 'Binary Search I']}),
    ('user11', {'reason': 'career', 'skillLevel': 'Beginner', 'topics': ['Arrays', 'Strings'], 'journey': ['30 Days of JavaScript']}),
    ('user12', {'reason': 'interview', 'skillLevel': 'Advanced', 'topics': ['Dynamic Programming', 'Math', 'Graph'], 'journey': ['Dynamic Programming I', 'Algorithm II']}),
    ('user13', {'reason': 'learn', 'skillLevel': 'Beginner', 'topics': ['Hash Table', 'Sorting'], 'journey': ['Data Structure I', 'Algorithm I']}),
    ('user14', {'reason': 'career', 'skillLevel': 'Intermediate', 'topics': ['Greedy', 'Depth-First Search'], 'journey': ['Algorithm II', 'Graph Theory I']}),
    ('user15', {'reason': 'hobby', 'skillLevel': 'Advanced', 'topics': ['Union Find', 'Dynamic Programming'], 'journey': ['Advanced Algorithms']}),
    ('user16', {'reason': 'learn', 'skillLevel': 'Beginner', 'topics': ['Binary Search', 'Two Pointers'], 'journey': ['Binary Search I', 'Stack I']}),
    ('user17', {'reason': 'career', 'skillLevel': 'Intermediate', 'topics': ['Tree', 'Graph'], 'journey': ['Tree I', 'Graph Theory I']}),
    ('user18', {'reason': 'interview', 'skillLevel': 'Advanced', 'topics': ['Dynamic Programming', 'Greedy'], 'journey': ['Algorithm II', 'Advanced Algorithms']}),
    ('user19', {'reason': 'learn', 'skillLevel': 'Beginner', 'topics': ['Recursion', 'Backtracking'], 'journey': ['Data Structure I', 'Binary Search I']}),
    ('user20', {'reason': 'career', 'skillLevel': 'Intermediate', 'topics': ['Sliding Window', 'Tree'], 'journey': ['Algorithm I', 'Tree I']})
]
    for user_id, preferences in users_data:
        recommender.add_user(user_id, preferences)
    user_id = user_data.get('user_id', 'new_user')
    preferences = {
        'reason': event.get('reason'),
        'skillLevel': event.get('skillLevel'),
        'topics': user_data.get('topics', []),
        'journey': user_data.get('journey', [])
    }
    recommender.add_user(user_id, preferences)
    recommender.build_matrices()
    recommendations = recommender.recommend(user_id, n_recommendations=10)
    response = {
        'statusCode': 200,
        'body': json.dumps(recommendations)
    }
    
    return response