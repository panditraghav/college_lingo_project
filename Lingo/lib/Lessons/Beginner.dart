import 'package:flutter/material.dart';
import 'package:lingo/Lessons/Beginner_Lesson_Detail.dart';
import 'package:lingo/models/beginner_lessons.dart';
import 'package:lingo/services/api_service.dart';

class BeginnerLessonsScreen extends StatefulWidget {
  const BeginnerLessonsScreen({super.key});

  @override
  State<BeginnerLessonsScreen> createState() => _BeginnerLessonsScreenState();
}

class _BeginnerLessonsScreenState extends State<BeginnerLessonsScreen> {
  final _apiService = ApiService();
  final dynamic lessons = null;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

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
      body: FutureBuilder(
        future: _apiService.getBeginnerLessons(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          final lessons = snapshot.data?.beginnerLessons;
          if (lessons == null) {
            print("Lesson null");
            return CircularProgressIndicator();
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: lessons.length ?? 0,
            itemBuilder: (context, index) {
              final lesson = lessons[index];

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
                          lesson.title ?? "",
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
                          color:
                              lesson.status == "Completed"
                                  ? Colors.green
                                  : Colors.orange,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          lesson.status ?? "",
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
                      lesson.description ?? "",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => BeginnerLessonDetail(
                              lessonTitle: lesson.title ?? "",
                            ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
