import 'package:flutter/material.dart';
import 'package:lingo/AI_Tutor.dart';
import 'package:lingo/AuthScreen.dart';
import 'package:lingo/Lesson_Screen.dart';
import 'package:lingo/Logout_Screen.dart';
import 'package:lingo/Test_Screen.dart';
import 'package:lingo/homescreen.dart';
import 'package:lingo/profile.dart';
import 'package:lingo/splashScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/home': (context) => const HomeScreen(),
        '/ai_tutor': (context) => const AITutorScreen(),
        '/lesson': (context) => const LessonOverviewScreen(),
        '/test': (context) => const TestScreen(),
        '/logout': (context) => Logout(),
        '/profile': (context) => ProfileScreen(),
      },
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const HomeScreen(),
    );
  }
}
