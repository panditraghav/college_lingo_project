import 'package:flutter/material.dart';
import 'package:lingo/Lessons/Expert_Lesson_Detail.dart';

class ExpertLessonsScreen extends StatelessWidget {
  const ExpertLessonsScreen({super.key});

  final List<Map<String, String>> expertLessons = const [
    {
      'title': 'Advanced Grammar',
      'description': 'Master complex grammar rules and sentence structures.',
    },
    {
      'title': 'Idioms & Expressions',
      'description': 'Learn common idioms and how to use them naturally.',
    },
    {
      'title': 'Formal Writing',
      'description': 'Techniques for writing reports, emails, and essays.',
    },
    {
      'title': 'Debate & Discussion',
      'description': 'Improve your skills in arguing and discussing topics.',
    },
    {
      'title': 'Pronunciation & Accent',
      'description': 'Practice refining your accent and pronunciation.',
    },
    {
      'title': 'Business English',
      'description': 'Learn vocabulary and phrases for the business world.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Expert Lessons',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: expertLessons.length,
        itemBuilder: (context, index) {
          final lesson = expertLessons[index];
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
                        (_) =>
                            ExpertLessonDetail(lessonTitle: lesson['title']!),
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
