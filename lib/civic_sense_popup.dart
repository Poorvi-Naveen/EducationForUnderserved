import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(CivicSensePopup());
}

class CivicSensePopup extends StatelessWidget {
  const CivicSensePopup({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CivicSensePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CivicSensePage extends StatefulWidget {
  const CivicSensePage({super.key});

  @override
  State<CivicSensePage> createState() => _CivicSensePageState();
}

class _CivicSensePageState extends State<CivicSensePage>
    with SingleTickerProviderStateMixin {
  bool showOkButton = false;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  Map<String, dynamic>? contentData;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    fetchContent();
  }

  Future<void> fetchContent() async {
    final firestore = FirebaseFirestore.instance;
    final topicsSnapshot = await firestore.collection('civicSense').get();

    DocumentSnapshot? selectedTopic;
    QueryDocumentSnapshot? selectedCard;

    // Step 1: Loop through topics and find one with isDisplayed == false
    for (var topicDoc in topicsSnapshot.docs) {
      final contentSnapshot =
          await topicDoc.reference
              .collection('content')
              .where('isDisplayed', isEqualTo: false)
              .limit(1)
              .get();

      if (contentSnapshot.docs.isNotEmpty) {
        selectedTopic = topicDoc;
        selectedCard = contentSnapshot.docs.first;
        break;
      }
    }

    // Step 2: If all cards are viewed, reset isDisplayed = false for all
    if (selectedCard == null) {
      for (var topicDoc in topicsSnapshot.docs) {
        final contentSnapshot =
            await topicDoc.reference.collection('content').get();
        for (var doc in contentSnapshot.docs) {
          await doc.reference.update({'isDisplayed': false});
        }
      }

      // Re-fetch after reset
      await fetchContent();
      return;
    }

    // Step 3: Load content
    setState(() {
      contentData = {
        'topicId': selectedTopic!.id.replaceAll('_', ' ').toUpperCase(),
        'valueSummary': selectedTopic['valueSummary'],
        'yourSuperPower': selectedTopic['yourSuperpower'],
        ...selectedCard!.data() as Map<String, dynamic>,
        'ref': selectedCard.reference,
      };
    });

    Timer(Duration(seconds: 30), () async {
      setState(() => showOkButton = true);
      _controller.forward();

      // Mark card as viewed
      await contentData!['ref'].update({'isDisplayed': true});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop() async => showOkButton;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: showOkButton,
      child: Scaffold(
        backgroundColor: Colors.purple.shade50,
        appBar: AppBar(
          backgroundColor: Colors.purple.shade700,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Center(
            child: Text(
              'CIVIC SENSE',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ),
        body:
            contentData == null
                ? Center(child: CircularProgressIndicator())
                : Center(
                  child: Card(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 32,
                        horizontal: 20,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Column(
                                children: [
                                  Text(
                                    contentData!['topicId'],
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.purple.shade700,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                  SizedBox(height: 12),
                                  Text(
                                    "Your Superpower: ${contentData!['yourSuperPower']}",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    contentData!['valueSummary'],
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey.shade800,
                                      fontStyle: FontStyle.italic,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 20),
                                  Image.network(
                                    contentData!['imageUrl'],
                                    width: double.infinity,
                                    height: 180,
                                    fit: BoxFit.cover,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 24),

                            // Real Life Examples
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Real-Life Examples',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            ...List.generate(
                              (contentData!['realLifeExamples'] as List).length,
                              (index) {
                                final item =
                                    contentData!['realLifeExamples'][index];
                                return ListTile(
                                  leading: Icon(
                                    Icons.lightbulb,
                                    color: Colors.purple,
                                  ),
                                  title: Text(item['title']),
                                  subtitle: Text(item['example']),
                                );
                              },
                            ),

                            SizedBox(height: 20),

                            // Overcoming Challenges
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Overcoming Challenges',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            ...List.generate(
                              (contentData!['overcomingChallenges'] as List)
                                  .length,
                              (index) {
                                final item =
                                    contentData!['overcomingChallenges'][index];
                                return ListTile(
                                  leading: Icon(
                                    Icons.shield,
                                    color: Colors.teal,
                                  ),
                                  title: Text(item['title']),
                                  subtitle: Text(item['strategy']),
                                );
                              },
                            ),

                            SizedBox(height: 30),

                            if (showOkButton)
                              FadeTransition(
                                opacity: _fadeAnimation,
                                child: SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed:
                                        () => Navigator.of(context).pop(true),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.purple.shade700,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                    ),
                                    child: Text(
                                      'OK',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                        letterSpacing: 1.1,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            if (!showOkButton)
                              Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: Text(
                                  'Please read the content. The OK button will appear soon.',
                                  style: TextStyle(
                                    color: Colors.purple.shade400,
                                    fontStyle: FontStyle.italic,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
      ),
    );
  }
}
