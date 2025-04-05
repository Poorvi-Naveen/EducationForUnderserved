// import 'package:flutter/material.dart';
// import 'dart:async';
// import 'models.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class ExercisePage extends StatefulWidget {
//   final Chapter chapter; // Receive the chapter object
//   final Course course;
//   final Function onChapterCompleted;

//   const ExercisePage({super.key, required this.chapter, required this.course, required this.onChapterCompleted,});

//   @override
//   ExercisePageState createState() => ExercisePageState();
// }

// class ExercisePageState extends State<ExercisePage> {
//   int _timeLeft = 60;
//   bool _timerRunning = false;
//   String selectedAnswer = "";
//   String _userInput = "";
//   int _currentQuestionIndex = 0;
//   List<Map<String, dynamic>> _questions =;
//   bool _isLoading = true;
//   String _feedbackMessage = "";
//   int _correctAnswersCount = 0; // Counter for correctly answered questions
//   bool _allQuestionsAnsweredCorrectly = false; // Flag for chapter completion
//   bool _exercisesCompleted = false; // Flag to indicate if all exercises have been attempted

//   @override
//   void initState() {
//     super.initState();
//     _fetchExercises(); // Fetch exercises from Firestore
//     _startTimer(); // start timer when page loads
//   }

//   Future<void> _fetchExercises() async {
//     setState(() {
//       _isLoading = true;
//     });
//     try {
//       final snapshot =
//           await FirebaseFirestore.instance
//               .collection('Course')
//               .doc(widget.course.id) // Use widget.course.id
//               .collection('Chapter')
//               .doc(widget.chapter.id)
//               .collection('Exercise')
//               .get();

//       List<Map<String, dynamic>> fetchedQuestions = [];
//       for (var doc in snapshot.docs) {
//         final exercise = Exercise.fromFirestore(
//           doc as DocumentSnapshot<Map<String, dynamic>>,
//         );
//         fetchedQuestions.add({
//           "question": exercise.question,
//           "answer": exercise.answer,
//           "_isMCQ": exercise.isMCQ,
//           "exerciseId": doc.id, // Store the document ID

//         });
//       }
//       setState(() {
//         _questions = fetchedQuestions;
//         _isLoading = false;
//       });
//     } catch (e) {
//       print("Error fetching exercises: $e");
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   // start the timer
//   void _startTimer() {
//     if (mounted) {
//       setState(() {
//         _timerRunning = true;
//       });
//     }

//     const oneSec = Duration(seconds: 1);

//     Timer.periodic(oneSec, (timer) {
//       if (mounted) {
//         setState(() {
//           if (_timeLeft < 1) {
//             timer.cancel();
//             _timerRunning = false;
//           } else {
//             _timeLeft--;
//           }
//         });
//       }
//     });
//   }

//   Future<void> _updateIsCorrect(String exerciseId, bool isCorrect) async {
//     try {
//       await FirebaseFirestore.instance
//           .collection('Course')
//           .doc(widget.course.id) // Corrected to use widget.course.id
//           .collection('Chapter')
//           .doc(widget.chapter.id) // Corrected to use widget.chapter.id
//           .collection('Exercise')
//           .doc(exerciseId)
//           .update({'isCorrect': isCorrect});
//       print("Exercise with ID: $exerciseId updated. isCorrect: $isCorrect");
//     } catch (e) {
//       print("Error updating isCorrect for exercise ID: $exerciseId - $e");
//     }
//   }

//   void _checkAnswer(String? selectedAnswer) {
//     if (_isLoading || _questions.isEmpty) return;

//     final currentQuestion = _questions[_currentQuestionIndex];
//     final isMCQ = currentQuestion["_isMCQ"] as bool;
//     final exerciseId = currentQuestion["exerciseId"] as String;

//     if (isMCQ) {
//       // For MCQ, directly compare the selected answer
//       if (selectedAnswer == currentQuestion["answer"]) {
//         setState(() {
//           _feedbackMessage = "Correct! Go to next question.";
//         });
//         print("Correct Answer!");
//         _updateIsCorrect(exerciseId, true);
//       } else {
//         setState(() {
//           _feedbackMessage = "Incorrect. Try again.";
//         });
//         print("Incorrect Answer!");
//         _updateIsCorrect(exerciseId, false);
//       }
//       return;
//     }

