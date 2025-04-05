// // ignore_for_file: use_build_context_synchronously
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:image_picker/image_picker.dart';
// import 'package:file_picker/file_picker.dart';
// import 'dart:io';
// import 'package:path/path.dart' as path;
// import 'package:uuid/uuid.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_markdown/flutter_markdown.dart'; // Import the flutter_markdown package

// String? currentSessionId;
// final uuid = Uuid();
// Map<String, String> _chatSessions = {};

// class ChatScreen extends StatefulWidget {
//   const ChatScreen({super.key});

//   @override
//   ChatScreenState createState() => ChatScreenState();
// }

// class ChatScreenState extends State<ChatScreen> {
//   final TextEditingController _controller = TextEditingController();
//   //List<Map<String, dynamic>> _messages =;
//   List<Map<String, String>> _messages = [];
//   bool _isLoadingSessions = false;

//   @override
//   void initState() {
//     super.initState();
//     _loadInitialSession();
//   }

//   // Placeholder function to get the current user's ID
//   String? getCurrentUserId() {
//     // In a real application, you would get this from your authentication system
//     // For example, using Firebase Auth: FirebaseAuth.instance.currentUser?.uid;
//     return FirebaseAuth
//         .instance
//         .currentUser
//         ?.uid; // Replace with actual user ID retrieval
//   }

//   Future<void> _loadInitialSession() async {
//     setState(() {
//       _isLoadingSessions = true;
//       print("_loadInitialSession: Setting _isLoadingSessions to true"); // Debug
//     });
//     final prefs = await SharedPreferences.getInstance();
//     currentSessionId = prefs.getString('currentSessionId');

//     await fetchChatSessions();
//     if (currentSessionId != null) {
//       await loadChatSession(currentSessionId!);
//     }
//     setState(() {
//       _isLoadingSessions = false;
//       print(
//         "_loadInitialSession: Setting _isLoadingSessions to false",
//       ); // Debug
//     });
//   }

//   Future<void> fetchChatSessions() async {
//     final userId = getCurrentUserId();
//     if (userId == null) {
//       print("Error: User not authenticated.");
//       return;
//     }
//     setState(() {
//       _isLoadingSessions = true;
//       print("fetchChatSessions: Setting _isLoadingSessions to true"); // Debug
//     });

//     final querySnapshot =
//         await FirebaseFirestore.instance
//             .collection("users")
//             .doc(userId)
//             .collection("user_chats")
//             .orderBy("timestamp", descending: true)
//             .get();

//     Map<String, String> sessionMap = {};
//     Map<String, List<QueryDocumentSnapshot>> groupedSessions = {};

//     for (var doc in querySnapshot.docs) {
//       String sessionId = doc["sessionId"] ?? "";
//       if (!groupedSessions.containsKey(sessionId)) {
//         groupedSessions[sessionId] = [];
//       }
//       groupedSessions[sessionId]!.add(doc);
//     }

//     for (var sessionId in groupedSessions.keys) {
//       try {
//         var firstQuestion = groupedSessions[sessionId]!.firstWhere(
//           (doc) => doc["role"] == "user",
//           orElse: () => groupedSessions[sessionId]![0],
//         );
//         sessionMap[sessionId] = firstQuestion["text"] ?? "No Question Found";
//       } catch (e) {
//         print("Error processing session $sessionId: $e");
//         sessionMap[sessionId] = "Error Loading Session";
//       }
//     }

//     if (mounted) {
//       setState(() {
//         _chatSessions = sessionMap;
//         print("fetchChatSessions: Setting _chatSessions: $_chatSessions");
//       });
//       print(
//         "Fetched chat sessions for user $userId: $_chatSessions",
//       ); // Debug print
//     }
//     setState(() {
//       _isLoadingSessions = false;
//       print("fetchChatSessions: Setting _isLoadingSessions to false"); // Debug
//     });
//   }

//   File? _selectedImage;
//   File? _selectedDocument;

//   final String apiKey =
//       'AIzaSyDO8uuSRqnt6i8DDE5AfTeOLEniZNObV54'; // Replace with your actual API key
//   final String apiUrl =
//       'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent';

