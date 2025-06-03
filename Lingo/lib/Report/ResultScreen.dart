import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ResultScreen extends StatefulWidget {
  final String testTitle;

  const ResultScreen({super.key, required this.testTitle});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  bool isLoading = true;
  int correctAnswers = 0;
  int totalQuestions = 0;
  List<Map<String, dynamic>> questionResults = [];

  @override
  void initState() {
    super.initState();
    _fetchResult();
  }

  Future<void> _fetchResult() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://your-api-endpoint.com/result?test=${Uri.encodeComponent(widget.testTitle)}',
        ),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          correctAnswers = data['correctAnswers'];
          totalQuestions = data['totalQuestions'];
          questionResults = List<Map<String, dynamic>>.from(
            data['questionResults'],
          );
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load result');
      }
    } catch (e) {
      debugPrint('Result fetch error: $e');
      _useMockResult(); // fallback
    }
  }

  void _useMockResult() {
    correctAnswers = 8;
    totalQuestions = 10;
    questionResults = [
      {
        'question': 'Which is a noun?',
        'yourAnswer': 'Apple',
        'correctAnswer': 'Apple',
      },
      {
        'question': 'Identify the pronoun',
        'yourAnswer': 'She',
        'correctAnswer': 'She',
      },
      {
        'question': 'Which is an adjective?',
        'yourAnswer': 'Run',
        'correctAnswer': 'Fast',
      },
      {
        'question': 'Which is a verb?',
        'yourAnswer': 'Jump',
        'correctAnswer': 'Jump',
      },
      {
        'question': 'Which is a preposition?',
        'yourAnswer': 'Under',
        'correctAnswer': 'Under',
      },
      {
        'question': 'Identify the conjunction',
        'yourAnswer': 'And',
        'correctAnswer': 'And',
      },
      {
        'question': 'What is an article?',
        'yourAnswer': 'The',
        'correctAnswer': 'The',
      },
      {
        'question': 'Which is an adverb?',
        'yourAnswer': 'Quickly',
        'correctAnswer': 'Quickly',
      },
      {
        'question': 'Which is not a noun?',
        'yourAnswer': 'Green',
        'correctAnswer': 'Green',
      },
      {
        'question': 'Identify the interjection',
        'yourAnswer': 'Wow',
        'correctAnswer': 'Wow',
      },
    ];
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          "${widget.testTitle} - Result",
          style: const TextStyle(color: Colors.cyanAccent),
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body:
          isLoading
              ? const Center(
                child: CircularProgressIndicator(color: Colors.cyanAccent),
              )
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Your Score',
                      style: const TextStyle(fontSize: 24, color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '$correctAnswers / $totalQuestions',
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.cyanAccent,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: ListView.builder(
                        itemCount: questionResults.length,
                        itemBuilder: (context, index) {
                          final result = questionResults[index];
                          final isCorrect =
                              result['yourAnswer'] == result['correctAnswer'];
                          return Card(
                            color: Colors.grey[900],
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              title: Text(
                                result['question'],
                                style: const TextStyle(color: Colors.white),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Your Answer: ${result['yourAnswer']}",
                                    style: TextStyle(
                                      color:
                                          isCorrect ? Colors.green : Colors.red,
                                    ),
                                  ),
                                  Text(
                                    "Correct Answer: ${result['correctAnswer']}",
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
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.cyanAccent,
                        foregroundColor: Colors.black,
                      ),
                      child: const Text("Back to Home"),
                    ),
                  ],
                ),
              ),
    );
  }
}