//     // For user input questions, calculate string similarity
//     String answerToCheck = _userInput.trim().toLowerCase();
//     String correctAnswer = currentQuestion["answer"]!.trim().toLowerCase();

//     double similarity = _calculateStringSimilarity(
//       answerToCheck,
//       correctAnswer,
//     );

//     if (similarity > 0.85) {
//       // Threshold for correctness
//       setState(() {
//         _feedbackMessage = "Correct! Go to next question.";
//       });
//       print("Correct Answer!");
//       _updateIsCorrect(exerciseId, true);
//     } else {
//       setState(() {
//         _feedbackMessage = "Incorrect. Try again.";
//       });
//       print("Incorrect Answer!");
//       _updateIsCorrect(exerciseId, false);
//     }
//   }

//   double _calculateStringSimilarity(String str1, String str2) {
//     // Calculate the Levenshtein distance between two strings
//     int levenshteinDistance(String s1, String s2) {
//       List<List<int>> dp = List.generate(
//         s1.length + 1,
//         (_) => List.filled(s2.length + 1, 0),
//       );

//       for (int i = 0; i <= s1.length; i++) {
//         for (int j = 0; j <= s2.length; j++) {
//           if (i == 0) {
//             dp[i][j] = j;
//           } else if (j == 0) {
//             dp[i][j] = i;
//           } else if (s1[i - 1] == s2[j - 1]) {
//             dp[i][j] = dp[i - 1][j - 1];
//           } else {
//             dp[i][j] =
//                 1 +
//                 [
//                   dp[i - 1][j], // Deletion
//                   dp[i][j - 1], // Insertion
//                   dp[i - 1][j - 1], // Substitution
//                 ].reduce((a, b) => a < b ? a : b);
//           }
//         }
//       }

//       return dp[s1.length][s2.length];
//     }

//     int distance = levenshteinDistance(str1, str2);
//     int maxLength = str1.length > str2.length ? str1.length : str2.length;

//     return 1.0 - (distance / maxLength); // Similarity as a percentage
//   }

//   void _goToNextQuestion() {
//     if (_currentQuestionIndex < _questions.length - 1) {
//       setState(() {
//         _currentQuestionIndex++;
//         _timeLeft = 60; // Reset timer for the next question
//         _startTimer();
//         _feedbackMessage = ""; // Reset feedback for the next question
//       });
//     } else {
//       // Handle end of questions (e.g., show a completion message)
//       setState(() {
//         _feedbackMessage =
//             "Congratulations! You have completed all the questions.";
//       });
//     }
//   }

//   void _goToPreviousQuestion() {
//     if (_currentQuestionIndex > 0) {
//       setState(() {
//         _currentQuestionIndex--;
//         _timeLeft = 60; // Reset timer for the previous question
//         _startTimer();
//         _feedbackMessage = ""; // Reset feedback
//       });
//     }
//   }

//   void _skipQuestion() {
//     _goToNextQuestion(); // Skip behaves the same as going to the next question
//   }

//   Color appBarColor = const Color(0xFF1976D2);

//   @override
//   Widget build(BuildContext context) {
//     if (_isLoading) {
//       return Scaffold(
//         appBar: AppBar(
//           leading: IconButton(
//             color: Colors.black,
//             icon: const Icon(Icons.clear),
//             onPressed: () {
//               Navigator.pop(context);
//             },
//           ),
//           backgroundColor: appBarColor,
//           title: Center(
//             child: Text("Exercise", style: TextStyle(color: Colors.white)),
//           ),
//         ),
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }

//     if (_questions.isEmpty) {
//       return Scaffold(
//         appBar: AppBar(
//           leading: IconButton(
//             color: Colors.black,
//             icon: const Icon(Icons.clear),
//             onPressed: () {
//               Navigator.pop(context);
//             },
//           ),
//           backgroundColor: appBarColor,
//           title: Center(
//             child: Text("Exercise", style: TextStyle(color: Colors.white)),
//           ),
//         ),
//         body: Center(child: Text("No exercises available for this chapter.")),
//       );
//     }

//     final currentQuestion = _questions[_currentQuestionIndex];
//     final isMCQ = currentQuestion["_isMCQ"] as bool;