//   // Define theme colors based on the image, including gradient colors
//   Color gradientColorTop = const Color(
//     0xFF308ca5,
//   ); // Top color of the gradient (darker blue)
//   Color gradientColorBottom = const Color(
//     0xFF083774,
//   ); // Bottom color of the gradient (lighter blue)
//   Color appBarColor = const Color(
//     0xFF1976D2,
//   ); // Slightly lighter blue for AppBar
//   Color messageBubbleUser = const Color(
//     0xFF29B6F6,
//   ); // Light blue for user messages
//   Color messageBubbleBot = const Color(
//     0xFFE0E0E0,
//   ); // Light grey for bot messages
//   Color textColorPrimary =
//       Colors.white; // White for primary text on blue backgrounds
//   Color textColorSecondary = Colors.black;

//   get parts => null; // Black for secondary text on light backgrounds

//   Future<void> pickImage() async {
//     final pickedFile = await ImagePicker().pickImage(
//       source: ImageSource.gallery,
//     );
//     if (pickedFile != null) {
//       setState(() {
//         _selectedImage = File(pickedFile.path);
//         _selectedDocument = null; // Clear any previously selected document
//         _buildFilePreview();
//       });
//     }
//   }

//   Future<void> pickDocument() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles();
//     if (result != null) {
//       setState(() {
//         _selectedDocument = File(result.files.single.path!);
//         _selectedImage = null; // Clear any previously selected image
//         _buildFilePreview();
//       });
//     }
//   }

//   Future<void> sendMessage() async {
//     String message = _controller.text.trim();
//     //Widget? filePreviewWidget;

//     if (message.isEmpty &&
//         _selectedImage == null &&
//         _selectedDocument == null) {
//       return;
//     }
//     /*if (_selectedImage != null) {
//       filePreviewWidget = Padding(
//         padding: const EdgeInsets.only(top: 8.0),
//         child: SizedBox(
//           height: 80,
//           width: 80,
//           child: Image.file(_selectedImage!, fit: BoxFit.cover),
//         ),
//       );
//     } else if (_selectedDocument != null) {
//       filePreviewWidget = Padding(
//         padding: const EdgeInsets.only(top: 8.0),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Icon(Icons.file_present, size: 16),
//             const SizedBox(width: 4.0),
//             Text(
//               path.basename(_selectedDocument!.path),
//               style: TextStyle(fontSize: 12),
//             ),
//           ],
//         ),
//       );
//     }*/

//     final userId = getCurrentUserId();
//     if (userId == null) {
//       print("Error: User not authenticated.");
//       return;
//     }

//     currentSessionId ??= uuid.v4(); // Generate a new session ID if not set

//     final messageData = {
//       "sessionId": currentSessionId,
//       "role": "user",
//       "text": message,
//       "timestamp": FieldValue.serverTimestamp(),
//       //if (_selectedImage != null) "imagePath": _selectedImage!.path,
//       //if (_selectedDocument != null) "documentPath": _selectedDocument!.path,
//     };

//     await FirebaseFirestore.instance
//         .collection("users") // Top-level collection for users
//         .doc(userId)
//         .collection("user_chats") // Subcollection for user's chats
//         .add(messageData);

//     if (mounted) {
//       setState(() {
//         _messages.add({
//           "role": "user",
//           "text": message,
//           //"filePreview": filePreviewWidget, // Store the preview widget
//         });
//       });
//     }

//     try {
//       List<Map<String, dynamic>> parts = [];
//       if (message.isNotEmpty) {
//         parts.add({"text": message});
//       }
//       if (_selectedImage != null) {
//         parts.add({
//           "inlineData": {
//             "mimeType": "image/jpeg", // Assuming JPEG for simplicity
//             "data": base64Encode(_selectedImage!.readAsBytesSync()),
//           },
//         });
//       }
//       if (_selectedDocument != null) {
//         parts.add({
//           "inlineData": {
//             "mimeType": "application/pdf", // Assuming PDF for simplicity
//             "data": base64Encode(_selectedDocument!.readAsBytesSync()),
//           },
//         });
//       }
//       print(
//         "Sending request: ${jsonEncode({
//           "contents": [
//             {"parts": parts},
//           ],
//         })}",
//       );

//       final response = await http.post(
//         Uri.parse('$apiUrl?key=$apiKey'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           "systemInstruction": {
//             "parts": [
//               {
//                 "text":
//                     "You are a helpful educational assistant or an EduBot. Keep your responses concise and clear.",
//               },
//             ],
//           },
//           "contents": [
//             {"parts": parts},
//           ],
//         }),
//       );

//       if (response.statusCode == 200) {
//         final decodedResponse = jsonDecode(response.body);

