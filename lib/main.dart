// // import 'package:flutter/material.dart';
// // import 'chat_screen.dart'; // Import ChatScreen

// // void main() {
// //   runApp(const MyApp());
// // }

// // class MyApp extends StatelessWidget {
// //   const MyApp({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       title: 'Edu App',
// //       theme: ThemeData(primarySwatch: Colors.blue),
// //       home: const MainScreen(),
// //     );
// //   }
// // }

// // class MainScreen extends StatefulWidget {
// //   const MainScreen({super.key});

// //   @override
// //   MainScreenState createState() => MainScreenState();
// // }

// // class MainScreenState extends State<MainScreen> {
// //   int _selectedIndex = 0;

// //   final List<Widget> _screens = [
// //     const HomeScreen(),
// //     Container(), // Placeholder for Courses screen
// //     ChatScreen(), // Navigate to ChatScreen
// //   ];

// //   void _onItemTapped(int index) {
// //     setState(() {
// //       _selectedIndex = index;
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: _screens[_selectedIndex], // Display selected screen
// //       bottomNavigationBar: BottomNavigationBar(
// //         items: const [
// //           BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
// //           BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Courses'),
// //           BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
// //         ],
// //         currentIndex: _selectedIndex,
// //         onTap: _onItemTapped,
// //       ),
// //     );
// //   }
// // }

