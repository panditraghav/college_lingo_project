import 'package:flutter/material.dart';
import 'package:lingo/Lessons/Beginner_Lesson_Detail.dart';

class BeginnerLessonsScreen extends StatelessWidget {
  const BeginnerLessonsScreen({super.key});

  final List<Map<String, dynamic>> beginnerLessons = const [
    {
      'title': 'Basic Greetings',
      'description': 'Learn how to say hello, goodbye, and introduce yourself.',
      'completed': true,
    },
    {
      'title': 'Common Phrases',
      'description': 'Essential phrases used in everyday conversation.',
      'completed': false,
    },
    {
      'title': 'Numbers & Counting',
      'description': 'Learn to count and use numbers in sentences.',
      'completed': true,
    },
    {
      'title': 'Family & Friends',
      'description': 'Talk about your family and make friends.',
      'completed': false,
    },
    {
      'title': 'Daily Activities',
      'description': 'Describe your routine and daily habits.',
      'completed': false,
    },
    {
      'title': 'Simple Questions',
      'description': 'Ask and answer basic questions correctly.',
      'completed': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        title: const Text(
          'Beginner Lessons',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: beginnerLessons.length,
        itemBuilder: (context, index) {
          final lesson = beginnerLessons[index];
          final bool isCompleted = lesson['completed'];

          return Card(
            color: Colors.grey[900],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 4,
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      lesson['title'],
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.cyanAccent,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isCompleted ? Colors.green : Colors.orange,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      isCompleted ? 'Completed' : 'Not Attempted',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  lesson['description'],
                  style: const TextStyle(fontSize: 16, color: Colors.white70),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) =>
                            BeginnerLessonDetail(lessonTitle: lesson['title']),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
