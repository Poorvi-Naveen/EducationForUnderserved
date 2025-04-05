// import 'package:flutter/material.dart';
// import 'package:animated_text_kit/animated_text_kit.dart';
// import 'exercise_page.dart';
// import 'models.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'chapter_info.dart';

// void main() {
//   runApp(AimzyApp());
// }

// class AimzyApp extends StatelessWidget {
//   const AimzyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Aimzy',
//       theme: ThemeData(
//         primarySwatch: Colors.purple,
//         scaffoldBackgroundColor: Colors.white,
//         cardTheme: CardTheme(
//           elevation: 3,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(15),
//           ),
//         ),
//         elevatedButtonTheme: ElevatedButtonThemeData(
//           style: ElevatedButton.styleFrom(
//             padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(20),
//             ),
//           ),
//         ),
//       ),
//       home: CourseSelectionPage(),
//     );
//   }
// }

// class CourseSelectionPage extends StatefulWidget {
//   const CourseSelectionPage({super.key});

//   @override
//   CourseSelectionPageState createState() => CourseSelectionPageState();
// }

// class CourseSelectionPageState extends State<CourseSelectionPage> {
//   List<Course> courses = [];
//   bool _isLoading = true;
//   final String? _userId = FirebaseAuth.instance.currentUser?.uid;

//   @override
//   void initState() {
//     super.initState();
//     // _fetchJoinedCourses();
//   }

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     _fetchJoinedCourses(); // Fetch joined courses when dependencies change (page becomes visible)
//   }

//   Future<void> _fetchJoinedCourses() async {
//     print("DEBUG: _fetchJoinedCourses() called");
//     if (_userId == null) {
//       print("DEBUG: _userId is null");
//       setState(() {
//         _isLoading = false;
//         courses = [];
//       });
//       return;
//     }
//     print("DEBUG: _userId is: $_userId");

//     try {
//       // Fetch the document from 'userCourses' for the current user
//       DocumentSnapshot userCoursesSnapshot =
//           await FirebaseFirestore.instance
//               .collection('userCourses')
//               .doc(_userId)
//               .get();

//       print(
//         "DEBUG: userCoursesSnapshot exists: ${userCoursesSnapshot.exists}",
//       ); // Add this line
//       print("DEBUG: userCoursesSnapshot data: ${userCoursesSnapshot.data()}");

//       if (userCoursesSnapshot.exists && userCoursesSnapshot.data() != null) {
//         // Get the list of joined course IDs
//         List<String> joinedCourseIds = List<String>.from(
//           (userCoursesSnapshot.data()
//                   as Map<String, dynamic>?)?['joinedCourses'] ??
//               [],
//         );

//         print("DEBUG: joinedCourseIds: $joinedCourseIds");

//         if (joinedCourseIds.isNotEmpty) {
//           // Fetch only the courses whose IDs are in the joinedCourseIds list
//           QuerySnapshot snapshot =
//               await FirebaseFirestore.instance
//                   .collection('Course')
//                   .where(FieldPath.documentId, whereIn: joinedCourseIds)
//                   .get();

//           print("DEBUG: Number of courses fetched: ${snapshot.docs.length}");

