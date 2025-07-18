import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Exercise {
  final String question;
  final String answer;
  final bool isMCQ;

  Exercise({
    required this.question,
    required this.answer,
    this.isMCQ = false, // Assuming default is not MCQ
  });

  factory Exercise.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Exercise(
      question: data['question'] ?? '',
      answer: data['answer'] ?? '',
      isMCQ: data['isMCQ'] ?? false,
    );
  }

  // Factory function to create an Exercise object from a map (useful when data is embedded)
  factory Exercise.fromMap(Map<String, dynamic> map) {
    return Exercise(
      question: map['question'] ?? '',
      answer: map['answer'] ?? '',
      isMCQ: map['isMCQ'] ?? false,
    );
  }
}

class Chapter {
  final String id;
  final String title;
  final String introduction;
  bool isCompleted;
  final int? order;

  Chapter({
    required this.id,
    required this.title,
    required this.introduction,
    this.isCompleted = false,
    this.order,
  });

  factory Chapter.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Chapter(
      id: doc.id,
      title: data['title'] ?? '',
      introduction: data['introduction'] ?? '',
      isCompleted: data['isCompleted'] ?? false,
      order: data['order'] as int?,
    );
  }
}

class Course {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final DocumentReference reference;
  final String? downloadUrl;

  Course({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl = '',
    required this.reference,
    this.downloadUrl,
  });

  factory Course.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Course(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      reference: doc.reference,
      downloadUrl: data['downloadUrl'],
    );
  }
}

class ChapterContent {
  final List<String> outcomes;
  final List<Topic> topics;
  final List<QuestionAnswer> solvedExamples;

  ChapterContent({
    required this.outcomes,
    required this.topics,
    required this.solvedExamples,
  });

  factory ChapterContent.fromMap(Map<String, dynamic> map) {
    debugPrint("❌ ❌ Incoming ChapterContent: $map");
    return ChapterContent(
      outcomes:
          map['outcomes'] != null ? List<String>.from(map['outcomes']) : [],
      topics:
          (map['topics'] as List? ?? [])
              .map((t) => Topic.fromMap(t as Map<String, dynamic>))
              .toList(),
      solvedExamples:
          (map['solvedExamples'] as List? ?? [])
              .map((e) => QuestionAnswer.fromMap(e as Map<String, dynamic>))
              .toList(),
    );
  }
}

class QuestionAnswer {
  final String question;
  final String answer;

  QuestionAnswer({required this.question, required this.answer});

  factory QuestionAnswer.fromMap(Map<String, dynamic> map) {
    return QuestionAnswer(
      question: map['question'] ?? '',
      answer: map['answer'] ?? '',
    );
  }
}

class Topic {
  final String title;
  final List<String> explanation;
  final TableData? table;

  Topic({required this.title, required this.explanation, this.table});

  factory Topic.fromMap(Map<String, dynamic> map) {
    List<String> explanationList = [];
    if (map['explanation'] is List) {
      explanationList = List<String>.from(map['explanation']);
    } else if (map['explanation'] is String) {
      explanationList = [map['explanation']];
    }
    return Topic(
      title: map['title'] ?? '',
      explanation: explanationList,
      table: map['table'] != null ? TableData.fromMap(map['table']) : null,
    );
  }
}

class TableData {
  final List<String> headers;
  final List<Map<String, String>> rows;

  TableData({required this.headers, required this.rows});

  factory TableData.fromMap(Map<String, dynamic> map) {
    return TableData(
      headers: map['headers'] != null ? List<String>.from(map['headers']) : [],
      rows:
          (map['rows'] as List? ?? [])
              .map((row) => Map<String, String>.from(row))
              .toList(),
    );
  }
}

// Mapping functions
Course courseFromFirestore(DocumentSnapshot doc) {
  return Course.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>);
}

Chapter chapterFromFirestore(DocumentSnapshot doc) {
  return Chapter.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>);
}

Exercise exerciseFromFirestore(DocumentSnapshot doc) {
  return Exercise.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>);
}

ChapterContent chapterContentFromMap(Map<String, dynamic> map) {
  return ChapterContent.fromMap(map);
}
