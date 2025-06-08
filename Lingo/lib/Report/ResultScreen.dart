import 'package:flutter/material.dart';
import 'package:lingo/services/api_service.dart';

class ResultScreen extends StatefulWidget {
  final String testId;

  const ResultScreen({super.key, required this.testId});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  final _apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _apiService.getTestResult(widget.testId),
      builder: (context, asyncSnapshot) {
        if (!asyncSnapshot.hasData) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (asyncSnapshot.hasError) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: Text(
                "Unable to fetch data",
                style: TextStyle(fontSize: 18),
              ),
            ),
          );
        }

        final testResult = asyncSnapshot.data;
        final questions = testResult?.questions;

        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            title: Text(
              testResult?.testTitle ?? 'Test',
              style: const TextStyle(color: Colors.cyanAccent),
            ),
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Your Score',
                  style: const TextStyle(fontSize: 24, color: Colors.white),
                ),
                const SizedBox(height: 10),
                Text(
                  "${testResult?.correctAnswers ?? ''} / ${testResult?.totalQuestions ?? ''}",
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.cyanAccent,
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: questions?.length ?? 0,
                    itemBuilder: (context, index) {
                      final result = questions?[index];
                      final isCorrect = result?.isCorrect ?? false;
                      return Card(
                        color: Colors.grey[900],
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          title: Text(
                            result?.questionText ?? "",
                            style: const TextStyle(color: Colors.white),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Your Answer: ${result?.selectedAnswer ?? ''}",
                                style: TextStyle(
                                  color: isCorrect ? Colors.green : Colors.red,
                                ),
                              ),
                              Text(
                                "Correct Answer: ${result?.correctAnswer ?? ''}",
                                style: const TextStyle(
                                  color: Colors.cyanAccent,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyanAccent,
                    foregroundColor: Colors.black,
                  ),
                  child: const Text("Back to home"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
