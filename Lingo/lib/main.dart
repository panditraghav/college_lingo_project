import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lingo/AI_Tutor.dart';
import 'package:lingo/Authentication/Login.dart';
import 'package:lingo/Authentication/Sign_in.dart';
import 'package:lingo/Lessons/Lesson_Screen.dart';
import 'package:lingo/Authentication/Logout_Screen.dart';
import 'package:lingo/Test/PreTest_Screen.dart';
import 'package:lingo/Report/Report_Screen.dart';
import 'package:lingo/Test/Test_Screen.dart';
import 'package:lingo/Home/homescreen.dart';
import 'package:lingo/User/profile.dart';
import 'package:lingo/Home/splashScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
        '/report': (context) => ReportScreen(),
        '/pretest': (context) => PretestScreen(),
        '/login': (context) => Login(),
        '/signin': (context) => SignIn(),
      },
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const Splashscreen(),
    );
  }
}