//     return Scaffold(
//       backgroundColor: const Color.fromARGB(
//         255,
//         205,
//         241,
//         238,
//       ), // Light background color
//       appBar: AppBar(
//         leading: IconButton(
//           color: Colors.black,
//           icon: const Icon(Icons.clear),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         backgroundColor: appBarColor, // Light app bar color
//         title: Center(
//           child: Text("Exercise", style: TextStyle(color: Colors.white)),
//         ),
//         bottom: PreferredSize(
//           preferredSize: const Size.fromHeight(4),
//           child: LinearProgressIndicator(
//             value: _timerRunning ? (60 - _timeLeft) / 60 : 0,
//             backgroundColor: Colors.grey.shade300,
//             valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF29B6F6)),
//           ),
//         ),
//       ),
//       body: Stack(
//         children: [
//           SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
//                   child: RichText(
//                     text: TextSpan(
//                       children: [
//                         TextSpan(
//                           text: currentQuestion["question"],
//                           style: const TextStyle(
//                             color: Colors.black,
//                             fontSize: 16,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20), // Add spacing
//                 Container(
//                   padding: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.grey.shade300, width: 1.0),
//                     color: Colors.white,
//                   ),
//                   child:
//                       isMCQ
//                           ? Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               const Text(
//                                 "Answers:",
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               const SizedBox(height: 10),
//                               Column(
//                                 children: [
//                                   ElevatedButton(
//                                     onPressed: () => _checkAnswer("Answer 1"),
//                                     style: ElevatedButton.styleFrom(
//                                       backgroundColor: const Color.fromARGB(
//                                         255,
//                                         129,
//                                         71,
//                                         253,
//                                       ),
//                                       minimumSize: const Size(
//                                         double.infinity,
//                                         50,
//                                       ),
//                                     ),
//                                     child: const Text(
//                                       "Answer 1",
//                                       style: TextStyle(color: Colors.white),
//                                     ),
//                                   ),
//                                   const SizedBox(height: 10),
//                                   ElevatedButton(
//                                     onPressed: () => _checkAnswer("Answer 2"),
//                                     style: ElevatedButton.styleFrom(
//                                       backgroundColor: const Color.fromARGB(
//                                         255,
//                                         129,
//                                         71,
//                                         253,
//                                       ),
//                                       minimumSize: const Size(
//                                         double.infinity,
//                                         50,
//                                       ),
//                                     ),
//                                     child: const Text(
//                                       "Answer 2",
//                                       style: TextStyle(color: Colors.white),
//                                     ),
//                                   ),
//                                   const SizedBox(height: 10),
//                                   ElevatedButton(
//                                     onPressed: () => _checkAnswer("Answer 3"),
//                                     style: ElevatedButton.styleFrom(
//                                       backgroundColor: const Color.fromARGB(
//                                         255,
//                                         129,
//                                         71,
//                                         253,
//                                       ),
//                                       minimumSize: const Size(
//                                         double.infinity,
//                                         50,
//                                       ),
//                                     ),
//                                     child: const Text(
//                                       "Answer 3",
//                                       style: TextStyle(color: Colors.white),
//                                     ),
//                                   ),
//                                   const SizedBox(height: 10),
//                                   ElevatedButton(
//                                     onPressed: () => _checkAnswer("Answer 4"),
//                                     style: ElevatedButton.styleFrom(
//                                       backgroundColor: const Color.fromARGB(
//                                         255,
//                                         129,
//                                         71,
//                                         253,
//                                       ),
//                                       minimumSize: const Size(
//                                         double.infinity,
//                                         50,
//                                       ),
//                                     ),
//                                     child: const Text(
//                                       "Answer 4",
//                                       style: TextStyle(color: Colors.white),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           )
//                           : Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               const Text(
//                                 "Your Answer:",
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               const SizedBox(height: 10),
//                               TextField(
//                                 onChanged: (value) {
//                                   setState(() {
//                                     _userInput = value;
//                                   });
//                                 },
//                                 decoration: InputDecoration(
//                                   hintText: "Type your answer here...",
//                                   border: OutlineInputBorder(),
//                                   filled: true,
//                                   fillColor: Colors.grey.shade100,
//                                 ),
//                               ),
//                               const SizedBox(height: 10),
//                               ElevatedButton(
//                                 onPressed: () => _checkAnswer(null),
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: Colors.teal.shade300,
//                                   minimumSize: const Size(double.infinity, 50),
//                                 ),
//                                 child: const Text("Submit Answer"),
//                               ),
//                             ],
//                           ),
//                 ),
//                 const SizedBox(height: 10), // Add some space for feedback
//                 Center(
//                   child: Text(
//                     _feedbackMessage,
//                     style: TextStyle(
//                       color:
//                           _feedbackMessage.startsWith("Correct")
//                               ? Colors.green
//                               : _feedbackMessage.startsWith("Incorrect")
//                               ? Colors.red
//                               : Colors.black,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: Container(
//               color: Colors.white,
//               padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   ElevatedButton(
//                     onPressed: _goToPreviousQuestion,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.teal.shade300,
//                     ),
//                     child: const Text(
//                       "Previous",
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   ),
//                   ElevatedButton(
//                     onPressed: _skipQuestion,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color.fromARGB(255, 150, 219, 212),
//                     ),
//                     child: const Text(
//                       "Skip",
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   ),
//                   ElevatedButton(
//                     onPressed: _goToNextQuestion,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.teal.shade300,
//                     ),
//                     child: const Text(
//                       "Next",
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'dart:async';
import 'models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ExercisePage extends StatefulWidget {
  final Chapter chapter; // Receive the chapter object
  final Course course;
  final Function onChapterCompleted; // Callback to notify CourseRoadmapPage

  const ExercisePage({
    super.key,
    required this.chapter,
    required this.course,
    required this.onChapterCompleted,
  });

  @override
  ExercisePageState createState() => ExercisePageState();
}

