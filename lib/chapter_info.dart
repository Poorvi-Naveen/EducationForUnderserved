import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'courses_page.dart';
import 'models.dart'; // include updated models

class ChapterInfoPage extends StatelessWidget {
  final Course course;
  const ChapterInfoPage({super.key, required this.course});

  Future<List<Map<String, dynamic>>> fetchChaptersWithContent(String courseId) async {
    final chapterSnapshot = await FirebaseFirestore.instance
        .collection('Course')
        .doc(courseId)
        .collection('Chapter')
        .orderBy('order')
        .get();

    List<Map<String, dynamic>> chapterWidgets = [];

    for (final chapterDoc in chapterSnapshot.docs) {
      final chapterId = chapterDoc.id;
      final chapterData = chapterDoc.data();

      final contentDoc = await FirebaseFirestore.instance
          .collection('Course')
          .doc(courseId)
          .collection('Chapter')
          .doc(chapterId)
          .collection('chapterInfo')
          .doc('content')
          .get();

      if (!contentDoc.exists) continue;
      try{

      final contentData = contentDoc.data()!;
      final content = ChapterContent.fromMap(contentData);

      chapterWidgets.add({
        'chapterNumber': chapterData['order'] ?? 0,
        'chapterTitle': chapterData['title'] ?? '',
        'chapterOutcomes': content.outcomes,
        'topics': content.topics,
        'solvedExamples': content.solvedExamples,
      });}
      catch(e, stack){
        debugPrint("❌ ❌ Error fetching chapter content: $e\n$stack");
      }
    }

    return chapterWidgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 134, 243, 241),
      appBar: AppBar(title: Text(course.title)),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchChaptersWithContent(course.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final chapters = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: chapters.map((chapter) {
                return _buildChapter(
                  context: context,
                  course: course,
                  chapterNumber: chapter['chapterNumber'],
                  chapterTitle: chapter['chapterTitle'],
                  chapterOutcomes: chapter['chapterOutcomes'] is List
                      ? List<String>.from(chapter['chapterOutcomes'])
                      : [],
                  topics: chapter['topics'] is List
                      ? (chapter['topics'] as List)
                          .map<Topic>((e) => e is Topic ? e : Topic.fromMap(e as Map<String, dynamic>))
                          .toList()
                      : [],
                  solvedExamples: chapter['solvedExamples'] is List
                      ? (chapter['solvedExamples'] as List)
                          .map<QuestionAnswer>((e) => e is QuestionAnswer ? e : QuestionAnswer.fromMap(e as Map<String, dynamic>))
                          .toList()
                      : [],
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildChapter({
    required BuildContext context,
    required Course course,
    required int chapterNumber,
    required String chapterTitle,
    required List<String> chapterOutcomes,
    required List<Topic> topics,
    required List<QuestionAnswer> solvedExamples,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Chapter $chapterNumber',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            const SizedBox(height: 8),
            Text(
              chapterTitle,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),

            const Text('What you\'ll learn in this chapter?',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green)),
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: chapterOutcomes
                  .map((outcome) => Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Text('★ $outcome'),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 16),

            const Text('Topics', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.teal)),
            const SizedBox(height: 8),
            ...topics.map((topic) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(topic.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    ...topic.explanation.map((line) => Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("🔹", style: TextStyle(fontSize: 16)),
                            Expanded(child: Text(line)),
                          ],
                        )),
                    if (topic.table != null) _buildTable(topic.table!),
                    const SizedBox(height: 12),
                  ],
                )),

            const Text('Solved Examples',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.orange)),
            const SizedBox(height: 8),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: solvedExamples.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) => _buildSolvedExample(solvedExamples[index]),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (innerContext) => CourseRoadmapPage(course: course)),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
              child: const Text('Continue to Lesson', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTable(TableData table) {
    if (table.headers.isEmpty || table.rows.isEmpty) {
        return const SizedBox(); // or Text('Table data not available')
    }
    return Table(
      border: TableBorder.all(),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        TableRow(
          decoration: const BoxDecoration(color: Color(0xFFE0F7FA)),
          children: table.headers
              .map((header) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(header, style: const TextStyle(fontWeight: FontWeight.bold)),
                  ))
              .toList(),
        ),
        ...table.rows.map((row) {
          return TableRow(
            children: table.headers.map((header) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(row[header] ?? ''),
              );
            }).toList(),
          );
        }),
      ],
    );
  }

  Widget _buildSolvedExample(QuestionAnswer example) {
    return Card(
      color: const Color(0xFFFFF8E1),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Q: ${example.question}', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text('A: ${example.answer}'),
          ],
        ),
      ),
    );
  }
}