//           setState(() {
//             courses =
//                 snapshot.docs
//                     .map(
//                       (doc) => Course.fromFirestore(
//                         doc as DocumentSnapshot<Map<String, dynamic>>,
//                       ),
//                     )
//                     .toList();
//             _isLoading = false;
//           });
//         } else {
//           // User has no joined courses
//           setState(() {
//             courses = [];
//             _isLoading = false;
//           });
//         }
//       } else {
//         // User document in 'userCourses' doesn't exist (no joined courses yet)
//         setState(() {
//           courses = [];
//           _isLoading = false;
//         });
//       }
//     } catch (e) {
//       print("Error fetching joined courses: $e");
//       print("DEBUG: Error fetching joined courses: $e");
//       setState(() {
//         _isLoading = false;
//         courses = [];
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     print("DEBUG: CourseSelectionPage build method called");
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Colors.purple.shade800, Colors.blue.shade800],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               AnimatedTextKit(
//                 animatedTexts: [
//                   TypewriterAnimatedText(
//                     'Aimzy Learning',
//                     textStyle: TextStyle(
//                       fontSize: 36.0,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                     speed: const Duration(milliseconds: 150),
//                   ),
//                 ],
//                 totalRepeatCount: 1,
//                 pause: const Duration(milliseconds: 1000),
//                 displayFullTextOnTap: true,
//                 stopPauseOnTap: true,
//               ),
//               SizedBox(height: 40),
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: courses.length,
//                   itemBuilder: (context, index) {
//                     return Card(
//                       margin: EdgeInsets.symmetric(vertical: 8),
//                       elevation: 5,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(15),
//                       ),
//                       child: ListTile(
//                         contentPadding: EdgeInsets.symmetric(
//                           horizontal: 20,
//                           vertical: 10,
//                         ),
//                         title: Text(
//                           courses[index].title,
//                           style: TextStyle(
//                             fontWeight: FontWeight.w600,
//                             fontSize: 16,
//                           ),
//                         ),
//                         subtitle: Padding(
//                           padding: const EdgeInsets.only(top: 5.0),
//                           child: Text(courses[index].description),
//                         ),
//                         trailing: Icon(Icons.arrow_forward_ios),
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder:
//                                   (context) =>
//                                       CourseRoadmapPage(course: courses[index]),
//                             ),
//                           );
//                         },
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class CourseProgressIndicator extends StatelessWidget {
//   final double progress; // 0.0 to 1.0
//   final Color progressColor;
//   final Color backgroundColor;
//   final double height;

//   const CourseProgressIndicator({
//     super.key,
//     required this.progress,
//     this.progressColor = Colors.purple,
//     this.backgroundColor = Colors.grey,
//     this.height = 12.0,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: height,
//       decoration: BoxDecoration(
//         // ignore: deprecated_member_use
//         color: backgroundColor.withOpacity(0.3),
//         borderRadius: BorderRadius.circular(height / 2),
//       ),
//       child: Stack(
//         children: [
//           FractionallySizedBox(
//             widthFactor: progress.clamp(0.0, 1.0),
//             child: Container(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   // ignore: deprecated_member_use
//                   colors: [progressColor, progressColor.withOpacity(0.7)],
//                   begin: Alignment.centerLeft,
//                   end: Alignment.centerRight,
//                 ),
//                 borderRadius: BorderRadius.circular(height / 2),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class CourseRoadmapPage extends StatefulWidget {
//   final Course course;

//   const CourseRoadmapPage({super.key, required this.course});

//   @override
//   // ignore: library_private_types_in_public_api
//   _CourseRoadmapPageState createState() => _CourseRoadmapPageState();
// }

// class _CourseRoadmapPageState extends State<CourseRoadmapPage>
//     with SingleTickerProviderStateMixin {
//   int currentChapterIndex = 0;
//   late AnimationController _animationController;
//   late Animation<double> _animation;
//   List<Chapter> _chapters = [];
//   bool _isLoadingChapters = true;

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       duration: const Duration(milliseconds: 500),
//       vsync: this,
//     );
//     _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
//     _fetchChapters();
//     _animationController.forward();
//   }

//   Future<void> _fetchChapters() async {
//     setState(() {
//       _isLoadingChapters = true;
//     });
//     try {
//       final chaptersSnapshot =
//           await widget.course.reference
//               .collection('Chapter')
//               .orderBy(
//                 'order',
//               ) // Assuming you have an 'order' field for chapters
//               .get();

//       setState(() {
//         _chapters =
//             chaptersSnapshot.docs.map((doc) {
//               return Chapter.fromFirestore(
//                 doc as DocumentSnapshot<Map<String, dynamic>>,
//               );
//             }).toList();
//         _isLoadingChapters = false;
//       });
//     } catch (e) {
//       print("Error fetching chapters: $e");
//       setState(() {
//         _isLoadingChapters = false;
//       });
//     }
//   }

//   void completeChapter() {
//     setState(() {
//       if (currentChapterIndex < _chapters.length) {
//         _chapters[currentChapterIndex].isCompleted = true;
//         if (currentChapterIndex < _chapters.length - 1) {
//           currentChapterIndex++;
//           _animationController.reset();
//           _animationController.forward();
//         }
//       }
//     });
//   }

//   void startLesson() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder:
//             (context) => ExercisePage(
//               chapter: _chapters[currentChapterIndex],
//               course: widget.course,
//             ), // Pass widget.course
//       ),
//     );
//   }

//   double get courseProgress {
//     if (_chapters.isEmpty) return 0.0;
//     int completedChapters =
//         _chapters.where((chapter) => chapter.isCompleted).length;
//     return completedChapters / _chapters.length;
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_isLoadingChapters) {
//       return Scaffold(
//         appBar: AppBar(title: Text(widget.course.title)),
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }

//     if (_chapters.isEmpty) {
//       return Scaffold(
//         appBar: AppBar(title: Text(widget.course.title)),
//         body: Center(child: Text('No chapters available for this course')),
//       );
//     }

//     Chapter currentChapter = _chapters[currentChapterIndex];

//     return Scaffold(
//       appBar: AppBar(title: Text(widget.course.title), elevation: 0),
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Colors.purple.shade50, Colors.blue.shade50],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Card(
//                 elevation: 4,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             'Progress',
//                             style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                           Text(
//                             '${(courseProgress * 100).toInt()}%',
//                             style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.purple.shade800,
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 10),
//                       CourseProgressIndicator(
//                         progress: courseProgress,
//                         progressColor: Colors.purple.shade700,
//                         height: 15,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               SizedBox(height: 20), // Added some spacing
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Expanded(
//                     // Wrap the Text widget with Expanded
//                     child: Text(
//                       'Chapter information :Tap the icon to understand and know more about the chapters ',
//                       style: TextStyle(fontSize: 14),
//                       textAlign:
//                           TextAlign
//                               .center, // Optional: Center the text within the expanded space
//                     ),
//                   ),
//                   IconButton(
//                     icon: Icon(Icons.info_outlined),
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder:
//                               (context) =>
//                                   RatioProportionPage(course: widget.course),
//                         ),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//               SizedBox(height: 20),
//               Expanded(
//                 child: Card(
//                   elevation: 4,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: SingleChildScrollView(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Chapter ${currentChapterIndex + 1}: ${currentChapter.title}',
//                             style: TextStyle(
//                               fontSize: 22,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.purple.shade800,
//                             ),
//                           ),
//                           Divider(thickness: 1),
//                           SizedBox(height: 10),
//                           Text(
//                             currentChapter.introduction,
//                             style: TextStyle(fontSize: 16),
//                           ),
//                           SizedBox(height: 20),
//                           Text(
//                             'Exercises:',
//                             style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.w600,
//                               color: Colors.blue.shade800,
//                             ),
//                           ),
//                           SizedBox(height: 30),
//                           Center(
//                             child: ElevatedButton(
//                               onPressed:
//                                   currentChapterIndex ==
//                                           _chapters.indexOf(currentChapter)
//                                       ? startLesson
//                                       : null,
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.purple.shade700,
//                               ),
//                               child: Text(
//                                 'Start Lesson',
//                                 style: TextStyle(fontSize: 16),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 20),
//               Text(
//                 'Course Roadmap:',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.purple.shade800,
//                 ),
//               ),
//               SizedBox(height: 10),
//               SizedBox(
//                 height: 150,
//                 child: ListView.builder(
//                   itemCount: _chapters.length,
//                   itemBuilder: (context, index) {
//                     Chapter chapter = _chapters[index];
//                     IconData iconData;
//                     Color iconColor;
//                     String status;

//                     if (chapter.isCompleted) {
//                       iconData = Icons.check_circle;
//                       iconColor = Colors.green;
//                       status = 'Completed';
//                     } else if (index == currentChapterIndex) {
//                       iconData = Icons.play_circle_fill;
//                       iconColor = Colors.blue;
//                       status = 'In Progress';
//                     } else {
//                       iconData = Icons.lock_outline;
//                       iconColor = Colors.grey;
//                       status = 'Locked';
//                     }

//                     return Card(
//                       elevation: 2,
//                       margin: EdgeInsets.symmetric(vertical: 4),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: FadeTransition(
//                         opacity:
//                             index == currentChapterIndex
//                                 ? _animation
//                                 : const AlwaysStoppedAnimation(1.0),
//                         child: ListTile(
//                           leading: Icon(iconData, color: iconColor),
//                           title: Text(
//                             'Chapter ${index + 1}: ${chapter.title}',
//                             style: TextStyle(fontWeight: FontWeight.w500),
//                           ),
//                           trailing: Text(
//                             status,
//                             style: TextStyle(
//                               color: iconColor,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }
// }

import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'exercise_page.dart';
import 'models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chapter_info.dart';

void main() {
  runApp(AimzyApp());
}

class AimzyApp extends StatelessWidget {
  const AimzyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aimzy',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        scaffoldBackgroundColor: Colors.white,
        cardTheme: CardTheme(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
      home: CourseSelectionPage(),
    );
  }
}

