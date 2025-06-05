import 'package:flutter/material.dart';
import 'package:lingo/Lessons/Intermediate_Lesson_Detail.dart';

class IntermediateLessonsScreen extends StatelessWidget {
  const IntermediateLessonsScreen({super.key});

  final List<Map<String, String>> intermediateLessons = const [
    {
      'title': 'Past Tense Verbs',
      'description': 'Learn how to use past tense in different verbs.',
    },
    {
      'title': 'Modal Verbs',
      'description': 'Understand can, could, may, might and their uses.',
    },
    {
      'title': 'Making Requests',
      'description': 'How to politely ask for things or favors.',
    },
    {
      'title': 'Giving Directions',
      'description': 'Describe routes and locations clearly.',
    },
    {
      'title': 'Talking about Experiences',
      'description': 'Discuss past experiences and stories.',
    },
    {
      'title': 'Expressing Opinions',
      'description': 'Learn to state your opinions and agree/disagree.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Intermediate Lessons',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: intermediateLessons.length,
        itemBuilder: (context, index) {
          final lesson = intermediateLessons[index];
          return Card(
            color: Colors.grey[900],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 4,
            child: ListTile(
              title: Text(
                lesson['title']!,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.cyanAccent,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  lesson['description']!,
                  style: const TextStyle(fontSize: 16, color: Colors.white70),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => IntermediateLessonDetail(
                          lessonTitle: lesson['title']!,
                        ),
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
