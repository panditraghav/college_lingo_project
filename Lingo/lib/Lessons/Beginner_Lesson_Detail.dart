import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class BeginnerLessonDetail extends StatelessWidget {
  final String lessonTitle;

  const BeginnerLessonDetail({super.key, required this.lessonTitle});

  // Simulated backend data
  Future<Map<String, String>> fetchLessonDetails(String title) async {
    await Future.delayed(const Duration(seconds: 2)); // Simulate network delay

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

  Future<Uint8List> _generatePdf(String title, String description) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build:
            (pw.Context context) => pw.Padding(
              padding: const pw.EdgeInsets.all(24.0),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    title,
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 20),
                  pw.Text(description, style: const pw.TextStyle(fontSize: 16)),
                ],
              ),
            ),
      ),
    );
    return pdf.save();
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
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Builder(
              builder:
                  (context) => ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(
                        255,
                        0,
                        0,
                        0,
                      ), // Accent purple
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 5,
                    ),

                    onPressed: () async {
                      final lessonData = await fetchLessonDetails(lessonTitle);
                      final pdfData = await _generatePdf(
                        lessonData['title']!,
                        lessonData['description']!,
                      );

                      await Printing.layoutPdf(
                        onLayout: (PdfPageFormat format) async => pdfData,
                      );
                      Navigator.pop(context);
                    },
                    child: const Text('Save as PDF'),
                  ),
            ),
          ),
        ],
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
                crossAxisAlignment: CrossAxisAlignment.center,
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
