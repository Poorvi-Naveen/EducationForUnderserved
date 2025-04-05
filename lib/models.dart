// class Exercise {
//   final String name;
//   final String description;
//   bool isCompleted;

//   Exercise({
//     required this.name,
//     required this.description,
//     this.isCompleted = false,
//   });
// }

// class Chapter {
//   final String title;
//   final String introduction;
//   final List<Exercise> exercises;
//   bool isCompleted;

//   Chapter({
//     required this.title,
//     required this.introduction,
//     required this.exercises,
//     this.isCompleted = false,
//   });
// }

// class Course {
//   final String title;
//   final String description;
//   final String imageUrl;
//   final List<Chapter> chapters;

//   Course({
//     required this.title,
//     required this.description,
//     this.imageUrl = '',
//     required this.chapters,
//   });
// }

// // Sample data with Exercise objects
// final List<Course> courses = [
//   Course(
//     title: 'Flutter Development',
//     description: 'Learn to build cross-platform mobile apps with Flutter',
//     imageUrl: 'assets/flutter.png',
//     chapters: [
//       Chapter(
//         title: 'Introduction to Flutter',
//         introduction:
//             'In this chapter, you will learn the basics of Flutter framework and Dart programming language.',
//         exercises: [
//           Exercise(
//             name: 'Install Flutter SDK and required tools',
//             description: 'Set up Flutter development environment',
//           ),
//           Exercise(
//             name: 'Create your first Flutter app',
//             description: 'Build a simple "Hello World" app',
//           ),
//           Exercise(
//             name: 'Understand the basic widget structure',
//             description: 'Learn about Stateless and Stateful Widgets',
//           ),
//         ],
//       ),
//       Chapter(
//         title: 'UI Components',
//         introduction:
//             'This chapter covers the essential UI components in Flutter.',
//         exercises: [
//           Exercise(
//             name: 'Work with Text and Button widgets',
//             description: 'Learn how to use Text and Button widgets',
//           ),
//           Exercise(
//             name: 'Implement layouts using Row, Column, and Container',
//             description: 'Build flexible UIs using layout widgets',
//           ),
//           Exercise(
//             name: 'Create scrollable lists with ListView',
//             description: 'Understand how to use ListView',
//           ),
//         ],
//       ),
//     ],
//   ),
// ];

import 'package:cloud_firestore/cloud_firestore.dart';

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

  Course({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl = '',
    required this.reference,
  });

  factory Course.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Course(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      reference: doc.reference,
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
