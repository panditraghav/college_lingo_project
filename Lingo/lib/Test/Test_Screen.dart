import 'package:flutter/material.dart';
import 'package:lingo/Test/Individual_Test.dart';
import 'package:lingo/services/api_service.dart';
import 'package:logger/logger.dart';
import '../Home/Appdrawer.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  final _apiService = ApiService();
  final logger = Logger();

  @override
  void initState() {
    super.initState();
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
      body: FutureBuilder(
        future: _apiService.getTestsWithStatus(),
        builder: (context, asyncSnapshot) {
          final data = asyncSnapshot.data;
          final tests = data?.tests;
          if (!asyncSnapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          if (asyncSnapshot.hasError) {
            return Center(
              child: Text(
                "Unable to get tests",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            );
          }
          if (!(data?.success ?? false)) {
            return Center(
              child: Text(
                "Unable to get tests",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: tests?.length ?? 0,
            itemBuilder: (context, index) {
              return TestTile(
                title: tests?.elementAt(index).title ?? "",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => IndividualTest(
                            testTitle: tests?.elementAt(index).title ?? "",
                          ),
                    ),
                  );
                },
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