class CourseSelectionPage extends StatefulWidget {
  const CourseSelectionPage({super.key});

  @override
  CourseSelectionPageState createState() => CourseSelectionPageState();
}

class CourseSelectionPageState extends State<CourseSelectionPage> {
  List<Course> courses = [];
  bool _isLoading = true;
  final String? _userId = FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {
    super.initState();
    // _fetchJoinedCourses();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchJoinedCourses(); // Fetch joined courses when dependencies change (page becomes visible)
  }

  Future<void> _fetchJoinedCourses() async {
    print("DEBUG: _fetchJoinedCourses() called");
    if (_userId == null) {
      print("DEBUG: _userId is null");
      setState(() {
        _isLoading = false;
        courses = [];
      });
      return;
    }
    print("DEBUG: _userId is: $_userId");

    try {
      // Fetch the document from 'userCourses' for the current user
      DocumentSnapshot userCoursesSnapshot =
          await FirebaseFirestore.instance
              .collection('userCourses')
              .doc(_userId)
              .get();

      print(
        "DEBUG: userCoursesSnapshot exists: ${userCoursesSnapshot.exists}",
      ); // Add this line
      print("DEBUG: userCoursesSnapshot data: ${userCoursesSnapshot.data()}");

      if (userCoursesSnapshot.exists && userCoursesSnapshot.data() != null) {
        // Get the list of joined course IDs
        List<String> joinedCourseIds = List<String>.from(
          (userCoursesSnapshot.data()
                  as Map<String, dynamic>?)?['joinedCourses'] ??
              [],
        );

        print("DEBUG: joinedCourseIds: $joinedCourseIds");

        if (joinedCourseIds.isNotEmpty) {
          // Fetch only the courses whose IDs are in the joinedCourseIds list
          QuerySnapshot snapshot =
              await FirebaseFirestore.instance
                  .collection('Course')
                  .where(FieldPath.documentId, whereIn: joinedCourseIds)
                  .get();

          print("DEBUG: Number of courses fetched: ${snapshot.docs.length}");

          setState(() {
            courses =
                snapshot.docs
                    .map(
                      (doc) => Course.fromFirestore(
                        doc as DocumentSnapshot<Map<String, dynamic>>,
                      ),
                    )
                    .toList();
            _isLoading = false;
          });
        } else {
          // User has no joined courses
          setState(() {
            courses = [];
            _isLoading = false;
          });
        }
      } else {
        // User document in 'userCourses' doesn't exist (no joined courses yet)
        setState(() {
          courses = [];
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching joined courses: $e");
      print("DEBUG: Error fetching joined courses: $e");
      setState(() {
        _isLoading = false;
        courses = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print("DEBUG: CourseSelectionPage build method called");
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple.shade800, Colors.blue.shade800],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText(
                    'Aimzy Learning',
                    textStyle: TextStyle(
                      fontSize: 36.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    speed: const Duration(milliseconds: 150),
                  ),
                ],
                totalRepeatCount: 1,
                pause: const Duration(milliseconds: 1000),
                displayFullTextOnTap: true,
                stopPauseOnTap: true,
              ),
              SizedBox(height: 40),
              Expanded(
                child: ListView.builder(
                  itemCount: courses.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        title: Text(
                          courses[index].title,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Text(courses[index].description),
                        ),
                        trailing: Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      CourseRoadmapPage(course: courses[index]),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CourseProgressIndicator extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final Color progressColor;
  final Color backgroundColor;
  final double height;

  const CourseProgressIndicator({
    super.key,
    required this.progress,
    this.progressColor = Colors.purple,
    this.backgroundColor = Colors.grey,
    this.height = 12.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor.withOpacity(0.3),
        borderRadius: BorderRadius.circular(height / 2),
      ),
      child: Stack(
        children: [
          FractionallySizedBox(
            widthFactor: progress.clamp(0.0, 1.0),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [progressColor, progressColor.withOpacity(0.7)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(height / 2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CourseRoadmapPage extends StatefulWidget {
  final Course course;

  const CourseRoadmapPage({super.key, required this.course});

  @override
  _CourseRoadmapPageState createState() => _CourseRoadmapPageState();
}

class _CourseRoadmapPageState extends State<CourseRoadmapPage>
    with SingleTickerProviderStateMixin {
  int currentChapterIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _animation;
  List<Chapter> _chapters = [];
  bool _isLoadingChapters = true;
  final String? _userId = FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
    _fetchChapters();
    _animationController.forward();
  }

  Future<void> _fetchChapters() async {
    setState(() {
      _isLoadingChapters = true;
    });
    try {
      final chaptersSnapshot =
          await widget.course.reference
              .collection('Chapter')
              .orderBy(
                'order',
              ) // Assuming you have an 'order' field for chapters
              .get();

      List<Chapter> fetchedChapters = [];
      for (var doc in chaptersSnapshot.docs) {
        final chapter = Chapter.fromFirestore(
          doc as DocumentSnapshot<Map<String, dynamic>>,
        );
        bool isCompletedByUser = false;
        if (_userId != null) {
          final userProgressDoc =
              await doc.reference
                  .collection('UserChapterProgress')
                  .doc(_userId)
                  .get();
          if (userProgressDoc.exists) {
            isCompletedByUser = true;
          }
        }
        fetchedChapters.add(chapter.copyWith(isCompleted: isCompletedByUser));
      }

      setState(() {
        _chapters = fetchedChapters;
        _isLoadingChapters = false;
      });
    } catch (e) {
      print("Error fetching chapters: $e");
      setState(() {
        _isLoadingChapters = false;
      });
    }
  }

  void _markChapterCompleted(String chapterId) async {
    if (_userId == null) return;
    try {
      final chapterRef = widget.course.reference
          .collection('Chapter')
          .doc(chapterId);
      await chapterRef
          .collection('UserChapterProgress')
          .doc(_userId)
          .set({}); // Just create a document to mark as completed

      final index = _chapters.indexWhere((ch) => ch.id == chapterId);
      if (index != -1) {
        setState(() {
          _chapters[index].isCompleted = true;
          // Automatically move to the next chapter if there is one
          if (index < _chapters.length - 1 &&
              !_chapters[index + 1].isCompleted) {
            currentChapterIndex = index + 1;
            _animationController.reset();
            _animationController.forward();
          }
        });
      }
      print(
        'Chapter $chapterId marked as completed for user $_userId in Firestore.',
      );
    } catch (e) {
      print('Error updating chapter completion status in Firestore: $e');
    }
  }

  void startLesson() {
    if (_chapters.isEmpty) return;

    // Check if the previous chapter is completed (if not the first chapter)
    if (currentChapterIndex > 0 &&
        !_chapters[currentChapterIndex - 1].isCompleted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please complete the previous chapter first.'),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => ExercisePage(
              chapter: _chapters[currentChapterIndex],
              course: widget.course,
              onChapterCompleted:
                  _markChapterCompleted, // Pass the callback here
            ),
      ),
    );
  }

  double get courseProgress {
    if (_chapters.isEmpty) return 0.0;
    int completedChapters =
        _chapters.where((chapter) => chapter.isCompleted).length;
    return completedChapters / _chapters.length;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingChapters) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.course.title)),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_chapters.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.course.title)),
        body: Center(child: Text('No chapters available for this course')),
      );
    }

    Chapter currentChapter = _chapters[currentChapterIndex];
    bool isCurrentChapterAccessible =
        currentChapterIndex == 0 ||
        _chapters[currentChapterIndex - 1].isCompleted;

    return Scaffold(
      appBar: AppBar(title: Text(widget.course.title), elevation: 0),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple.shade50, Colors.blue.shade50],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Progress',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '${(courseProgress * 100).toInt()}%',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.purple.shade800,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      CourseProgressIndicator(
                        progress: courseProgress,
                        progressColor: Colors.purple.shade700,
                        height: 15,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20), // Added some spacing
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      'Chapter information :Tap the icon to understand and know more about the chapters ',
                      style: TextStyle(fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.info_outlined),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  RatioProportionPage(course: widget.course),
                        ),
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
              Expanded(
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Chapter ${currentChapterIndex + 1}: ${currentChapter.title}',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.purple.shade800,
                            ),
                          ),
                          Divider(thickness: 1),
                          SizedBox(height: 10),
                          Text(
                            currentChapter.introduction,
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Exercises:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue.shade800,
                            ),
                          ),
                          SizedBox(height: 30),
                          Center(
                            child: ElevatedButton(
                              onPressed:
                                  isCurrentChapterAccessible
                                      ? startLesson
                                      : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    isCurrentChapterAccessible
                                        ? Colors.purple.shade700
                                        : Colors.grey,
                              ),
                              child: Text(
                                'Start Lesson',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Course Roadmap:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.purple.shade800,
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                height: 150,
                child: ListView.builder(
                  itemCount: _chapters.length,
                  itemBuilder: (context, index) {
                    Chapter chapter = _chapters[index];
                    IconData iconData;
                    Color iconColor;
                    String status;

                    if (chapter.isCompleted) {
                      iconData = Icons.check_circle;
                      iconColor = Colors.green;
                      status = 'Completed';
                    } else if (index == currentChapterIndex) {
                      iconData = Icons.play_circle_fill;
                      iconColor = Colors.blue;
                      status = 'In Progress';
                    } else {
                      iconData = Icons.lock_outline;
                      iconColor = Colors.grey;
                      status = 'Locked';
                    }

                    return Card(
                      elevation: 2,
                      margin: EdgeInsets.symmetric(vertical: 4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: FadeTransition(
                        opacity:
                            index == currentChapterIndex
                                ? _animation
                                : const AlwaysStoppedAnimation(1.0),
                        child: ListTile(
                          leading: Icon(iconData, color: iconColor),
                          title: Text(
                            'Chapter ${index + 1}: ${chapter.title}',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          trailing: Text(
                            status,
                            style: TextStyle(
                              color: iconColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

// Helper extension to create a copy of Chapter with updated fields
extension ChapterCopyWith on Chapter {
  Chapter copyWith({
    String? id,
    String? title,
    String? introduction,
    bool? isCompleted,
    int? order,
  }) {
    return Chapter(
      id: id ?? this.id,
      title: title ?? this.title,
      introduction: introduction ?? this.introduction,
      isCompleted: isCompleted ?? this.isCompleted,
      order: order ?? this.order,
    );
  }
}
