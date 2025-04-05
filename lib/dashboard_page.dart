import 'package:flutter/material.dart';
import 'progress_indicator.dart';

class Progress {
  final String courseName;
  final int completedLessons;
  final int totalLessons;
  final double completionRate;

  Progress({
    required this.courseName,
    required this.completedLessons,
    required this.totalLessons,
  }) : completionRate =
           totalLessons > 0 ? completedLessons / totalLessons : 0.0;
}

class DashboardPage extends StatelessWidget {
  DashboardPage({Key? key}) : super(key: key);

  final List<Progress> userProgress = [
    Progress(
      courseName: "Flutter Basics",
      completedLessons: 5,
      totalLessons: 10,
    ),
    Progress(courseName: "Dart Advanced", completedLessons: 3, totalLessons: 8),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Dashboard'),
        elevation: 0,
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple.shade50, Colors.blue.shade100],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome Back!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple[700],
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Here is your progress overview:',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children:
                        userProgress.map((progress) {
                          return Card(
                            elevation: 4,
                            margin: EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.school,
                                        color: Colors.blueAccent,
                                        size: 30,
                                      ),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          progress.courseName,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    '${progress.completedLessons} of ${progress.totalLessons} lessons completed',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  CourseProgressIndicator(
                                    progress: progress.completionRate,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