class ExercisePageState extends State<ExercisePage> {
  int _timeLeft = 60;
  bool _timerRunning = false;
  String _selectedAnswer = "";
  String _userInput = "";
  int _currentQuestionIndex = 0;
  List<Map<String, dynamic>> _questions = [];
  bool _isLoading = true;
  String _feedbackMessage = "";
  int _correctAnswersCount = 0; // Counter for correctly answered questions
  bool _allQuestionsAnsweredCorrectly = false; // Flag for chapter completion
  bool _exercisesCompleted =
      false; // Flag to indicate if all exercises have been attempted
  String? _currentUserId;

  @override
  void initState() {
    super.initState();
    _getCurrentUserId();
    _fetchExercises();
    _startTimer();
  }

  void _getCurrentUserId() {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _currentUserId = user.uid;
    } else {
      // Handle the case where the user is not logged in (optional, depending on your app's flow)
      print("User not logged in.");
    }
  }

  Future<void> _fetchExercises() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final snapshot =
          await FirebaseFirestore.instance
              .collection('Course')
              .doc(widget.course.id)
              .collection('Chapter')
              .doc(widget.chapter.id)
              .collection('Exercise')
              .get();

      List<Map<String, dynamic>> fetchedQuestions = [];
      for (var doc in snapshot.docs) {
        final exercise = Exercise.fromFirestore(
          doc as DocumentSnapshot<Map<String, dynamic>>,
        );
        bool isCorrectForUser = false;
        if (_currentUserId != null) {
          final userProgressDoc =
              await doc.reference
                  .collection('UserExerciseProgress')
                  .doc(_currentUserId)
                  .get();
          if (userProgressDoc.exists &&
              userProgressDoc.data()?['isCorrect'] == true) {
            isCorrectForUser = true;
          }
        }
        fetchedQuestions.add({
          "question": exercise.question,
          "answer": exercise.answer,
          "_isMCQ": exercise.isMCQ,
          "exerciseId": doc.id,
          "isCorrect": isCorrectForUser, // Initially all answers are incorrect
        });
      }
      setState(() {
        _questions = fetchedQuestions;
        _isLoading = false;
      });
    } catch (e) {
      print("Error fetching exercises: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _startTimer() {
    if (mounted) {
      setState(() {
        _timerRunning = true;
      });
    }

    const oneSec = Duration(seconds: 1);

    Timer.periodic(oneSec, (timer) {
      if (mounted) {
        setState(() {
          if (_timeLeft < 1) {
            timer.cancel();
            _timerRunning = false;
          } else {
            _timeLeft--;
          }
        });
      }
    });
  }

  Future<void> _updateIsCorrect(String exerciseId, bool isCorrect) async {
    if (_currentUserId == null) {
      print("User ID is null, cannot update progress.");
      return;
    }
    try {
      final exerciseRef = FirebaseFirestore.instance
          .collection('Course')
          .doc(widget.course.id)
          .collection('Chapter')
          .doc(widget.chapter.id)
          .collection('Exercise')
          .doc(exerciseId);

      await exerciseRef
          .collection('UserExerciseProgress')
          .doc(_currentUserId)
          .set(
            {'isCorrect': isCorrect},
            SetOptions(
              merge: true,
            ), // Use merge to update if the document exists
          );
      print(
        "User ${_currentUserId} progress for Exercise with ID: $exerciseId updated. isCorrect: $isCorrect",
      );
    } catch (e) {
      print(
        "Error updating isCorrect for user ${_currentUserId} and exercise ID: $exerciseId - $e",
      );
    }
  }

  void _checkAnswer(String? selectedAnswer) {
    if (_isLoading ||
        _questions.isEmpty ||
        _exercisesCompleted ||
        _currentUserId == null)
      return;

    final currentQuestion = _questions[_currentQuestionIndex];
    final isMCQ = currentQuestion["_isMCQ"] as bool;
    final exerciseId = currentQuestion["exerciseId"] as String;
    bool isCorrect = false;

    if (isMCQ) {
      if (selectedAnswer == currentQuestion["answer"]) {
        _feedbackMessage = "Correct! Go to next question.";
        print("Correct Answer!");
        isCorrect = true;
      } else {
        _feedbackMessage = "Incorrect. Try again.";
        print("Incorrect Answer!");
        isCorrect = false;
      }
    } else {
      String answerToCheck = _userInput.trim().toLowerCase();
      String correctAnswer = currentQuestion["answer"]!.trim().toLowerCase();

      double similarity = _calculateStringSimilarity(
        answerToCheck,
        correctAnswer,
      );

      if (similarity > 0.85) {
        _feedbackMessage = "Correct! Go to next question.";
        print("Correct Answer!");
        isCorrect = true;
      } else {
        _feedbackMessage = "Incorrect. Try again.";
        print("Incorrect Answer!");
        isCorrect = false;
      }
    }

    setState(() {
      _feedbackMessage = _feedbackMessage;
      if (isCorrect) {
        // Update the local question list with the correctness status
        _questions[_currentQuestionIndex]["isCorrect"] = true;
      }
    });
    _updateIsCorrect(exerciseId, isCorrect);
  }

  double _calculateStringSimilarity(String str1, String str2) {
    int levenshteinDistance(String s1, String s2) {
      List<List<int>> dp = List.generate(
        s1.length + 1,
        (_) => List.filled(s2.length + 1, 0),
      );

      for (int i = 0; i <= s1.length; i++) {
        for (int j = 0; j <= s2.length; j++) {
          if (i == 0) {
            dp[i][j] = j;
          } else if (j == 0) {
            dp[i][j] = i;
          } else if (s1[i - 1] == s2[j - 1]) {
            dp[i][j] = dp[i - 1][j - 1];
          } else {
            dp[i][j] =
                1 +
                [
                  dp[i - 1][j], // Deletion
                  dp[i][j - 1], // Insertion
                  dp[i - 1][j - 1], // Substitution
                ].reduce((a, b) => a < b ? a : b);
          }
        }
      }
      return dp[s1.length][s2.length];
    }

    int distance = levenshteinDistance(str1, str2);
    int maxLength = str1.length > str2.length ? str1.length : str2.length;

    return 1.0 - (distance / maxLength);
  }

  void _goToNextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _timeLeft = 60;
        _startTimer();
        _feedbackMessage = "";
        _userInput = "";
      });
    } else {
      // Check if all questions have been answered correctly
      bool allCorrect = _questions.every((q) => q["isCorrect"] == true);
      setState(() {
        _exercisesCompleted = true;
        _allQuestionsAnsweredCorrectly = allCorrect;
        if (allCorrect) {
          _feedbackMessage =
              "Congratulations! You have completed this chapter correctly.";
          widget.onChapterCompleted(widget.chapter.id); // Notify completion
        } else {
          _feedbackMessage =
              "You have completed the exercises, but not all answers were correct. Please review.";
        }
      });
    }
  }

  void _goToPreviousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
        _timeLeft = 60;
        _startTimer();
        _feedbackMessage = "";
      });
    }
  }

  void _skipQuestion() {
    _goToNextQuestion();
  }

  void _finishChapter() {
    Navigator.pop(context); // Go back to CourseRoadmapPage
  }

  Color appBarColor = const Color(0xFF1976D2);

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            color: Colors.black,
            icon: const Icon(Icons.clear),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: appBarColor,
          title: Center(
            child: Text("Exercise", style: TextStyle(color: Colors.white)),
          ),
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            color: Colors.black,
            icon: const Icon(Icons.clear),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: appBarColor,
          title: Center(
            child: Text("Exercise", style: TextStyle(color: Colors.white)),
          ),
        ),
        body: Center(child: Text("No exercises available for this chapter.")),
      );
    }

    final currentQuestion = _questions[_currentQuestionIndex];
    final isMCQ = currentQuestion["_isMCQ"] as bool;
    final questionNumber = _currentQuestionIndex + 1;
    final totalQuestions = _questions.length;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 205, 241, 238),
      appBar: AppBar(
        leading: IconButton(
          color: Colors.black,
          icon: const Icon(Icons.clear),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: appBarColor,
        title: Center(
          child: Text("Exercise", style: TextStyle(color: Colors.white)),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(
            value: _timerRunning ? (60 - _timeLeft) / 60 : 0,
            backgroundColor: Colors.grey.shade300,
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF29B6F6)),
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Question $questionNumber/$totalQuestions: ",
                          style: const TextStyle(
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        TextSpan(
                          text: currentQuestion["question"],
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300, width: 1.0),
                    color: Colors.white,
                  ),
                  child:
                      isMCQ
                          ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Answers:",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Column(
                                children: [
                                  ElevatedButton(
                                    onPressed: () => _checkAnswer("Answer 1"),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(
                                        255,
                                        129,
                                        71,
                                        253,
                                      ),
                                      minimumSize: const Size(
                                        double.infinity,
                                        50,
                                      ),
                                    ),
                                    child: const Text(
                                      "Answer 1",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  ElevatedButton(
                                    onPressed: () => _checkAnswer("Answer 2"),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(
                                        255,
                                        129,
                                        71,
                                        253,
                                      ),
                                      minimumSize: const Size(
                                        double.infinity,
                                        50,
                                      ),
                                    ),
                                    child: const Text(
                                      "Answer 2",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  ElevatedButton(
                                    onPressed: () => _checkAnswer("Answer 3"),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(
                                        255,
                                        129,
                                        71,
                                        253,
                                      ),
                                      minimumSize: const Size(
                                        double.infinity,
                                        50,
                                      ),
                                    ),
                                    child: const Text(
                                      "Answer 3",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  ElevatedButton(
                                    onPressed: () => _checkAnswer("Answer 4"),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(
                                        255,
                                        129,
                                        71,
                                        253,
                                      ),
                                      minimumSize: const Size(
                                        double.infinity,
                                        50,
                                      ),
                                    ),
                                    child: const Text(
                                      "Answer 4",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                          : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Your Answer:",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              TextField(
                                onChanged: (value) {
                                  setState(() {
                                    _userInput = value;
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: "Type your answer here...",
                                  border: OutlineInputBorder(),
                                  filled: true,
                                  fillColor: Colors.grey.shade100,
                                ),
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () => _checkAnswer(null),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.teal.shade300,
                                  minimumSize: const Size(double.infinity, 50),
                                ),
                                child: const Text("Submit Answer"),
                              ),
                            ],
                          ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    _feedbackMessage,
                    style: TextStyle(
                      color:
                          _feedbackMessage.startsWith("Correct")
                              ? Colors.green
                              : _feedbackMessage.startsWith("Incorrect")
                              ? Colors.red
                              : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (_exercisesCompleted)
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Center(
                      child: Column(
                        children: [
                          Text(
                            _allQuestionsAnsweredCorrectly
                                ? "Congratulations! You have completed this chapter correctly."
                                : "You have completed the exercises, but not all answers were correct. Please review.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 10),
                          ElevatedButton(
                            onPressed:
                                _allQuestionsAnsweredCorrectly
                                    ? _finishChapter
                                    : null, // Disable button if not all correct
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  _allQuestionsAnsweredCorrectly
                                      ? Colors.green.shade400
                                      : Colors.grey,
                            ),
                            child: Text(
                              "Continue to Next Chapter",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: _goToPreviousQuestion,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal.shade300,
                    ),
                    child: const Text(
                      "Previous",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _skipQuestion,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 150, 219, 212),
                    ),
                    child: const Text(
                      "Skip",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _goToNextQuestion,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal.shade300,
                    ),
                    child: const Text(
                      "Next",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
