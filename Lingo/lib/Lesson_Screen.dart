import 'package:flutter/material.dart';
//import 'package:lingo_ai_tutor/screens/app_drawer.dart';
import 'Appdrawer.dart';

class LessonOverviewScreen extends StatelessWidget {
  const LessonOverviewScreen({super.key});

  final List<Map<String, String>> languages = const [
    {
      'name': 'English',
      'image':
          'https://as2.ftcdn.net/jpg/03/76/45/97/1000_F_376459739_8lzfBcF7Z2Ol30BmOq4xXP34u69oRM0P.jpg',
    },
    {
      'name': 'Hindi',
      'image':
          'https://sdmntprwestus2.oaiusercontent.com/files/00000000-f194-61f8-a94d-96df1ecfcb8e/raw?se=2025-04-30T23%3A50%3A55Z&sp=r&sv=2024-08-04&sr=b&scid=a3fe876d-71b9-5d09-b5d6-c9d32da5dc68&skoid=d958ec58-d47c-4d2f-a9f2-7f3e03fdcf72&sktid=a48cca56-e6da-484e-a814-9c849652bcb3&skt=2025-04-30T04%3A45%3A12Z&ske=2025-05-01T04%3A45%3A12Z&sks=b&skv=2024-08-04&sig=37%2BazMQARybSzWZ2wElvcq824lvhQYiUOOodZ9YxASs%3D',
    },
    {
      'name': 'Spanish',
      'image':
          'https://www.shutterstock.com/image-vector/espanol-translation-spanish-language-hand-260nw-1260509062.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Lingo',
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
        itemCount: languages.length,
        itemBuilder: (context, index) {
          final language = languages[index];
          return LanguageTile(
            language: language['name']!,
            imageUrl: language['image']!,
          );
        },
      ),
    );
  }
}

class LanguageTile extends StatelessWidget {
  final String language;
  final String imageUrl;

  const LanguageTile({
    super.key,
    required this.language,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [Colors.black54, Colors.transparent],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Text(
          language,
          style: const TextStyle(
            fontSize: 24,
            color: Colors.white,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                blurRadius: 4,
                color: Colors.black38,
                offset: Offset(1, 1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