// // class HomeScreen extends StatelessWidget {
// //   const HomeScreen({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         backgroundColor: Colors.transparent,
// //         elevation: 0,
// //         toolbarHeight: 100,
// //         flexibleSpace: Container(
// //           padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
// //           child: Row(
// //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //             children: [
// //               Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 mainAxisAlignment: MainAxisAlignment.center,
// //                 children: const [
// //                   Text(
// //                     'User',
// //                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
// //                   ),
// //                   Row(
// //                     children: [
// //                       Text('GRADE '),
// //                       Text(
// //                         'Progress',
// //                         style: TextStyle(fontWeight: FontWeight.bold),
// //                       ),
// //                     ],
// //                   ),
// //                 ],
// //               ),
// //               const CircleAvatar(
// //                 radius: 30,
// //                 backgroundColor: Colors.grey,
// //                 child: Icon(Icons.person, color: Colors.white),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //       drawer: Drawer(
// //         child: ListView(
// //           padding: EdgeInsets.zero,
// //           children: <Widget>[
// //             const DrawerHeader(
// //               decoration: BoxDecoration(color: Colors.blue),
// //               child: Text(
// //                 'Hello Uper!',
// //                 style: TextStyle(color: Colors.white, fontSize: 24),
// //               ),
// //             ),
// //             ListTile(
// //               leading: const Icon(Icons.person_outline),
// //               title: const Text('Profile'),
// //               onTap: () => Navigator.pop(context),
// //             ),
// //             ListTile(
// //               leading: const Icon(Icons.settings_outlined),
// //               title: const Text('Settings'),
// //               onTap: () => Navigator.pop(context),
// //             ),
// //             ListTile(
// //               leading: const Icon(Icons.badge_outlined),
// //               title: const Text('Your badges'),
// //               onTap: () => Navigator.pop(context),
// //             ),
// //             ListTile(
// //               leading: const Icon(Icons.library_books_outlined),
// //               title: const Text('Your Courses'),
// //               onTap: () => Navigator.pop(context),
// //             ),
// //             ListTile(
// //               leading: const Icon(Icons.logout),
// //               title: const Text('Logout'),
// //               onTap: () => Navigator.pop(context),
// //             ),
// //           ],
// //         ),
// //       ),
// //       body: SingleChildScrollView(
// //         padding: const EdgeInsets.all(20.0),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             const Text(
// //               'Recommended Courses',
// //               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// //             ),
// //             const SizedBox(height: 10),
// //             Row(
// //               children: [
// //                 Expanded(child: _courseCardPlaceholder()),
// //                 const SizedBox(width: 10),
// //                 Expanded(child: _courseCardPlaceholder()),
// //                 const SizedBox(width: 10),
// //                 Expanded(child: _courseCardPlaceholder()),
// //               ],
// //             ),
// //             const SizedBox(height: 20),
// //             const Text(
// //               'ROADMAPS',
// //               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// //             ),
// //             const SizedBox(height: 10),
// //             Row(
// //               children: [
// //                 Expanded(child: _circularPlaceholder()),
// //                 const SizedBox(width: 10),
// //                 Expanded(child: _circularPlaceholder()),
// //                 const SizedBox(width: 10),
// //                 Expanded(child: _circularPlaceholder()),
// //               ],
// //             ),
// //             const SizedBox(height: 20),
// //             const Text(
// //               'Ongoing Courses',
// //               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// //             ),
// //             const SizedBox(height: 10),
// //             Row(
// //               children: [
// //                 Expanded(child: _courseCardPlaceholder()),
// //                 const SizedBox(width: 10),
// //                 Expanded(child: _courseCardPlaceholder()),
// //                 const SizedBox(width: 10),
// //                 Expanded(child: _courseCardPlaceholder()),
// //               ],
// //             ),
// //             const SizedBox(height: 20),
// //             const Text(
// //               'OFFLINE DOWNLOADS',
// //               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// //             ),
// //             const SizedBox(height: 10),
// //             Row(
// //               children: [
// //                 Expanded(child: _courseCardPlaceholder()),
// //                 const SizedBox(width: 10),
// //                 Expanded(child: _courseCardPlaceholder()),
// //                 const SizedBox(width: 10),
// //                 Expanded(child: _courseCardPlaceholder()),
// //               ],
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _courseCardPlaceholder() {
// //     return Container(
// //       height: 120,
// //       color: Colors.grey.shade200,
// //       child: const Center(child: Text('Course Card')),
// //     );
// //   }

// //   Widget _circularPlaceholder() {
// //     return Container(
// //       height: 70,
// //       width: 70,
// //       decoration: BoxDecoration(
// //         color: Colors.grey.shade200,
// //         shape: BoxShape.circle,
// //       ),
// //       child: const Center(child: Text('Roadmap')),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'chat_screen.dart'; // Import ChatScreen
// import 'courses_page.dart'; // Import CoursesPage

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Edu App',
//       theme: ThemeData(primarySwatch: Colors.blue),
//       home: const MainScreen(),
//     );
//   }
// }

// class MainScreen extends StatefulWidget {
//   const MainScreen({super.key});

//   @override
//   MainScreenState createState() => MainScreenState();
// }

// class MainScreenState extends State<MainScreen> {
//   int _selectedIndex = 0;

//   final List<Widget> _screens = [
//     const HomeScreen(),
//     CoursesPage(), // Navigate to CoursesPage
//     ChatScreen(), // Navigate to ChatScreen
//   ];

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _screens[_selectedIndex], // Display selected screen
//       bottomNavigationBar: BottomNavigationBar(
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
//           BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Courses'),
//           BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
//         ],
//         currentIndex: _selectedIndex,
//         onTap: _onItemTapped,
//       ),
//     );
//   }
// }

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         toolbarHeight: 100,
//         flexibleSpace: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: const [
//                   Text(
//                     'User',
//                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
//                   ),
//                   Row(
//                     children: [
//                       Text('GRADE '),
//                       Text(
//                         'Progress',
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//               const CircleAvatar(
//                 radius: 30,
//                 backgroundColor: Colors.grey,
//                 child: Icon(Icons.person, color: Colors.white),
//               ),
//             ],
//           ),
//         ),
//       ),
//       drawer: Drawer(
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: <Widget>[
//             const DrawerHeader(
//               decoration: BoxDecoration(color: Colors.blue),
//               child: Text(
//                 'Hello Uper!',
//                 style: TextStyle(color: Colors.white, fontSize: 24),
//               ),
//             ),
//             ListTile(
//               leading: const Icon(Icons.person_outline),
//               title: const Text('Profile'),
//               onTap: () => Navigator.pop(context),
//             ),
//             ListTile(
//               leading: const Icon(Icons.settings_outlined),
//               title: const Text('Settings'),
//               onTap: () => Navigator.pop(context),
//             ),
//             ListTile(
//               leading: const Icon(Icons.badge_outlined),
//               title: const Text('Your badges'),
//               onTap: () => Navigator.pop(context),
//             ),
//             ListTile(
//               leading: const Icon(Icons.library_books_outlined),
//               title: const Text('Your Courses'),
//               onTap: () => Navigator.pop(context),
//             ),
//             ListTile(
//               leading: const Icon(Icons.logout),
//               title: const Text('Logout'),
//               onTap: () => Navigator.pop(context),
//             ),
//           ],
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Recommended Courses',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 10),
//             Row(
//               children: [
//                 Expanded(child: _courseCardPlaceholder()),
//                 const SizedBox(width: 10),
//                 Expanded(child: _courseCardPlaceholder()),
//                 const SizedBox(width: 10),
//                 Expanded(child: _courseCardPlaceholder()),
//               ],
//             ),
//             const SizedBox(height: 20),
//             const Text(
//               'ROADMAPS',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 10),
//             Row(
//               children: [
//                 Expanded(child: _circularPlaceholder()),
//                 const SizedBox(width: 10),
//                 Expanded(child: _circularPlaceholder()),
//                 const SizedBox(width: 10),
//                 Expanded(child: _circularPlaceholder()),
//               ],
//             ),
//             const SizedBox(height: 20),
//             const Text(
//               'Ongoing Courses',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 10),
//             Row(
//               children: [
//                 Expanded(child: _courseCardPlaceholder()),
//                 const SizedBox(width: 10),
//                 Expanded(child: _courseCardPlaceholder()),
//                 const SizedBox(width: 10),
//                 Expanded(child: _courseCardPlaceholder()),
//               ],
//             ),
//             const SizedBox(height: 20),
//             const Text(
//               'OFFLINE DOWNLOADS',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 10),
//             Row(
//               children: [
//                 Expanded(child: _courseCardPlaceholder()),
//                 const SizedBox(width: 10),
//                 Expanded(child: _courseCardPlaceholder()),
//                 const SizedBox(width: 10),
//                 Expanded(child: _courseCardPlaceholder()),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _courseCardPlaceholder() {
//     return Container(
//       height: 120,
//       color: Colors.grey.shade200,
//       child: const Center(child: Text('Course Card')),
//     );
//   }

//   Widget _circularPlaceholder() {
//     return Container(
//       height: 70,
//       width: 70,
//       decoration: BoxDecoration(
//         color: Colors.grey.shade200,
//         shape: BoxShape.circle,
//       ),
//       child: const Center(child: Text('Roadmap')),
//     );
//   }
// }

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'dart:async';
// import 'chat_screen.dart';
// import 'courses_page.dart'; // Import CoursesPage
// import 'package:firebase_core/firebase_core.dart';
// import 'login.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   if (kIsWeb) {
//     await Firebase.initializeApp(
//       options: const FirebaseOptions(
//         apiKey: "AIzaSyBKiVjiWlU_00Nbi3ual67CL6FPhRI3WtQ",
//         authDomain: "education-app-2ff8c.firebaseapp.com",
//         projectId: "education-app-2ff8c",
//         storageBucket: "education-app-2ff8c.firebasestorage.app",
//         messagingSenderId: "207279373458",
//         appId: "1:207279373458:web:c1c242afdef9891c14fa4b",
//         measurementId: "G-MEVXEPT92E",
//       ),
//     );
//   } else {
//     await Firebase.initializeApp();
//   }

//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'AIMZY',
//       theme: ThemeData(primarySwatch: Colors.blue),
//       home: SplashScreen(key: Key('splash')),
//       routes: {'/login': (context) => LoginPage()},
//     );
//   }
// }

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({required Key key}) : super(key: key);

//   @override
//   SplashScreenState createState() => SplashScreenState();
// }

// class SplashScreenState extends State<SplashScreen>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _animation;

//   @override
//   void initState() {
//     super.initState();

//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 2),
//     );

//     _animation = Tween<double>(
//       begin: 0.5,
//       end: 1.0,
//     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

//     _controller.forward();

//     _initializeApp();
//   }

//   Future<void> _initializeApp() async {
//     await Future.delayed(const Duration(seconds: 3));

//     if (mounted) {
//       Navigator.of(context).pushReplacementNamed('/login');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         fit: StackFit.expand,
//         children: [
//           Image.asset("assets/splash.jpeg", fit: BoxFit.cover),
//           Center(
//             child: ScaleTransition(
//               scale: _animation,
//               child: FadeTransition(
//                 opacity: _animation,
//                 child: Image.asset("assets/logo.png", height: 200),
//               ),
//             ),
//           ),
//           const Positioned(
//             bottom: 50,
//             left: 0,
//             right: 0,
//             child: Center(
//               child: CircularProgressIndicator(
//                 valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
// }

// // MainScreen with HomeScreen Integrated
// class MainScreen extends StatefulWidget {
//   const MainScreen({super.key});

//   @override
//   MainScreenState createState() => MainScreenState();
// }

// class MainScreenState extends State<MainScreen> {
//   int _selectedIndex = 0;

//   final List<Widget> _screens = [
//     HomeScreen(),
//     CoursesPage(), // Now correctly integrated
//     ChatScreen(),
//   ];

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _screens[_selectedIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         backgroundColor: Colors.teal.shade300,
//         selectedItemColor: Colors.white,
//         unselectedItemColor: Colors.white70,
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.book),
//             label: 'Courses',
//           ), // This now links to CoursesPage
//           BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
//         ],
//         currentIndex: _selectedIndex,
//         onTap: _onItemTapped,
//       ),
//     );
//   }
// }

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   HomeScreenState createState() => HomeScreenState();
// }

// class HomeScreenState extends State<HomeScreen> {
//   bool _isLoadingCourses = true;
//   final List<Map<String, dynamic>> _recommendedCourses = [
//     {'subjectName': 'Math', 'backgroundImage': 'assets/math_bg.png'},
//     {'subjectName': 'Science', 'backgroundImage': 'assets/science_bg.png'},
//     {'subjectName': 'History', 'backgroundImage': 'assets/history_bg.png'},
//     {'subjectName': 'English', 'backgroundImage': 'assets/english_bg.png'},
//   ];

//   @override
//   void initState() {
//     super.initState();
//     Future.delayed(Duration(seconds: 2), () {
//       setState(() {
//         _isLoadingCourses = false;
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [Color(0xFF2F5A76), Color(0xFFA8D0E6)],
//           ),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     "HELLO USER !!",
//                     style: TextStyle(
//                       fontSize: 28,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                   IconButton(
//                     icon: Icon(
//                       Icons.account_circle,
//                       color: Colors.white,
//                       size: 40,
//                     ),
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => ProfilePage()),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//               SizedBox(height: 16),
//               SearchBar(),
//               SizedBox(height: 16),
//               Expanded(
//                 child: SingleChildScrollView(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       SectionTitle(title: "Recommended Courses"),
//                       _isLoadingCourses
//                           ? Center(child: CircularProgressIndicator())
//                           : _recommendedCourses.isEmpty
//                           ? Center(child: Text("No recommended courses."))
//                           : CourseRow(
//                             courses: _recommendedCourses,
//                             buttonText: "Join",
//                           ),
//                       SectionTitle(title: "Ongoing Courses"),
//                       CourseRow(
//                         courses: _recommendedCourses,
//                         buttonText: "Continue",
//                       ),
//                       SectionTitle(title: "Offline Downloads"),
//                       CourseRow(
//                         courses: _recommendedCourses,
//                         buttonText: "Download",
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class SearchBar extends StatelessWidget {
//   const SearchBar({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//       decoration: InputDecoration(
//         hintText: "Search courses...",
//         prefixIcon: Icon(Icons.search, color: Colors.teal),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: BorderSide.none,
//         ),
//         filled: true,
//         fillColor: Colors.white,
//       ),
//     );
//   }
// }

// class CourseRow extends StatelessWidget {
//   final List<Map<String, dynamic>> courses;
//   final String buttonText;
//   const CourseRow({
//     super.key,
//     required this.courses,
//     required this.buttonText,
//   }); // buttonText is now optional and defaults to ""

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: Row(
//         children:
//             courses
//                 .map(
//                   (course) => CourseCard(
//                     subjectName: course['subjectName'],
//                     backgroundImage: course['backgroundImage'],
//                     buttonText: buttonText, // Pass buttonText here
//                   ),
//                 )
//                 .toList(),
//       ),
//     );
//   }
// }

// class CourseCard extends StatefulWidget {
//   final String subjectName;
//   final String backgroundImage;
//   final String buttonText;
//   const CourseCard({
//     super.key,
//     required this.subjectName,
//     required this.backgroundImage,
//     required this.buttonText,
//   });

//   @override
//   // ignore: library_private_types_in_public_api
//   _CourseCardState createState() => _CourseCardState();
// }

// class _CourseCardState extends State<CourseCard>
//     with SingleTickerProviderStateMixin {
//   double _scale = 1.0;
//   late AnimationController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: Duration(milliseconds: 100),
//       lowerBound: 0.0,
//       upperBound: 0.1,
//     )..addListener(() {
//       setState(() {
//         _scale = 1 - _controller.value;
//       });
//     });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   void _onTapDown(TapDownDetails details) {
//     _controller.forward();
//   }

//   void _onTapUp(TapUpDetails details) {
//     _controller.reverse();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTapDown: _onTapDown,
//       onTapUp: _onTapUp,
//       onTapCancel: () {
//         _controller.reverse();
//       },
//       child: Transform.scale(
//         scale: _scale,
//         child: Container(
//           margin: EdgeInsets.all(8.0),
//           width: 200,
//           height: 180,
//           decoration: BoxDecoration(
//             image: DecorationImage(
//               image: AssetImage(widget.backgroundImage),
//               fit: BoxFit.cover,
//             ),
//             borderRadius: BorderRadius.circular(10),
//             boxShadow: [
//               BoxShadow(
//                 // ignore: deprecated_member_use
//                 color: Colors.grey.withOpacity(0.5),
//                 spreadRadius: 3,
//                 blurRadius: 7,
//               ),
//             ],
//           ),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 widget.subjectName,
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               if (widget
//                   .buttonText
//                   .isNotEmpty) // Conditionally show button if buttonText is provided
//                 ElevatedButton(
//                   onPressed: () {
//                     // Handle button press
//                   },
//                   child: Text(widget.buttonText),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class ProfilePage extends StatefulWidget {
//   const ProfilePage({super.key});

//   @override
//   // ignore: library_private_types_in_public_api
//   _ProfilePageState createState() => _ProfilePageState();
// }

// class _ProfilePageState extends State<ProfilePage>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _profilePicController;
//   late Animation<double> _profilePicAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _profilePicController = AnimationController(
//       vsync: this,
//       duration: Duration(milliseconds: 1500),
//     )..repeat(reverse: true);
//     _profilePicAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
//       CurvedAnimation(parent: _profilePicController, curve: Curves.easeInOut),
//     );
//   }

//   @override
//   void dispose() {
//     _profilePicController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Profile"), backgroundColor: Colors.teal),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             AnimatedBuilder(
//               animation: _profilePicAnimation,
//               builder: (context, child) {
//                 return Transform.scale(
//                   scale: _profilePicAnimation.value,
//                   child: child,
//                 );
//               },
//               child: Stack(
//                 alignment: Alignment.bottomRight,
//                 children: [
//                   CircleAvatar(
//                     radius: 70,
//                     backgroundImage: AssetImage(
//                       'assets/profile_placeholder.png',
//                     ),
//                   ),
//                   IconButton(
//                     icon: Icon(Icons.edit, color: Colors.white),
//                     onPressed: () {},
//                     style: IconButton.styleFrom(backgroundColor: Colors.teal),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 16),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   "User Name",
//                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                 ),
//                 IconButton(icon: Icon(Icons.edit), onPressed: () {}),
//               ],
//             ),
//             SizedBox(height: 32),
//             ProfileListItem(
//               icon: Icons.settings,
//               label: "Settings",
//               onTap: () {},
//             ),
//             ProfileListItem(
//               icon: Icons.badge,
//               label: "Your Badges",
//               onTap: () {},
//             ),
//             ProfileListItem(
//               icon: Icons.book,
//               label: "Your Courses",
//               onTap: () {},
//             ),
//             SizedBox(height: 32),
//             ElevatedButton.icon(
//               onPressed: () {
//                 showDialog(
//                   context: context,
//                   builder: (BuildContext context) {
//                     return AlertDialog(
//                       title: Text("Logout"),
//                       content: Text("Are you sure you want to logout?"),
//                       actions: [
//                         TextButton(
//                           child: Text("Cancel"),
//                           onPressed: () {
//                             Navigator.of(context).pop();
//                           },
//                         ),
//                         TextButton(
//                           child: Text("Logout"),
//                           onPressed: () {
//                             Navigator.of(context).pop();
//                             // Implement Logout Logic here in real app
//                           },
//                         ),
//                       ],
//                     );
//                   },
//                 );
//               },
//               icon: Icon(Icons.logout),
//               label: Text("Logout"),
//               style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class ProfileListItem extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final VoidCallback onTap;

//   const ProfileListItem({
//     super.key,
//     required this.icon,
//     required this.label,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       leading: Icon(icon, color: Colors.teal),
//       title: Text(label),
//       onTap: onTap,
//       trailing: Icon(Icons.chevron_right),
//     );
//   }
// }

// class SectionTitle extends StatelessWidget {
//   final String title;
//   const SectionTitle({super.key, required this.title});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Text(
//         title,
//         style: TextStyle(
//           fontSize: 20,
//           fontWeight: FontWeight.bold,
//           color: Colors.white,
//         ),
//       ),
//     );
//   }
// }

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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "YOUR_API_KEY", // Replace with your actual API key
        authDomain: "YOUR_AUTH_DOMAIN", // Replace with your actual auth domain
        projectId: "YOUR_PROJECT_ID", // Replace with your actual project ID
        storageBucket:
            "YOUR_STORAGE_BUCKET", // Replace with your actual storage bucket
        messagingSenderId:
            "YOUR_MESSAGING_SENDER_ID", // Replace with your actual messaging sender ID
        appId: "YOUR_APP_ID", // Replace with your actual app ID
        measurementId:
            "YOUR_MEASUREMENT_ID", // Replace with your actual measurement ID
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
      appBar: AppBar(
        title: Text('AIMZY'),
        automaticallyImplyLeading:
            false, // To prevent back button when logged in
      ),
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
//   bool _isLoadingCourses = true;
//   List<Course> _recommendedCourses = []; // Change to Course objects
//   List<Course> ongoingCourses = [];
//   final String? _userId = FirebaseAuth.instance.currentUser?.uid;

//   Future<List<String>> _fetchJoinedCourseIds() async {
//     if (_userId == null) return []; // Return an empty list if no user
//     try {
//       DocumentSnapshot userCoursesSnapshot =
//           await FirebaseFirestore.instance
//               .collection('userCourses')
//               .doc(_userId)
//               .get();
//       if (userCoursesSnapshot.exists && userCoursesSnapshot.data() != null) {
//         // Explicitly cast to Map<String, dynamic>
//         Map<String, dynamic>? data =
//             userCoursesSnapshot.data() as Map<String, dynamic>?;
//         return List<String>.from(
//           data?['joinedCourses'] ?? [],
//         ); // Provide a default empty list
//       }
//       return []; // Return an empty list if no data
//     } catch (e) {
//       print("Error fetching joined course IDs: $e");
//       return []; // Return an empty list on error
//     }
//   }

//   Future<void> _fetchRecommendedCourses() async {
//     try {
//       QuerySnapshot snapshot =
//           await FirebaseFirestore.instance.collection('Course').get();
//       List<Course> allCourses =
//           snapshot.docs.map((doc) => courseFromFirestore(doc)).toList();
//       List<String> joinedCourseIds = await _fetchJoinedCourseIds();
//       setState(() {
//         _recommendedCourses =
//             allCourses
//                 .where((course) => !joinedCourseIds.contains(course.id))
//                 .toList();
//         ongoingCourses =
//             allCourses
//                 .where((course) => joinedCourseIds.contains(course.id))
//                 .toList();
//         _isLoadingCourses = false;
//       });
//     } catch (e) {
//       print("Error fetching courses: $e");
//       setState(() {
//         _isLoadingCourses = false;
//       });
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     _fetchRecommendedCourses();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [Color(0xFF2F5A76), Color(0xFFA8D0E6)],
//           ),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     "HELLO BUDDY !!",
//                     style: TextStyle(
//                       fontSize: 28,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                   IconButton(
//                     icon: Icon(
//                       Icons.account_circle,
//                       color: Colors.white,
//                       size: 40,
//                     ),
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => ProfilePage()),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//               SizedBox(height: 16),
//               SearchBar(),
//               SizedBox(height: 16),
//               Expanded(
//                 child: SingleChildScrollView(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       SectionTitle(title: "Recommended Courses"),
//                       _isLoadingCourses
//                           ? Center(child: CircularProgressIndicator())
//                           : _recommendedCourses.isEmpty
//                           ? Center(child: Text("No recommended courses."))
//                           : CourseRow(
//                             courses: _recommendedCourses,
//                             buttonText: "Join",
//                           ),
//                       SectionTitle(title: "Ongoing Courses"),
//                       CourseRow(
//                         courses: _recommendedCourses,
//                         buttonText: "Continue",
//                       ),
//                       SectionTitle(title: "Offline Downloads"),
//                       CourseRow(
//                         courses: _recommendedCourses,
//                         buttonText: "Download",
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
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
                            _recommendedCourses, // Keep this as is or modify based on your offline download logic
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
