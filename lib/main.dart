import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'chat_screen.dart';
import 'courses_page.dart'; // Import CoursesPage
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'models.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart'; // Import path_provider
import 'package:permission_handler/permission_handler.dart'; // Import permission_handler
import 'dart:io'; // Import for file system operations like Directory
import 'package:url_launcher/url_launcher.dart'; // Import url_launcher
import 'package:http/http.dart' as http; // Import http
import 'package:open_filex/open_filex.dart'; // Keep this for OpenFilex.open

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize flutter_downloader
  if (!kIsWeb) {
    // flutter_downloader is not supported on web
    await FlutterDownloader.initialize(
      debug: true, // Set to false in production. Recommended to use kDebugMode.
      ignoreSsl:
          true, // Set to false in production if you have proper SSL certificates.
      // True can be a security risk but useful for local testing if SSL issues arise.
    );
  }

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyBKiVjiWlU_00Nbi3ual67CL6FPhRI3WtQ",
        authDomain: "education-app-2ff8c.firebaseapp.com",
        projectId: "education-app-2ff8c",
        storageBucket: "education-app-2ff8c.firebasestorage.app",
        messagingSenderId: "207279373458",
        appId: "1:207279373458:web:c1c242afdef9891c14fa4b",
        measurementId: "G-MEVXEPT92E",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AIMZY',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: AuthWrapper(), // Use AuthWrapper as the initial screen
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        print(
          "AuthWrapper snapshot connection state: ${snapshot.connectionState}",
        );
        print("AuthWrapper snapshot has data: ${snapshot.hasData}");
        print("AuthWrapper snapshot error: ${snapshot.error}");
        print("AuthWrapper snapshot data: ${snapshot.data}");
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SplashScreen(
            key: Key('splash'),
          ); // Show splash screen while checking auth state
        }
        if (snapshot.hasData) {
          print("AuthWrapper: User is logged in, navigating to MainScreen");
          return MainScreen(); // User is logged in, navigate to MainScreen
        } else {
          print("AuthWrapper: User is not logged in, navigating to LoginPage");
          return LoginPage(); // User is not logged in, navigate to LoginPage
        }
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({required Key key}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _animation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset("assets/splash.jpeg", fit: BoxFit.cover),
          Center(
            child: ScaleTransition(
              scale: _animation,
              child: FadeTransition(
                opacity: _animation,
                child: Image.asset("assets/logo.png", height: 200),
              ),
            ),
          ),
          const Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

// MainScreen with HomeScreen Integrated
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    CourseSelectionPage(), // Now correctly integrated
    ChatScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    print("DEBUG: Building Main Screen");
    return Scaffold(
      
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.teal.shade300,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Courses',
          ), // This now links to CoursesPage
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

// class HomeScreenState extends State<HomeScreen> {
// bool _isLoadingCourses = true;
// List<Course> _recommendedCourses = []; // Change to Course objects
// List<Course> ongoingCourses = [];
// final String? _userId = FirebaseAuth.instance.currentUser?.uid;

// Future<List<String>> _fetchJoinedCourseIds() async {
// if (_userId == null) return []; // Return an empty list if no user
// try {
// DocumentSnapshot userCoursesSnapshot =
// await FirebaseFirestore.instance
// .collection('userCourses')
// .doc(_userId)
// .get();
// if (userCoursesSnapshot.exists && userCoursesSnapshot.data() != null) {
// // Explicitly cast to Map<String, dynamic>
// Map<String, dynamic>? data =
// userCoursesSnapshot.data() as Map<String, dynamic>?;
// return List<String>.from(
// data?['joinedCourses'] ?? [],
// ); // Provide a default empty list
// }
// return []; // Return an empty list if no data
// } catch (e) {
// print("Error fetching joined course IDs: $e");
// return []; // Return an empty list on error
// }
// }

// Future<void> _fetchRecommendedCourses() async {
// try {
// QuerySnapshot snapshot =
// await FirebaseFirestore.instance.collection('Course').get();
// List<Course> allCourses =
// snapshot.docs.map((doc) => courseFromFirestore(doc)).toList();
// List<String> joinedCourseIds = await _fetchJoinedCourseIds();
// setState(() {
// _recommendedCourses =
// allCourses
// .where((course) => !joinedCourseIds.contains(course.id))
// .toList();
// ongoingCourses =
// allCourses
// .where((course) => joinedCourseIds.contains(course.id))
// .toList();
// _isLoadingCourses = false;
// });
// } catch (e) {
// print("Error fetching courses: $e");
// setState(() {
// _isLoadingCourses = false;
// });
// }
// }

// @override
// void initState() {
// super.initState();
// _fetchRecommendedCourses();
// }

// @override
// Widget build(BuildContext context) {
// return Scaffold(
// body: Container(
// decoration: BoxDecoration(
// gradient: LinearGradient(
// begin: Alignment.topCenter,
// end: Alignment.bottomCenter,
// colors: [Color(0xFF2F5A76), Color(0xFFA8D0E6)],
// ),
// ),
// child: Padding(
// padding: const EdgeInsets.all(16.0),
// child: Column(
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// Row(
// mainAxisAlignment: MainAxisAlignment.spaceBetween,
// children: [
// Text(
// "HELLO BUDDY !!",
// style: TextStyle(
// fontSize: 28,
// fontWeight: FontWeight.bold,
// color: Colors.white,
// ),
// ),
// IconButton(
// icon: Icon(
// Icons.account_circle,
// color: Colors.white,
// size: 40,
// ),
// onPressed: () {
// Navigator.push(
// context,
// MaterialPageRoute(builder: (context) => ProfilePage()),
// );
// },
// ),
// ],
// ),
// SizedBox(height: 16),
// SearchBar(),
// SizedBox(height: 16),
// Expanded(
// child: SingleChildScrollView(
// child: Column(
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// SectionTitle(title: "Recommended Courses"),
// _isLoadingCourses
// ? Center(child: CircularProgressIndicator())
// : _recommendedCourses.isEmpty
// ? Center(child: Text("No recommended courses."))
// : CourseRow(
// courses: _recommendedCourses,
// buttonText: "Join",
// ),
// SectionTitle(title: "Ongoing Courses"),
// CourseRow(
// courses: _recommendedCourses,
// buttonText: "Continue",
// ),
// SectionTitle(title: "Offline Downloads"),
// CourseRow(
// courses: _recommendedCourses,
// buttonText: "Download",
// ),
// ],
// ),
// ),
// ),
// ],
// ),
// ),
// ),
// );
// }
// }

class HomeScreenState extends State<HomeScreen> {
  bool _isLoadingCourses = true;
  List<Course> _recommendedCourses = [];
  List<Course> ongoingCourses = [];
  final String? _userId = FirebaseAuth.instance.currentUser?.uid;

  Future<List<String>> _fetchJoinedCourseIds() async {
    if (_userId == null) return [];
    try {
      DocumentSnapshot userCoursesSnapshot =
          await FirebaseFirestore.instance
              .collection('userCourses')
              .doc(_userId)
              .get();
      if (userCoursesSnapshot.exists && userCoursesSnapshot.data() != null) {
        Map<String, dynamic>? data =
            userCoursesSnapshot.data() as Map<String, dynamic>?;
        return List<String>.from(data?['joinedCourses'] ?? []);
      }
      return [];
    } catch (e) {
      print("Error fetching joined course IDs: $e");
      return [];
    }
  }

  Future<void> _fetchRecommendedCourses() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('Course').get();
      List<Course> allCourses =
          snapshot.docs.map((doc) => courseFromFirestore(doc)).toList();
      List<String> joinedCourseIds = await _fetchJoinedCourseIds();
      setState(() {
        _recommendedCourses =
            allCourses
                .where((course) => !joinedCourseIds.contains(course.id))
                .toList();
        ongoingCourses =
            allCourses
                .where((course) => joinedCourseIds.contains(course.id))
                .toList();
        _isLoadingCourses = false;
      });
    } catch (e) {
      print("Error fetching courses: $e");
      setState(() {
        _isLoadingCourses = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchRecommendedCourses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2F5A76), Color(0xFFA8D0E6)],
          ),
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
                    "HELLO BUDDY !!",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.account_circle,
                      color: Colors.white,
                      size: 40,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProfilePage()),
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: 16),
              SearchBar(),
              SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionTitle(title: "Recommended Courses"),
                      _isLoadingCourses
                          ? Center(child: CircularProgressIndicator())
                          : _recommendedCourses.isEmpty
                          ? Center(child: Text("No recommended courses."))
                          : CourseRow(
                            courses: _recommendedCourses,
                            buttonText: "Join",
                          ),
                      SectionTitle(title: "Ongoing Courses"),
                      _isLoadingCourses
                          ? Center(child: CircularProgressIndicator())
                          : ongoingCourses.isEmpty
                          ? Center(child: Text("No ongoing courses."))
                          : CourseRow(
                            courses: ongoingCourses,
                            buttonText: "Continue",
                          ),
                      SectionTitle(title: "Offline Downloads"),
                      CourseRow(
                        courses:
                            ongoingCourses, // Keep this as is or modify based on your offline download logic
                        buttonText: "Download",
                      ),
                    ],
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

