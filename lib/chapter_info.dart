import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'courses_page.dart';
import 'models.dart';

class RatioProportionPage extends StatelessWidget {
  final Course course;
  const RatioProportionPage({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 134, 243, 241),
      appBar: AppBar(title: const Text('Ratio & Proportion')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildChapter(
              context: context, // Pass the context here
              course: course,
              chapterNumber: 1,
              chapterTitle: 'Understanding Proportions',
              chapterOutcomes: [
                'You will be able to define a proportion and recognize it as the equality of two ratios 1.',
                'You will be able to identify and use the different notations for expressing proportions (a:b :: c:d and a/b = c/d) 1.',
              ],
              explanation:
                  'This chapter introduces the idea that a proportion is simply when two ratios are equal to each other. Think of it like saying one comparison is the same as another comparison. \nFor example, if you are mixing juice and you use 1 cup of concentrate for every 3 cups of water, the ratio is 1:3. \nIf you want to make a larger batch and use 2 cups of concentrate for every 6 cups of water, the ratio is 2:6. Since 1:3 is the same as 2:6 (because 2 is double of 1, and 6 is double of 3), these two ratios form a proportion.\n\n\nWe use different ways to write proportions. One way is using a double colon, like this: 1:3 :: 2:6. This is read as "1 is to 3 as 2 is to 6". Another common way is using an equals sign, like this: 1/3 = 2/6. Both mean the same thing - the two ratios are equal 1.',
              solvedExamples: [
                const QuestionAnswer(
                  question: 'Are the ratios 3:5 and 6:10 in proportion?',
                  answer:
                      'To check if they are in proportion, we can see if the fractions are equal: 3/5 and 6/10. If we simplify 6/10 by dividing both the numerator and the denominator by 2, we get 3/5. Since 3/5 = 3/5, the ratios 3:5 and 6:10 are in proportion.',
                ),
                const QuestionAnswer(
                  question: 'Write a proportion using the ratios 2:7 and 4:14.',
                  answer:
                      'Since 4 is double of 2, and 14 is double of 7, the ratio 2:7 is equivalent to 4:14. We can write this proportion as 2:7 :: 4:14 or 2/7 = 4/14.',
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildChapter(
              context: context, // Pass the context here
              course: course,
              chapterNumber: 2,
              chapterTitle: 'Cross-Multiplication',
              chapterOutcomes: [
                'You will understand and be able to state the cross-multiplication property of proportions 6.',
                'You will be able to use the cross-multiplication property to find an unknown value in a proportion 6.',
              ],
              explanation:
                  'The cross-multiplication property is a handy shortcut for working with proportions. If we have a proportion like a/b = c/d, this property tells us that the product of the extremes (a and d) is equal to the product of the means (b and c).\n In other words, a * d = b * c 6.\n\n\nImagine you\'re baking cookies. The recipe says you need 2 eggs for every cup of flour. If you want to use 3 cups of flour, how many eggs do you need? \nWe can set up a proportion: 2 eggs / 1 cup flour = x eggs / 3 cups flour. Using cross-multiplication, we get 2 * 3 = 1 * x, so x = 6.\n You would need 6 eggs.',
              solvedExamples: [
                const QuestionAnswer(
                  question:
                      'Use cross-multiplication to find the value of x in the proportion 4:6 :: x:9.',
                  answer:
                      'We can write this as 4/6 = x/9. Using cross-multiplication, we get 4 * 9 = 6 * x, which simplifies to 36 = 6x. \nDividing both sides by 6, we find x = 6.',
                ),
                const QuestionAnswer(
                  question:
                      'Determine if the ratios 5:8 and 10:16 are in proportion using cross-multiplication.',
                  answer:
                      'We write the ratios as fractions: 5/8 and 10/16. Cross-multiplying gives us 5 * 16 = 80 and 8 * 10 = 80. \nSince both products are equal, the ratios are in proportion.',
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildChapter(
              context: context, // Pass the context here
              course: course,
              chapterNumber: 3,
              chapterTitle: 'Direct Proportion',
              chapterOutcomes: [
                'You will be able to define direct proportion and identify quantities that are directly proportional 1.',
                'You will be able to solve problems involving direct proportion 1.',
              ],
              explanation:
                  'Direct proportion means that as one quantity increases, the other quantity increases at the same rate, or if one decreases, the other decreases at the same rate.\n The ratio between the two quantities stays constant 1.\n\nThink about buying candy.\n If one candy bar costs \$2, then two candy bars will cost \$4, three will cost \$6, and so on.\n The number of candy bars and the total cost are in direct proportion because the cost increases directly with the number of bars you buy. The ratio of cost to the number of bars (which is \$2/1) remains the same.',
              solvedExamples: [
                const QuestionAnswer(
                  question:
                      'If 3 notebooks cost \$6, how much will 7 notebooks cost if the cost is in direct proportion to the number of notebooks?',
                  answer:
                      'Let the cost of 7 notebooks be x. We can set up a proportion: 3/6 = 7/x. Using cross-multiplication, we get 3 * x = 6 * 7, so 3x = 42. \nDividing both sides by 3, we find x = 14. Therefore, 7 notebooks will cost \$14.',
                ),
                const QuestionAnswer(
                  question:
                      'A car travels 100 km in 2 hours at a constant speed. How far will it travel in 5 hours?',
                  answer:
                      'Distance and time are in direct proportion when speed is constant. Let the distance traveled in 5 hours be \'d\'. We can write the proportion: 100 km / 2 hours = d km / 5 hours.\n Cross-multiplying gives 100 * 5 = 2 * d, so 500 = 2d. Dividing by 2, we get d = 250 km. The car will travel 250 km in 5 hours.',
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildChapter(
              context: context, // Pass the context here
              course: course,
              chapterNumber: 4,
              chapterTitle: 'The Unitary Method',
              chapterOutcomes: [
                'You will understand the concept of the unitary method 3.',
                'You will be able to apply the unitary method to solve problems involving direct proportion 3.',
              ],
              explanation:
                  'The unitary method is a way to solve problems involving direct proportion by first finding the value of a single unit 3.\n Once you know the value of one unit, you can easily find the value of any number of units by multiplying.\n\nLet\'s say you go to the store and find that 5 apples cost \$3. To find out how much 12 apples would cost, you can use the unitary method.\n First, find the cost of one apple: \$3 / 5 apples = \$0.60 per apple.\n Then, multiply this cost by the number of apples you want: \$0.60/apple * 12 apples = \$7.20. So, 12 apples would cost \$7.20.',
              solvedExamples: [
                const QuestionAnswer(
                  question:
                      'If 8 bananas cost \$4.80, find the cost of 15 bananas using the unitary method.',
                  answer:
                      'First, find the cost of one banana: \$4.80 / 8 bananas = \$0.60 per banana. Next, multiply the cost of one banana by 15: \$0.60/banana * 15 bananas = \$9.00. Therefore, 15 bananas will cost \$9.00.',
                ),
                const QuestionAnswer(
                  question:
                      'A machine can fill 120 bottles in 30 minutes. How many bottles can it fill in 2 hours using the unitary method?',
                  answer:
                      'First, we need to make sure the units of time are the same. 2 hours is equal to 2 * 60 = 120 minutes. Now, find the number of bottles filled in one minute: 120 bottles / 30 minutes = 4 bottles per minute. \nThen, multiply this by the total time in minutes: 4 bottles/minute * 120 minutes = 480 bottles. The machine can fill 480 bottles in 2 hours.',
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildChapter(
              context: context, // Pass the context here
              course: course,
              chapterNumber: 5,
              chapterTitle: 'Applying Ratios and Proportions',
              chapterOutcomes: [
                'You will be able to solve a variety of real-world problems using the concepts of ratio and proportion 1.',
                'You will be able to apply ratio and proportion in different contexts, such as maps, recipes, and sharing quantities 1.',
              ],
              explanation:
                  'This chapter focuses on using what you\'ve learned about ratios and proportions to solve problems you might encounter in everyday life. \nThis could involve anything from figuring out distances on a map using a scale, adjusting ingredient amounts in a recipe, or dividing a quantity of something fairly according to a given ratio 1.\n\nImagine a map with a scale of 1 cm representing 20 km. If the distance between two towns on the map is 4.5 cm, you can use proportion to find the actual distance: 1 cm / 20 km = 4.5 cm / x km. \nSolving for x will give you the real distance. Similarly, if a recipe for a cake that serves 6 people requires 3 cups of flour, you can use ratio and proportion to figure out how much flour you\'d need to bake a cake for 12 people.',
              solvedExamples: [
                const QuestionAnswer(
                  question:
                      'A map has a scale of 1 cm : 50 km. If two cities are 7 cm apart on the map, what is the actual distance between them?',
                  answer:
                      'We can set up the proportion: 1 cm / 50 km = 7 cm / x km.\nCross-multiplying gives 1 * x = 50 * 7, so x = 350 km. The actual distance between the cities is 350 km.',
                ),
                const QuestionAnswer(
                  question:
                      'Sarah wants to bake cookies using a recipe that calls for flour and sugar in a ratio of 3:2. If she uses 4.5 cups of flour, how many cups of sugar does she need?',
                  answer:
                      'The ratio of flour to sugar is 3:2, which means for every 3 parts of flour, there are 2 parts of sugar. We can set up the proportion:\n 3 cups flour / 2 cups sugar = 4.5 cups flour / x cups sugar. Cross-multiplying gives 3 * x = 2 * 4.5, so 3x = 9. Dividing both sides by 3, we get x = 3 cups of sugar. Sarah needs 3 cups of sugar.',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChapter({
    required BuildContext context, // Accept the BuildContext
    required Course course,
    required int chapterNumber,
    required String chapterTitle,
    required List<String> chapterOutcomes,
    required String explanation,
    required List<QuestionAnswer> solvedExamples,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Chapter $chapterNumber',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              chapterTitle,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            const Text(
              'What you\'ll learn in this chapter?',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 8),
            Text(explanation),
            const SizedBox(height: 16),
            const Text(
              'Solved Examples',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 8),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: solvedExamples.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) => solvedExamples[index],
            ),
            const SizedBox(height: 16),
            const Text(
              'Chapter Outcomes',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
                  chapterOutcomes
                      .map(
                        (outcome) => Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Text('- $outcome'),
                        ),
                      )
                      .toList(),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context, // Now 'context' is defined here
                  MaterialPageRoute(
                    builder:
                        (innerContext) => CourseRoadmapPage(course: course),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
              ),
              child: const Text(
                'Continue to Lesson',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class QuestionAnswer extends StatelessWidget {
  final String question;
  final String answer;

  const QuestionAnswer({
    super.key,
    required this.question,
    required this.answer,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Question: $question',
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 4),
        Text('Answer: $answer'),
      ],
    );
  }
}
