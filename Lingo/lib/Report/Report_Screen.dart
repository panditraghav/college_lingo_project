import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lingo/models/ReportModel.dart';
import 'package:lingo/Report/ResultScreen.dart';
import 'package:lingo/services/api_service.dart';
import 'package:logger/logger.dart';

class ReportScreen extends StatefulWidget {
  ReportScreen({super.key});
  final _apiService = ApiService();

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  late Future<List<TestReports>> futureTestResults;
  final _logger = Logger();

  @override
  void initState() {
    super.initState();
    futureTestResults = fetchTestResultsFromBackend();
  }

  Future<List<TestReports>> fetchTestResultsFromBackend() async {
    ReportModel reportModel = await widget._apiService.getReport();
    return reportModel.testReports ?? [];
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
      body: FutureBuilder<List<TestReports>>(
        future: futureTestResults,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.cyanAccent),
            );
          } else if (snapshot.hasError) {
            final error = snapshot.error;
            if (error is DioException) {
              if (error.response?.statusCode == 404) {
                return const Center(
                  child: Text(
                    "No test attempted",
                    style: TextStyle(color: Colors.white70),
                  ),
                );
              }
            }
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
              final formattedDate = DateFormat(
                'dd MMM yyyy, hh:mm a',
              ).format(DateTime.parse(test.attemptedAt ?? '').toLocal());

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
                        builder: (_) => ResultScreen(testId: test.sId ?? ''),
                      ),
                    ).then((_) {
                      setState(() {
                        futureTestResults = fetchTestResultsFromBackend();
                      });
                    });
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
                          test.testTitle ?? '',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          'Score: ${test.score ?? 0}',
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
                              'Attempted At: $formattedDate',
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
