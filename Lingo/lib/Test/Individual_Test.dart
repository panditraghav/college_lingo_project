import 'package:flutter/material.dart';
import 'package:lingo/Report/ResultScreen.dart';
import 'package:lingo/models/test.dart';
import 'package:lingo/services/api_service.dart';
import 'package:logger/logger.dart';

class IndividualTest extends StatefulWidget {
  final String testId;

  const IndividualTest({super.key, required this.testId});

  @override
  _IndividualTestState createState() => _IndividualTestState();
}

class _IndividualTestState extends State<IndividualTest> {
  final logger = Logger();
  final _apiService = ApiService();

  int currentQuestionIndex = 0;
  String currentQuestionId = "";
  bool isLoading = true;
  bool isError = false;
  TestModel? test;
  Map<String, int?> answers = {}; // Map<QuestionId, optionIndex>

  @override
  void initState() {
    super.initState();
    _fetchTest();
  }

  Future _fetchTest() async {
    try {
      final t = await _apiService.getSingleTest(widget.testId);
      setState(() {
        test = t;
        test?.questions?.forEach((question) {
          final id = question.sId;
          if (id != null) {
            answers[id] = null;
          }
        });

        currentQuestionId = test?.questions?[currentQuestionIndex].sId ?? "";

        isLoading = false;
      });
    } catch (e) {
      logger.e(e);
      setState(() {
        isError = true;
      });
    }
  }

  void _prevQuestion() {
    if (currentQuestionIndex > 0) {
      setState(() {
        currentQuestionIndex--;
        currentQuestionId = test?.questions?[currentQuestionIndex].sId ?? "";
      });
    }
  }

  void _nextQuestion() {
    if (answers[currentQuestionId] == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Please select an option!!")));
      return;
    }
    if (currentQuestionIndex < test!.questions!.length - 1) {
      setState(() {
        currentQuestionIndex++;
        currentQuestionId = test?.questions?[currentQuestionIndex].sId ?? "";
      });
    }
  }

  Future _submitTest() async {
    if (answers[currentQuestionId] == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Please select an option!!")));
      return;
    }

    List<Answer> ans = [];
    test?.questions?.forEach((question) {
      final ansOptionIndex = answers[question.sId] ?? 0;
      final Answer ansForThisQuestion = Answer(
        questionId: question.sId,
        selectedAnswer: question.options?[ansOptionIndex],
      );
      ans.add(ansForThisQuestion);
    });
    try {
      await _apiService.submitTest(widget.testId, ans);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Test submitted successfully!")));
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) {
            return ResultScreen(testId: widget.testId);
          },
        ),
      );
    } catch (e) {
      logger.e(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Some error occured while submitting")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final questions = test?.questions;
    final bool isLastQuestion =
        currentQuestionIndex == (questions?.length ?? 0) - 1;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          test?.title ?? "",
          style: const TextStyle(color: Colors.cyanAccent),
        ),
        centerTitle: true,
      ),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Q${currentQuestionIndex + 1}: ${questions?[currentQuestionIndex].questionText ?? ""}',
                      style: const TextStyle(
                        color: Colors.cyanAccent,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ...List.generate(
                      questions?[currentQuestionIndex].options?.length ?? 4,
                      (index) {
                        final currentQuestion =
                            questions?[currentQuestionIndex];
                        return RadioListTile<int>(
                          activeColor: Colors.cyanAccent,
                          title: Text(
                            currentQuestion?.options?[index] ?? "",
                            style: const TextStyle(color: Colors.white),
                          ),
                          value: index,
                          groupValue: answers[currentQuestion?.sId],
                          onChanged: (value) {
                            setState(() {
                              final id = currentQuestion?.sId!;
                              if (id != null) {
                                answers[id] = value;
                              }
                            });
                          },
                        );
                      },
                    ),
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
                          onPressed:
                              isLastQuestion ? _submitTest : _nextQuestion,
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
