import 'package:flutter/material.dart';
import 'package:lingo/Report/ResultScreen.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  late Future<List<Map<String, dynamic>>> futureTestResults;

  @override
  void initState() {
    super.initState();
    futureTestResults = fetchTestResultsFromBackend();
  }

  // Mock backend call – replace this with real HTTP call
  Future<List<Map<String, dynamic>>> fetchTestResultsFromBackend() async {
    await Future.delayed(const Duration(seconds: 2)); // Simulate network delay

    // This data should come from your backend
    return [
      {
        'title': 'Noun Test',
        'score': '8 / 10',
        'details': 'Correct: 8\nWrong: 2',
      },
      {
        'title': 'Pronoun Test',
        'score': '7 / 10',
        'details': 'Correct: 7\nWrong: 3',
      },
      {
        'title': 'Adjective Test',
        'score': '9 / 10',
        'details': 'Correct: 9\nWrong: 1s',
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        title: const Text(
          "Test Report",
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        backgroundColor: const Color(0xFF1A1A1A),
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: futureTestResults,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.cyanAccent),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text(
                "Failed to load data",
                style: TextStyle(color: Colors.white70),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "No test data available",
                style: TextStyle(color: Colors.white70),
              ),
            );
          }

          final testResults = snapshot.data!;

          return ListView.builder(
            itemCount: testResults.length,
            itemBuilder: (context, index) {
              final test = testResults[index];
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 6.0,
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ResultScreen(testTitle: test['title']),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6A1B9A), Color(0xFF00BFA5)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        dividerColor: Colors.transparent,
                        unselectedWidgetColor: Colors.white70,
                        colorScheme: ColorScheme.dark(),
                      ),
                      child: ExpansionTile(
                        collapsedIconColor: Colors.white70,
                        iconColor: Colors.white,
                        title: Text(
                          test['title'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          'Score: ${test['score']}',
                          style: const TextStyle(color: Colors.white70),
                        ),
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20.0),
                            decoration: const BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(12),
                              ),
                            ),
                            child: Text(
                              test['details'],
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
