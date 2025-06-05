import 'package:flutter/material.dart';
import 'package:lingo/Lessons/lesson_list.dart';
import 'package:lingo/services/api_service.dart';
import '../Home/Appdrawer.dart';

class LessonOverviewScreen extends StatelessWidget {
  LessonOverviewScreen({super.key});
  final _apiService = ApiService();

  // Make levels static const so it can be initialized here
  static const List<Map<String, String>> levels = [
    {
      'name': 'Beginner',
      'image':
          'https://images.unsplash.com/photo-1607746882042-944635dfe10e?auto=format&fit=crop&w=800&q=80',
    },
    {
      'name': 'Intermediate',
      'image':
          'https://images.unsplash.com/photo-1519389950473-47ba0277781c?auto=format&fit=crop&w=800&q=80',
    },
    {
      'name': 'Expert',
      'image':
          'https://images.unsplash.com/photo-1531123897727-8f129e1688ce?auto=format&fit=crop&w=800&q=80',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Choose Your Level',
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
      backgroundColor: Colors.black,
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: levels.length,
        itemBuilder: (context, index) {
          final level = levels[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: LevelTile(
              level: level['name']!,
              imageUrl: level['image']!,
              onTap: () {
                if (level['name'] == 'Beginner') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => LessonsListScreen(
                            title: "${level['name']} Lessons",
                            future: _apiService.getBeginnerLessons,
                          ),
                    ),
                  );
                } else if (level['name'] == 'Intermediate') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => LessonsListScreen(
                            title: "${level['name']} Lessons",
                            future: _apiService.getIntermediateLessons,
                          ),
                    ),
                  );
                } else if (level['name'] == 'Expert') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => LessonsListScreen(
                            title: "${level['name']} Lessons",
                            future: _apiService.getAdvancedLessons,
                          ),
                    ),
                  );
                }
              },
            ), // <-- Added missing closing parenthesis here
          );
        },
      ),
    );
  }
}

class LevelTile extends StatelessWidget {
  final String level;
  final String imageUrl;
  final VoidCallback onTap;

  const LevelTile({
    super.key,
    required this.level,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.5),
              BlendMode.darken,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.cyanAccent.withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 1,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Center(
          child: Text(
            level,
            style: const TextStyle(
              fontSize: 26,
              color: Colors.cyanAccent,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
              shadows: [
                Shadow(
                  blurRadius: 6,
                  color: Colors.black,
                  offset: Offset(1, 1),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