//         String botResponse = "No response";
//         if (decodedResponse != null &&
//             decodedResponse['candidates'] != null &&
//             decodedResponse['candidates'].isNotEmpty &&
//             decodedResponse['candidates'][0]['content'] != null &&
//             decodedResponse['candidates'][0]['content']['parts'] != null &&
//             decodedResponse['candidates'][0]['content']['parts'].isNotEmpty &&
//             decodedResponse['candidates'][0]['content']['parts'][0]['text'] !=
//                 null) {
//           botResponse =
//               decodedResponse['candidates'][0]['content']['parts'][0]['text'];
//         }

//         final botMessageData = {
//           "sessionId": currentSessionId,
//           "role": "bot",
//           "text": botResponse,
//           "timestamp": FieldValue.serverTimestamp(),
//         };
//         await FirebaseFirestore.instance
//             .collection("users")
//             .doc(userId)
//             .collection("user_chats")
//             .add(botMessageData);

//         if (mounted) {
//           setState(() {
//             _messages.add({"role": "bot", "text": botResponse});
//           });
//         }
//       } else {
//         setState(() {
//           _messages.add({
//             "role": "bot",
//             "text":
//                 "Error: API request failed with status code ${response.statusCode}",
//           });
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _messages.add({
//           "role": "bot",
//           "text": "Error: Unable to fetch response. $e",
//         });
//       });
//     }

//     _controller.clear();
//     setState(() {
//       _selectedImage = null;
//       _selectedDocument = null;
//     });
//   }

//   Widget _buildFilePreview() {
//     if (_selectedImage != null) {
//       return Padding(
//         padding: const EdgeInsets.only(bottom: 8.0),
//         child: SizedBox(
//           height: 100,
//           width: 100,
//           child: Image.file(_selectedImage!, fit: BoxFit.cover),
//         ),
//       );
//     } else if (_selectedDocument != null) {
//       return Padding(
//         padding: const EdgeInsets.only(bottom: 8.0),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Icon(Icons.file_present),
//             const SizedBox(width: 8.0),
//             Text(path.basename(_selectedDocument!.path)),
//           ],
//         ),
//       );
//     } else {
//       return const SizedBox.shrink();
//     }
//   }

//   Future<void> loadChatSession(String sessionId) async {
//     final userId = getCurrentUserId();
//     if (userId == null) {
//       print("loadChatSession: User not authenticated.");
//       return;
//     }
//     print("loadChatSession: Loading session with ID: $sessionId"); // Debug

//     setState(() {
//       _messages.clear();
//       print("loadChatSession: _messages cleared"); // Debug
//     });

//     final querySnapshot =
//         await FirebaseFirestore.instance
//             .collection("users")
//             .doc(userId)
//             .collection("user_chats")
//             .where("sessionId", isEqualTo: sessionId)
//             .orderBy("timestamp", descending: false)
//             .get();

//     print(
//       "loadChatSession: Query returned ${querySnapshot.docs.length} documents",
//     ); // Debug

//     if (mounted) {
//       setState(() {
//         _messages =
//             querySnapshot.docs
//                 .map(
//                   (doc) => {
//                     "role": (doc["role"] ?? "") as String,
//                     "text": (doc["text"] ?? "") as String,
//                   },
//                 )
//                 .toList();
//         currentSessionId = sessionId;
//         _saveCurrentSessionId(sessionId);
//         print("loadChatSession: _messages updated: $_messages"); // Debug
//       });
//     }

//     if (context.mounted) {
//       Navigator.pop(context);
//     }
//   }

//   Future<void> _saveCurrentSessionId(String sessionId) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('currentSessionId', sessionId);
//   }

//   void showOverlay(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       builder:
//           (context) => Container(
//             height: 400,
//             padding: EdgeInsets.all(16),
//             child: Column(
//               children: [
//                 Text(
//                   "Past Chat Sessions",
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.history, color: Colors.white),
//                   onPressed: () {
//                     print("History icon pressed!");
//                     fetchChatSessions().then((_) {
//                       showModalBottomSheet(
//                         context: context,
//                         builder: (BuildContext context) {
//                           return Container(
//                             height: 200,
//                             color: Colors.amber,
//                             child: Center(child: Text('Simple Overlay')),
//                           );
//                         },
//                       );
//                     });
//                   },
//                 ),
//                 Expanded(
//                   child:
//                       _isLoadingSessions
//                           ? Center(child: CircularProgressIndicator())
//                           : ListView(
//                             children:
//                                 _chatSessions.entries.map((entry) {
//                                   return ListTile(
//                                     title: Text(
//                                       entry.value,
//                                     ), // Show first question
//                                     onTap:
//                                         () => loadChatSession(
//                                           entry.key,
//                                         ), // Load full session
//                                   );
//                                 }).toList(),
//                           ),
//                 ),
//               ],
//             ),
//           ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor:
//           Colors
//               .transparent, // Make Scaffold background transparent to show gradient
//       appBar: AppBar(
//         title: const Text("Chat with AI"),
//         backgroundColor: appBarColor,
//         actions: [
//           IconButton(
//             icon: Icon(Icons.history, color: Colors.white),
//             onPressed: () {
//               print("History icon pressed!");
//               fetchChatSessions().then((_) => showOverlay(context));
//             },
//           ),
//         ],
//         titleTextStyle: TextStyle(color: textColorPrimary, fontSize: 20),
//         iconTheme: IconThemeData(color: textColorPrimary),
//       ),
//       body: Stack(
//         children: [
//           // Gradient Background Container - Placed first to be behind other widgets
//           Positioned.fill(
//             child: Container(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topCenter, // Start gradient from the top
//                   end: Alignment.bottomCenter, // End gradient at the bottom
//                   colors: [
//                     const Color(0xFF21a199),
//                     gradientColorTop,
//                     gradientColorBottom,
//                   ], // Use defined gradient colors
//                 ),
//               ),
//             ),
//           ),
//           Positioned.fill(
//             // Image fills the entire background
//             child: Opacity(
//               // Optional: Adjust opacity to make doodles subtle
//               opacity: 0.5, // Example opacity, adjust as needed
//               child: Image.asset(
//                 "assets/bg_doodle.png", // Path to your doodle image asset
//                 fit: BoxFit.cover, // Cover the entire background
//               ),
//             ),
//           ),
//           Column(
//             children: [
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: _messages.length,
//                   itemBuilder: (context, index) {
//                     final msg = _messages[index];
//                     bool isUser = msg["role"] == "user";
//                     return Align(
//                       alignment:
//                           isUser ? Alignment.centerRight : Alignment.centerLeft,
//                       child: Container(
//                         margin: const EdgeInsets.symmetric(
//                           vertical: 5,
//                           horizontal: 10,
//                         ),
//                         padding: const EdgeInsets.all(10),
//                         decoration: BoxDecoration(
//                           color: isUser ? messageBubbleUser : messageBubbleBot,
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         // Changed the Text widget to a Column containing MarkdownBody
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             MarkdownBody(
//                               data: msg["text"]!,
//                               styleSheet: MarkdownStyleSheet(
//                                 p: TextStyle(
//                                   color:
//                                       isUser
//                                           ? textColorPrimary
//                                           : textColorSecondary,
//                                 ),
//                               ),
//                             ),
//                             if (isUser &&
//                                 msg.containsKey("filePreview") &&
//                                 msg["filePreview"] != null)
//                               msg["filePreview"]
//                                   as Widget, // Display the preview widget
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//               _buildFilePreview(), // Display the file preview here
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: TextField(
//                         controller: _controller,
//                         decoration: InputDecoration(
//                           hintText: "Ask something...",
//                           border: const OutlineInputBorder(),
//                           filled: true,
//                           fillColor: Colors.white,
//                           hintStyle: TextStyle(color: Colors.grey[600]),
//                           focusedBorder: OutlineInputBorder(
//                             borderSide: BorderSide(color: appBarColor),
//                           ),
//                           enabledBorder: OutlineInputBorder(
//                             borderSide: BorderSide(
//                               color: Colors.grey[400] ?? Colors.grey,
//                             ),
//                           ),
//                         ),
//                         style: TextStyle(color: textColorSecondary),
//                       ),
//                     ),
//                     IconButton(
//                       icon: Icon(Icons.image, color: textColorPrimary),
//                       onPressed: pickImage,
//                     ),
//                     IconButton(
//                       icon: Icon(Icons.attach_file, color: textColorPrimary),
//                       onPressed: pickDocument,
//                     ),
//                     IconButton(
//                       icon: Icon(Icons.send, color: textColorPrimary),
//                       onPressed: () {
//                         if (_controller.text.trim().isNotEmpty ||
//                             _selectedImage != null ||
//                             _selectedDocument != null) {
//                           sendMessage();
//                         }
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// ignore_for_file: use_build_context_synchronously
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_markdown/flutter_markdown.dart'; // Import the flutter_markdown package

String? currentSessionId;
final uuid = Uuid();
Map<String, String> _chatSessions = {};

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  //List<Map<String, dynamic>> _messages =;
  List<Map<String, String>> _messages = [];
  bool _isLoadingSessions = false;

  @override
  void initState() {
    super.initState();
    _loadInitialSession();
  }

  // Placeholder function to get the current user's ID
  String? getCurrentUserId() {
    // In a real application, you would get this from your authentication system
    // For example, using Firebase Auth: FirebaseAuth.instance.currentUser?.uid;
    return FirebaseAuth
        .instance
        .currentUser
        ?.uid; // Replace with actual user ID retrieval
  }

  // Future<void> _loadInitialSession() async {
  //   setState(() {
  //     _isLoadingSessions = true;
  //     print("_loadInitialSession: Setting _isLoadingSessions to true"); // Debug
  //   });
  //   final prefs = await SharedPreferences.getInstance();
  //   currentSessionId = prefs.getString('currentSessionId');

  //   await fetchChatSessions();
  //   if (currentSessionId != null) {
  //     await loadChatSession(currentSessionId!);
  //   }
  //   setState(() {
  //     _isLoadingSessions = false;
  //     print(
  //       "_loadInitialSession: Setting _isLoadingSessions to false",
  //     ); // Debug
  //   });
  // }

  Future<void> _loadInitialSession() async {
    setState(() {
      _isLoadingSessions = true;
      print("_loadInitialSession: Setting _isLoadingSessions to true"); // Debug
    });
    final prefs = await SharedPreferences.getInstance();
    // Generate a new session ID for a fresh chat
    currentSessionId = uuid.v4();
    await prefs.setString('currentSessionId', currentSessionId!);
    setState(() {
      _messages.clear(); // Clear any existing messages
      _isLoadingSessions = false;
      print(
        "_loadInitialSession: Setting _isLoadingSessions to false, new sessionId: $currentSessionId",
      ); // Debug
    });
  }

  // Future<void> fetchChatSessions() async {
  //   final userId = getCurrentUserId();
  //   if (userId == null) {
  //     print("Error: User not authenticated.");
  //     return;
  //   }
  //   setState(() {
  //     _isLoadingSessions = true;
  //     print("fetchChatSessions: Setting _isLoadingSessions to true"); // Debug
  //   });

  //   final querySnapshot =
  //       await FirebaseFirestore.instance
  //           .collection("users")
  //           .doc(userId)
  //           .collection("user_chats")
  //           .orderBy("timestamp", descending: true)
  //           .get();

  //   Map<String, String> sessionMap = {};
  //   Map<String, List<QueryDocumentSnapshot>> groupedSessions = {};

  //   for (var doc in querySnapshot.docs) {
  //     String sessionId = doc["sessionId"] ?? "";
  //     if (!groupedSessions.containsKey(sessionId)) {
  //       groupedSessions[sessionId] = [];
  //     }
  //     groupedSessions[sessionId]!.add(doc);
  //   }

  //   for (var sessionId in groupedSessions.keys) {
  //     try {
  //       var firstQuestion = groupedSessions[sessionId]!.firstWhere(
  //         (doc) => doc["role"] == "user",
  //         orElse: () => groupedSessions[sessionId]![0],
  //       );
  //       sessionMap[sessionId] = firstQuestion["text"] ?? "No Question Found";
  //     } catch (e) {
  //       print("Error processing session $sessionId: $e");
  //       sessionMap[sessionId] = "Error Loading Session";
  //     }
  //   }

  //   if (mounted) {
  //     setState(() {
  //       _chatSessions = sessionMap;
  //       print("fetchChatSessions: Setting _chatSessions: $_chatSessions");
  //     });
  //     print(
  //       "Fetched chat sessions for user $userId: $_chatSessions",
  //     ); // Debug print
  //   }
  //   setState(() {
  //     _isLoadingSessions = false;
  //     print("fetchChatSessions: Setting _isLoadingSessions to false"); // Debug
  //   });
  // }

  Future<void> fetchChatSessions() async {
    final userId = getCurrentUserId();
    if (userId == null) {
      print("Error: User not authenticated.");
      return;
    }
    setState(() {
      _isLoadingSessions = true;
      print("fetchChatSessions: Setting _isLoadingSessions to true"); // Debug
    });

    try {
      final querySnapshot =
          await FirebaseFirestore.instance
              .collection("users")
              .doc(userId)
              .collection("user_chats")
              .orderBy("timestamp", descending: true)
              .get();

      Map<String, String> sessionMap = {};
      Map<String, List<QueryDocumentSnapshot>> groupedSessions = {};

      for (var doc in querySnapshot.docs) {
        String sessionId = doc["sessionId"] ?? "";
        if (!groupedSessions.containsKey(sessionId)) {
          groupedSessions[sessionId] = [];
        }
        groupedSessions[sessionId]!.add(doc);
      }

      for (var sessionId in groupedSessions.keys) {
        try {
          var firstQuestion = groupedSessions[sessionId]!.firstWhere(
            (doc) => doc["role"] == "user",
            orElse: () => groupedSessions[sessionId]![0],
          );
          sessionMap[sessionId] = firstQuestion["text"] ?? "No Question Found";
        } catch (e) {
          print("Error processing session $sessionId: $e");
          sessionMap[sessionId] = "Error Loading Session";
        }
      }

      if (mounted) {
        setState(() {
          _chatSessions = sessionMap;
          print("fetchChatSessions: Setting _chatSessions: $_chatSessions");
        });
        print(
          "Fetched chat sessions for user $userId: $_chatSessions",
        ); // Debug print
      }
    } catch (e) {
      print(
        "Error during fetchChatSessions: $e",
      ); // Log any errors during the entire process
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingSessions = false;
          print(
            "fetchChatSessions: Setting _isLoadingSessions to false",
          ); // Debug
        });
      }
    }
  }

  File? _selectedImage;
  File? _selectedDocument;

  final String apiKey =
      'AIzaSyDO8uuSRqnt6i8DDE5AfTeOLEniZNObV54'; // Replace with your actual API key
  final String apiUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent';

  // Define theme colors based on the image, including gradient colors
  Color gradientColorTop = const Color(
    0xFF308ca5,
  ); // Top color of the gradient (darker blue)
  Color gradientColorBottom = const Color(
    0xFF083774,
  ); // Bottom color of the gradient (lighter blue)
  Color appBarColor = const Color(
    0xFF1976D2,
  ); // Slightly lighter blue for AppBar
  Color messageBubbleUser = const Color(
    0xFF29B6F6,
  ); // Light blue for user messages
  Color messageBubbleBot = const Color(
    0xFFE0E0E0,
  ); // Light grey for bot messages
  Color textColorPrimary =
      Colors.white; // White for primary text on blue backgrounds
  Color textColorSecondary = Colors.black;

  get parts => null; // Black for secondary text on light backgrounds

  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _selectedDocument = null; // Clear any previously selected document
        _buildFilePreview();
      });
    }
  }

  Future<void> pickDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _selectedDocument = File(result.files.single.path!);
        _selectedImage = null; // Clear any previously selected image
        _buildFilePreview();
      });
    }
  }

  Future<void> sendMessage() async {
    String message = _controller.text.trim();
    //Widget? filePreviewWidget;

    if (message.isEmpty &&
        _selectedImage == null &&
        _selectedDocument == null) {
      return;
    }
    /*if (_selectedImage != null) {
      filePreviewWidget = Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: SizedBox(
          height: 80,
          width: 80,
          child: Image.file(_selectedImage!, fit: BoxFit.cover),
        ),
      );
    } else if (_selectedDocument != null) {
      filePreviewWidget = Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.file_present, size: 16),
            const SizedBox(width: 4.0),
            Text(
              path.basename(_selectedDocument!.path),
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      );
    }*/

    final userId = getCurrentUserId();
    if (userId == null) {
      print("Error: User not authenticated.");
      return;
    }

    currentSessionId ??= uuid.v4(); // Generate a new session ID if not set

    final messageData = {
      "sessionId": currentSessionId,
      "role": "user",
      "text": message,
      "timestamp": FieldValue.serverTimestamp(),
      //if (_selectedImage != null) "imagePath": _selectedImage!.path,
      //if (_selectedDocument != null) "documentPath": _selectedDocument!.path,
    };

    await FirebaseFirestore.instance
        .collection("users") // Top-level collection for users
        .doc(userId)
        .collection("user_chats") // Subcollection for user's chats
        .add(messageData);

    if (mounted) {
      setState(() {
        _messages.add({
          "role": "user",
          "text": message,
          //"filePreview": filePreviewWidget, // Store the preview widget
        });
      });
    }

    try {
      List<Map<String, dynamic>> parts = [];
      if (message.isNotEmpty) {
        parts.add({"text": message});
      }
      if (_selectedImage != null) {
        parts.add({
          "inlineData": {
            "mimeType": "image/jpeg", // Assuming JPEG for simplicity
            "data": base64Encode(_selectedImage!.readAsBytesSync()),
          },
        });
      }
      if (_selectedDocument != null) {
        parts.add({
          "inlineData": {
            "mimeType": "application/pdf", // Assuming PDF for simplicity
            "data": base64Encode(_selectedDocument!.readAsBytesSync()),
          },
        });
      }
      print(
        "Sending request: ${jsonEncode({
          "contents": [
            {"parts": parts},
          ],
        })}",
      );

      final response = await http.post(
        Uri.parse('$apiUrl?key=$apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "systemInstruction": {
            "parts": [
              {
                "text":
                    """ You are a helpful AI EduBot designed to assist students with their learning. Your primary goal is to provide accurate, concise, and educationally relevant information. 
 **Your responsibilities include:**
 - Answering questions related to academic subjects like science, mathematics, history, literature, and technology.
 - Explaining concepts in a clear and understandable way. 
- Providing examples and elaborations when necessary. 
- Helping students understand their coursework and assignments. 
- Offering study tips and learning strategies. 
 **You must avoid:** 
- Answering questions that are not related to education or academic topics (e.g., personal opinions, current events unrelated to curriculum, social advice, health advice, etc.). 
- Engaging in casual conversation or small talk beyond the scope of an educational query. 
- Providing subjective opinions or biased information. 
- Answering questions that could be harmful or unethical. 
 If a user asks a question outside of your educational scope, politely decline to answer and state that you are designed to assist with educational topics only. For example, you can say: "I am designed to help with educational questions. Could you please ask something related to your studies?" or "My focus is on providing educational support. How can I help you with your learning today?" Keep your responses concise and clear, but prioritize accuracy and educational value. When possible, format your responses using markdown for better readability (e.g., using bullet points, bold text for key terms). """,
              },
            ],
          },
          "contents": [
            {"parts": parts},
          ],
        }),
      );

      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);

        String botResponse = "No response";
        if (decodedResponse != null &&
            decodedResponse['candidates'] != null &&
            decodedResponse['candidates'].isNotEmpty &&
            decodedResponse['candidates'][0]['content'] != null &&
            decodedResponse['candidates'][0]['content']['parts'] != null &&
            decodedResponse['candidates'][0]['content']['parts'].isNotEmpty &&
            decodedResponse['candidates'][0]['content']['parts'][0]['text'] !=
                null) {
          botResponse =
              decodedResponse['candidates'][0]['content']['parts'][0]['text'];
        }

        final botMessageData = {
          "sessionId": currentSessionId,
          "role": "bot",
          "text": botResponse,
          "timestamp": FieldValue.serverTimestamp(),
        };
        await FirebaseFirestore.instance
            .collection("users")
            .doc(userId)
            .collection("user_chats")
            .add(botMessageData);

        if (mounted) {
          setState(() {
            _messages.add({"role": "bot", "text": botResponse});
          });
        }
      } else {
        setState(() {
          _messages.add({
            "role": "bot",
            "text":
                "Error: API request failed with status code ${response.statusCode}",
          });
        });
      }
    } catch (e) {
      setState(() {
        _messages.add({
          "role": "bot",
          "text": "Error: Unable to fetch response. $e",
        });
      });
    }

    _controller.clear();
    setState(() {
      _selectedImage = null;
      _selectedDocument = null;
    });
  }

  Widget _buildFilePreview() {
    if (_selectedImage != null) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: SizedBox(
          height: 100,
          width: 100,
          child: Image.file(_selectedImage!, fit: BoxFit.cover),
        ),
      );
    } else if (_selectedDocument != null) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.file_present),
            const SizedBox(width: 8.0),
            Text(path.basename(_selectedDocument!.path)),
          ],
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Future<void> loadChatSession(String sessionId) async {
    final userId = getCurrentUserId();
    if (userId == null) {
      print("loadChatSession: User not authenticated.");
      return;
    }
    print("loadChatSession: Loading session with ID: $sessionId"); // Debug

    print(
      "loadChatSession: Before clearing _messages: ${_messages.length}",
    ); // Debug
    setState(() {
      _messages.clear();
      print("loadChatSession: _messages cleared"); // Debug
    });

    final querySnapshot =
        await FirebaseFirestore.instance
            .collection("users")
            .doc(userId)
            .collection("user_chats")
            .where("sessionId", isEqualTo: sessionId)
            .orderBy("timestamp", descending: false)
            .get();

    print(
      "loadChatSession: Query returned ${querySnapshot.docs.length} documents",
    ); // Debug

    if (mounted) {
      setState(() {
        _messages =
            querySnapshot.docs
                .map(
                  (doc) => {
                    "role": (doc["role"] ?? "") as String,
                    "text": (doc["text"] ?? "") as String,
                  },
                )
                .toList();
        currentSessionId = sessionId;
        _saveCurrentSessionId(sessionId);
        print(
          "loadChatSession: _messages updated: ${_messages.length}, content: $_messages",
        ); // Debug
      });
    }

    // if (context.mounted) {
    //   Navigator.pop(context);
    // }
  }

  Future<void> _saveCurrentSessionId(String sessionId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('currentSessionId', sessionId);
  }

  void showOverlay(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder:
          (context) => Container(
            height: 400,
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  "Past Chat Sessions",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(Icons.history, color: Colors.white),
                  onPressed: () {
                    print("History icon pressed!");
                    fetchChatSessions().then((_) {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            height: 200,
                            color: Colors.amber,
                            child: Center(child: Text('Simple Overlay')),
                          );
                        },
                      );
                    });
                  },
                ),
                Expanded(
                  child:
                      _isLoadingSessions
                          ? Center(child: CircularProgressIndicator())
                          : ListView(
                            children:
                                _chatSessions.entries.map((entry) {
                                  return ListTile(
                                    title: Text(
                                      entry.value,
                                    ), // Show first question
                                    onTap:
                                        () => loadChatSession(
                                          entry.key,
                                        ), // Load full session
                                  );
                                }).toList(),
                          ),
                ),
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors
              .transparent, // Make Scaffold background transparent to show gradient
      appBar: AppBar(
        title: const Text("Chat with AI"),
        backgroundColor: appBarColor,
        actions: [
          IconButton(
            icon: Icon(Icons.history, color: Colors.white),
            onPressed: () {
              print("History icon pressed!");
              fetchChatSessions().then((_) => showOverlay(context));
            },
          ),
        ],
        titleTextStyle: TextStyle(color: textColorPrimary, fontSize: 20),
        iconTheme: IconThemeData(color: textColorPrimary),
      ),
      body: Stack(
        children: [
          // Gradient Background Container - Placed first to be behind other widgets
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter, // Start gradient from the top
                  end: Alignment.bottomCenter, // End gradient at the bottom
                  colors: [
                    const Color(0xFF21a199),
                    gradientColorTop,
                    gradientColorBottom,
                  ], // Use defined gradient colors
                ),
              ),
            ),
          ),
          Positioned.fill(
            // Image fills the entire background
            child: Opacity(
              // Optional: Adjust opacity to make doodles subtle
              opacity: 0.5, // Example opacity, adjust as needed
              child: Image.asset(
                "assets/bg_doodle.png", // Path to your doodle image asset
                fit: BoxFit.cover, // Cover the entire background
              ),
            ),
          ),
          Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final msg = _messages[index];
                    bool isUser = msg["role"] == "user";
                    return Align(
                      alignment:
                          isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 10,
                        ),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isUser ? messageBubbleUser : messageBubbleBot,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        // Changed the Text widget to a Column containing MarkdownBody
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MarkdownBody(
                              data: msg["text"]!,
                              styleSheet: MarkdownStyleSheet(
                                p: TextStyle(
                                  color:
                                      isUser
                                          ? textColorPrimary
                                          : textColorSecondary,
                                ),
                              ),
                            ),
                            if (isUser &&
                                msg.containsKey("filePreview") &&
                                msg["filePreview"] != null)
                              msg["filePreview"]
                                  as Widget, // Display the preview widget
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              _buildFilePreview(), // Display the file preview here
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          hintText: "Ask something...",
                          border: const OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                          hintStyle: TextStyle(color: Colors.grey[600]),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: appBarColor),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey[400] ?? Colors.grey,
                            ),
                          ),
                        ),
                        style: TextStyle(color: textColorSecondary),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.image, color: textColorPrimary),
                      onPressed: pickImage,
                    ),
                    IconButton(
                      icon: Icon(Icons.attach_file, color: textColorPrimary),
                      onPressed: pickDocument,
                    ),
                    IconButton(
                      icon: Icon(Icons.send, color: textColorPrimary),
                      onPressed: () {
                        if (_controller.text.trim().isNotEmpty ||
                            _selectedImage != null ||
                            _selectedDocument != null) {
                          sendMessage();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
