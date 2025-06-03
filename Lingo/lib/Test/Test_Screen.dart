import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lingo/Test/Individual_Test.dart';
import 'dart:convert';
import '../Home/Appdrawer.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  List<String> testTitles = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTests();
  }

  Future<void> _fetchTests() async {
    try {
      final response = await http.get(
        Uri.parse('https://your-api-endpoint.com/tests'),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          testTitles = List<String>.from(data.map((e) => e['title']));
          isLoading = false;
        });
      } else {
        throw Exception("Failed to load tests");
      }
    } catch (e) {
      debugPrint("Error fetching tests: $e");
      setState(() {
        isLoading = false;
        testTitles = ["Noun", "Pronoun", "Adjective", "Verb"]; // Fallback
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text(
          'Test',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: Builder(
          builder:
              (context) => IconButton(
                icon: const Icon(Icons.menu, color: Colors.white),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
        ),
      ),
      drawer: const AppDrawer(),
      body:
          isLoading
              ? const Center(
                child: CircularProgressIndicator(color: Colors.cyanAccent),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: testTitles.length,
                itemBuilder: (context, index) {
                  return TestTile(
                    title: testTitles[index],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) =>
                                  IndividualTest(testTitle: testTitles[index]),
                        ),
                      );
                    },
                  );
                },
              ),
    );
  }
}

class TestTile extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const TestTile({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: const Icon(Icons.quiz, size: 32, color: Colors.black87),
        title: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}
