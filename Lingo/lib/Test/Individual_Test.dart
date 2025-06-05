import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:lingo/Report/ResultScreen.dart';

class IndividualTest extends StatefulWidget {
  final String testTitle;

  const IndividualTest({super.key, required this.testTitle});

  @override
  _IndividualTestState createState() => _IndividualTestState();
}

class _IndividualTestState extends State<IndividualTest> {
  int currentIndex = 0;
  int? selectedOption;
  List<int?> answers = [];
  bool isLoading = true;

  List<Map<String, dynamic>> questions = [];

  @override
  @override
  void initState() {
    super.initState();
    _fetchQuestionsFromBackend();
  }

  Future<void> _fetchQuestionsFromBackend() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://your-api-endpoint.com/questions?test=${Uri.encodeComponent(widget.testTitle)}',
        ),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          questions =
              data.map<Map<String, dynamic>>((q) {
                return {
                  'question': q['question'],
                  'options': List<String>.from(q['options']),
                };
              }).toList();
          answers = List.filled(questions.length, null);
        } else {
          _useMockData();
        }
      } else {
        _useMockData();
      }
    } catch (e) {
      debugPrint('Failed to fetch questions: $e');
      _useMockData();
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _useMockData() {
    questions = [
      {
        'question': 'Which of these is a noun?',
        'options': ['Quickly', 'Beautiful', 'Apple', 'Run'],
      },
      {
        'question': 'Identify the pronoun:',
        'options': ['She', 'Happy', 'Green', 'Play'],
      },
      {
        'question': 'Select the adjective:',
        'options': ['Cat', 'Fast', 'Jump', 'Him'],
      },
    ];
    answers = List.filled(questions.length, null);
  }

  void _nextQuestion() async {
    if (selectedOption != null) {
      answers[currentIndex] = selectedOption;

      if (currentIndex < questions.length - 1) {
        setState(() {
          currentIndex++;
          selectedOption = answers[currentIndex];
        });
      } else {
        // POST answers
        try {
          final response = await http.post(
            Uri.parse('https://your-api-endpoint.com/submit-answers'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'test': widget.testTitle, 'answers': answers}),
          );

          if (response.statusCode == 200) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ResultScreen(testTitle: widget.testTitle),
              ),
            );
          } else {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Submission failed')));
          }
        } catch (e) {
          debugPrint('Submission error: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error submitting answers')),
          );
        }
      }
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select an option')));
    }
  }

  void _prevQuestion() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
        selectedOption = answers[currentIndex];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isLastQuestion = currentIndex == questions.length - 1;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          widget.testTitle,
          style: const TextStyle(color: Colors.cyanAccent),
        ),
        centerTitle: true,
      ),
      body:
          isLoading
              ? const Center(
                child: CircularProgressIndicator(color: Colors.cyanAccent),
              )
              : Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Q${currentIndex + 1}: ${questions[currentIndex]['question']}',
                      style: const TextStyle(
                        color: Colors.cyanAccent,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ...List.generate(4, (index) {
                      return RadioListTile<int>(
                        activeColor: Colors.cyanAccent,
                        title: Text(
                          questions[currentIndex]['options'][index],
                          style: const TextStyle(color: Colors.white),
                        ),
                        value: index,
                        groupValue: selectedOption,
                        onChanged: (value) {
                          setState(() {
                            selectedOption = value;
                          });
                        },
                      );
                    }),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: _prevQuestion,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[800],
                            foregroundColor: Colors.cyanAccent,
                          ),
                          child: const Text('Previous'),
                        ),
                        ElevatedButton(
                          onPressed: _nextQuestion,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.cyanAccent,
                            foregroundColor: Colors.black,
                          ),
                          child: Text(isLastQuestion ? 'Submit' : 'Next'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
    );
  }
}
