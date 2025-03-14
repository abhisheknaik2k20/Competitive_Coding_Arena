import 'package:cloud_firestore/cloud_firestore.dart';

class Contest {
  final int Contest_id;
  final Timestamp start;
  final Timestamp end;
  final List<int> Questions_id;
  final List<Map<String, dynamic>> content;
  final List<String> reg_ids;

  Contest(
      {required this.Contest_id,
      required this.start,
      required this.end,
      required this.Questions_id,
      required this.content,
      required this.reg_ids});

  factory Contest.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Contest(
        Contest_id: data['Contest_id'] ?? 0,
        start: data['start'] ?? Timestamp.now(),
        end: data['end'] ?? Timestamp.now(),
        Questions_id: List<int>.from(data['Questions_id'] ?? []),
        content: List<Map<String, dynamic>>.from(data['content'] ?? []),
        reg_ids: List<String>.from(data['reg_ids'] ?? []));
  }
  Map<String, dynamic> toFirestore() {
    return {
      'Contest_id': Contest_id,
      'start': start,
      'end': end,
      'Questions_id': Questions_id,
      'content': content,
      'reg_ids': reg_ids,
    };
  }
}

List<Contest> contestexmaple = [
  Contest(
    Contest_id: 1,
    start: Timestamp.fromDate(DateTime(2024, 9, 1, 9, 0)),
    end: Timestamp.fromDate(DateTime(2024, 9, 1, 12, 0)),
    Questions_id: [1, 2, 3],
    content: [
      {
        'title': 'Introduction',
        'description': 'Contest overview',
        'points': 10
      },
      {
        'title': 'Problem 1',
        'description': 'Solve the first problem',
        'points': 50
      },
      {
        'title': 'Problem 2',
        'description': 'Solve the second problem',
        'points': 70
      },
    ],
    reg_ids: [],
  ),
];
Future<void> updateContestsInFirestore(List<Contest> contests) async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final CollectionReference contestsCollection =
      firestore.collection('contests');
  final Timestamp now = Timestamp.now();

  for (Contest contest in contests) {
    String status = contest.end.compareTo(now) > 0 ? 'online' : 'offline';
    Map<String, dynamic> contestData = {
      'Contest_id': contest.Contest_id,
      'start': contest.start,
      'end': contest.end,
      'Questions_id': contest.Questions_id,
      'content': contest.content,
      'reg_ids': contest.reg_ids,
      'status': status,
    };
    await contestsCollection
        .doc(contest.Contest_id.toString())
        .set(contestData, SetOptions(merge: true));
  }
  print('All contests updated in Firestore.');
}