class SearchBar extends StatelessWidget {
  const SearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: "Search courses...",
        prefixIcon: Icon(Icons.search, color: Colors.teal),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}

class CourseRow extends StatelessWidget {
  final List<Course> courses; // Change to List<Course>
  final String buttonText;
  const CourseRow({super.key, required this.courses, required this.buttonText});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children:
            courses
                .map(
                  (course) => CourseCard(
                    course: course, // Pass Course object
                    buttonText: buttonText,
                  ),
                )
                .toList(),
      ),
    );
  }
}

class CourseCard extends StatefulWidget {
  final Course course; // Change to Course object
  final String buttonText;
  const CourseCard({super.key, required this.course, required this.buttonText});

  @override
  CourseCardState createState() => CourseCardState();
}

class CourseCardState extends State<CourseCard>
    with SingleTickerProviderStateMixin {
  double _scale = 1.0;
  late AnimationController _controller;
  final String? _userId = FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 100),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
      setState(() {
        _scale = 1 - _controller.value;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  Future<void> _joinCourse() async {
    if (_userId == null) return;
    print(
      "DEBUG: _joinCourse() called for course ID: ${widget.course.id}",
    ); // Add this line
    try {
      DocumentReference userCoursesRef = FirebaseFirestore.instance
          .collection('userCourses')
          .doc(_userId);
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(userCoursesRef);
        print(
          "DEBUG: userCoursesRef exists: ${snapshot.exists}",
        ); // Add this line
        if (!snapshot.exists) {
          print(
            "DEBUG: Creating new userCourses document with course ID: ${widget.course.id}",
          ); // Add this line
          await userCoursesRef.set({
            'joinedCourses': [widget.course.id],
          });
        } else {
          Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
          List<String> joinedCourses = List<String>.from(
            data?['joinedCourses'] ?? [],
          );
          print(
            "DEBUG: Existing joinedCourses: $joinedCourses",
          ); // Add this line
          if (!joinedCourses.contains(widget.course.id)) {
            print(
              "DEBUG: Adding course ID ${widget.course.id} to joinedCourses",
            ); // Add this line
            joinedCourses.add(widget.course.id);
            transaction.update(userCoursesRef, {
              'joinedCourses': joinedCourses,
            });
          } else {
            print(
              "DEBUG: Course ID ${widget.course.id} already in joinedCourses",
            ); // Add this line
          }
        }
      });
      print("DEBUG: _joinCourse() completed"); // Add this line
      // No need to refresh the whole HomeScreen here, the CoursesPage will refresh on its own
    } catch (e) {
      print("DEBUG: Error joining course: $e"); // Add this line
      // Handle error appropriately (e.g., show a snackbar)
    }
  }

  // Future<void> _downloadFile(String url, String filename) async {
  // print("DEBUG: _downloadFile called with URL: $url and filename: $filename");
  // var status = await Permission.storage.status;
  // print(
  // "DEBUG: Initial Storage permission status: $status",
  // ); // Added log for initial status

  // // 2. If permission is denied, request it
  // if (status.isDenied) {
  // print(
  // 'DEBUG: Requesting Storage permission...',
  // ); // Added log for requesting
  // status = await Permission.storage.request();
  // print(
  // 'DEBUG: Storage permission status after request: $status',
  // ); // Added log for status after request
  // }

  // // 3. Proceed based on the final status
  // if (status.isGranted) {
  // print(
  // 'DEBUG: Storage permission granted. Proceeding with download.',
  // ); // Added log for granted status

  // // Get the directory where you want to save the file
  // // Using getExternalStorageDirectory() requires WRITE_EXTERNAL_STORAGE on older Android
  // // and might have issues with Scoped Storage on Android 10+.
  // // Consider using getApplicationDocumentsDirectory() if you don't need shared access.
  // final externalDir = await getExternalStorageDirectory();
  // print("DEBUG: External storage directory: $externalDir");

  // if (externalDir == null) {
  // print("ERROR: Could not get external storage directory.");
  // ScaffoldMessenger.of(context).showSnackBar(
  // SnackBar(content: Text('Could not access storage directory.')),
  // );
  // return;
  // }

  // // Define the save path, e.g., create a 'Download' subdirectory
  // final savePath =
  // '${externalDir.path}/Download'; // Example: saving to a 'Download' folder

  // // Create the directory if it doesn't exist (important!)
  // final savedDir = Directory(savePath);
  // bool hasExisted = await savedDir.exists();
  // if (!hasExisted) {
  // print(
  // "DEBUG: Creating download directory: $savePath",
  // ); // Added log for directory creation
  // try {
  // await savedDir.create(recursive: true); // Use recursive: true
  // } catch (e) {
  // print("ERROR: Could not create download directory: $e");
  // ScaffoldMessenger.of(context).showSnackBar(
  // SnackBar(content: Text('Could not create download directory.')),
  // );
  // return; // Stop if directory creation fails
  // }
  // }

  // final taskId = await FlutterDownloader.enqueue(
  // url: url,
  // savedDir: savePath, // Use the created path
  // fileName: filename,
  // showNotification: true,
  // openFileFromNotification: true,
  // saveInPublicStorage:
  // false, // Keep this false if using getExternalFilesDir() or a specific subdirectory within getExternalStorageDirectory() not meant for public scanning
  // // You might need true if saving directly to root or standard public folders like Downloads, but be careful with Scoped Storage.
  // );
  // print("DEBUG: Download task enqueued with ID: $taskId");
  // } else if (status.isPermanentlyDenied) {
  // // 4. Handle permanently denied case
  // print(
  // 'DEBUG: Storage permission permanently denied. Guiding user to settings.',
  // ); // Added log
  // ScaffoldMessenger.of(context).showSnackBar(
  // SnackBar(
  // content: Text(
  // 'Storage permission permanently denied. Please enable it in app settings.',
  // ),
  // action: SnackBarAction(
  // label: 'Settings',
  // onPressed: () {
  // openAppSettings(); // Open app settings for the user
  // },
  // ),
  // ),
  // );
  // } else {
  // // 5. Handle other states like restricted, limited, etc.
  // print(
  // 'DEBUG: Storage permission status is $status. Cannot download.',
  // ); // Added log for other statuses
  // ScaffoldMessenger.of(context).showSnackBar(
  // SnackBar(
  // content: Text('Storage permission is required to download files.'),
  // ),
  // );
  // }
  // }

  Future<void> _launchURL(String url) async {
    print("DEBUG: Attempting to download and open URL: $url");
    final Uri uri = Uri.parse(url);

    try {
      // 1. Download the file
      final response = await http.get(uri);
      if (response.statusCode != 200) {
        print(
          "ERROR: Failed to download file. Status code: ${response.statusCode}",
        );
        if (mounted) {
          // Check if the widget is still mounted before showing SnackBar
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Failed to download file.')));
        }
        return;
      }

      // 2. Get a temporary directory
      final directory = await getTemporaryDirectory();
      // Extract filename from URL (or generate a unique one)
      String filename = uri.pathSegments.last.split('?').first;
      if (!filename.toLowerCase().endsWith('.pdf')) {
        filename += '.pdf'; // Ensure it has a .pdf extension
      }
      final filePath = '${directory.path}/$filename';
      final file = File(filePath);

      // 3. Write the downloaded bytes to the local file
      await file.writeAsBytes(response.bodyBytes);
      print("DEBUG: File downloaded to: $filePath");

      // 4. Use open_filex to open the downloaded file
      final result = await OpenFilex.open(filePath);

      if (result.type == ResultType.done) {
        print("DEBUG: result.type = ${result.type}");

        print("DEBUG: File opened successfully: $filePath");
      } else {
        print(
          "ERROR: Failed to open file using OpenFilex. Result: ${result.message}",
        );
        if (mounted) {
          // Check if the widget is still mounted before showing SnackBar
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Could not open the file. Make sure you have a PDF viewer installed.',
              ),
            ),
          );
        }
      }
    } catch (e) {
      print("ERROR during file download or launch: $e");
      if (mounted) {
        // Check if the widget is still mounted before showing SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred while opening the file.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: () {
        _controller.reverse();
      },
      child: Transform.scale(
        scale: _scale,
        child: Container(
          margin: EdgeInsets.all(8.0),
          width: 200,
          height: 180,
          decoration: BoxDecoration(
            image:
                widget.course.imageUrl.isNotEmpty
                    ? (widget.course.imageUrl.startsWith(
                          'assets/',
                        )) // Check if it's a local asset path
                        ? DecorationImage(
                          image: AssetImage(
                            widget.course.imageUrl,
                          ), // Use AssetImage for local assets
                          fit: BoxFit.cover,
                        )
                        : DecorationImage(
                          image: NetworkImage(
                            widget.course.imageUrl,
                          ), // Use NetworkImage for URLs
                          fit: BoxFit.cover,
                        )
                    : null,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                // ignore: deprecated_member_use
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 3,
                blurRadius: 7,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.course.title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (widget.buttonText.isNotEmpty) // Ensure buttonText is "Join"
                ElevatedButton(
                  onPressed: () {
                    if (widget.buttonText == "Join") {
                      _joinCourse();
                    } else if (widget.buttonText == "Continue") {
                      // Navigate to CourseRoadmapPage
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  CourseRoadmapPage(course: widget.course),
                        ),
                      );
                    } else if (widget.buttonText == "Download") {
                      // Call the _downloadFile function
                      if (widget.course.downloadUrl != null &&
                          widget.course.downloadUrl!.isNotEmpty) {
                        _launchURL(
                          widget.course.downloadUrl!,
                        ); // You can customize the filename
                      } else {
                        print(
                          "DEBUG: No download URL available for ${widget.course.title}",
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'No downloadable file available for this course.',
                            ),
                          ),
                        );
                      }
                    } else {
                      // Handle other button actions (e.g., "Download")
                      print(
                        "DEBUG: ${widget.buttonText} button pressed for course: ${widget.course.title}",
                      );
                    }
                  },
                  child: Text(widget.buttonText),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _profilePicController;
  late Animation<double> _profilePicAnimation;

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    // The AuthWrapper will automatically navigate to LoginPage after sign out
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _profilePicController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _profilePicAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _profilePicController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _profilePicController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile"), backgroundColor: Colors.teal),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            AnimatedBuilder(
              animation: _profilePicAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _profilePicAnimation.value,
                  child: child,
                );
              },
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 70,
                    backgroundImage: AssetImage(
                      'assets/profile_placeholder.png',
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.white),
                    onPressed: () {},
                    style: IconButton.styleFrom(backgroundColor: Colors.teal),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  FirebaseAuth.instance.currentUser?.displayName ?? "User Name",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(icon: Icon(Icons.edit), onPressed: () {}),
              ],
            ),
            SizedBox(height: 32),
            ProfileListItem(
              icon: Icons.settings,
              label: "Settings",
              onTap: () {},
            ),
            ProfileListItem(
              icon: Icons.badge,
              label: "Your Badges",
              onTap: () {},
            ),
            ProfileListItem(
              icon: Icons.book,
              label: "Your Courses",
              onTap: () {},
            ),
            SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _logout,
              icon: Icon(Icons.logout),
              label: Text("Logout"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileListItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const ProfileListItem({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.teal),
      title: Text(label),
      onTap: onTap,
      trailing: Icon(Icons.chevron_right),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
