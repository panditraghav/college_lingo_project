import 'package:flutter/material.dart';

class IntermediateLessonDetail extends StatelessWidget {
  final String lessonTitle;

  const IntermediateLessonDetail({super.key, required this.lessonTitle});

  // Simulated backend data (hardcoded for now)
  Future<Map<String, String>> fetchLessonDetails(String title) async {
    await Future.delayed(const Duration(seconds: 2)); // Simulate network delay

    // Simulated response from backend based on lesson title
    Map<String, String> data = {
      'Basic Greetings':
          'Learn how to say hello, goodbye, and introduce yourself.',
      'Common Phrases': 'Essential phrases used in everyday conversation.',
      'Numbers & Counting': 'Learn to count and use numbers in sentences.',
      'Family & Friends': 'Talk about your family and make friends.',
      'Daily Activities': 'Describe your routine and daily habits.',
      'Simple Questions': 'Ask and answer basic questions correctly.',
    };

    return {
      'title': title,
      'description': data[title] ?? 'Study material not found.',
    };
  }

  Future<void> markLessonAsCompleted(String title) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate API
    print('$title marked as completed');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        title: Text(
          lessonTitle,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder<Map<String, String>>(
        future: fetchLessonDetails(lessonTitle),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.cyanAccent),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Failed to load data',
                style: TextStyle(color: Colors.red),
              ),
            );
          } else {
            final lessonData = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lessonData['title']!,
                    style: const TextStyle(
                      color: Colors.cyanAccent,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    lessonData['description']!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyanAccent,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () async {
                      await markLessonAsCompleted(lessonTitle);
                      Navigator.pop(context); // or any other action
                    },
                    icon: const Icon(Icons.done),
                    label: const Text('Done', style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
