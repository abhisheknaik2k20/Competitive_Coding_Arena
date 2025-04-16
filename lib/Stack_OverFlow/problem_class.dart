import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_syntax_view/flutter_syntax_view.dart';

class StackOverFlowProblemClass {
  final String name;
  final Timestamp time_stamp;
  final String category;
  final String problem_title;
  final String problem_description;
  final String code;
  final Syntax syntax;
  int? problem_id;
  final int upvotes;
  final int downvotes;
  final int views;
  final int answers;
  final List<String> tags;
  final String difficulty;

  StackOverFlowProblemClass({
    required this.name,
    required this.time_stamp,
    required this.category,
    required this.problem_title,
    required this.problem_description,
    required this.code,
    required this.syntax,
    required this.views,
    required this.upvotes,
    required this.downvotes,
    required this.answers,
    this.problem_id,
    required this.tags,
    required this.difficulty,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'time': time_stamp,
      'category': category,
      'problem_title': problem_title,
      'problem_description': problem_description,
      'code': code,
      'syntax': syntax.toString().split('.').last,
      'problem_id': problem_id,
      'tags': tags,
      'upvotes': upvotes,
      'downvotes': downvotes,
      'views': views,
      'answers': answers,
      'difficulty': difficulty,
    };
  }

  factory StackOverFlowProblemClass.fromMap(Map<String, dynamic> map) {
    return StackOverFlowProblemClass(
        name: map['name'],
        time_stamp: map['time_stamp'] ?? map['time'],
        category: map['category'],
        problem_title: map['problem_title'] ?? '',
        problem_description: map['problem_description'] ?? '',
        code: map['code'] ?? '',
        syntax: _stringToSyntax(map['syntax'] ?? ''),
        problem_id: map['problem_id'],
        tags: List<String>.from(map['tags'] ?? []),
        views: map['views'],
        upvotes: map['upvotes'],
        downvotes: map['downvotes'],
        answers: map['answers'],
        difficulty: map['difficulty']);
  }

  static Syntax _stringToSyntax(String syntaxString) {
    try {
      return Syntax.values.firstWhere(
        (element) => element.toString().split('.').last == syntaxString,
        orElse: () => Syntax.DART,
      );
    } catch (e) {
      return Syntax.DART;
    }
  }
}
