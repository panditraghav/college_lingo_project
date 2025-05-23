import 'package:flutter/material.dart';
import 'Appdrawer.dart';

class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  final List<Map<String, dynamic>> testCategories = const [
    {'title': 'Multiple Choice', 'icon': Icons.check_circle_outline},
    {'title': 'Fill in the Blanks', 'icon': Icons.edit_note},
    {'title': 'Listen & Translate', 'icon': Icons.hearing},
    {'title': 'Timed Quizzes', 'icon': Icons.timer},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
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
      backgroundColor: const Color(0xFFF9F9F9),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: testCategories.length,
        itemBuilder: (context, index) {
          final test = testCategories[index];
          return TestTile(
            title: test['title'],
            icon: test['icon'],
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PlaceholderTestPage(title: test['title']),
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
  final IconData icon;
  final VoidCallback onTap;

  const TestTile({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Icon(icon, size: 32, color: Colors.black87),
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

class PlaceholderTestPage extends StatelessWidget {
  final String title;

  const PlaceholderTestPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white), // white back arrow

        backgroundColor: Colors.black,
        title: Text(title, style: const TextStyle(color: Colors.white)),
      ),
      body: Center(
        child: Text(
          '$title Test Coming Soon!',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
