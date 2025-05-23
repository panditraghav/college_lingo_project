import 'package:flutter/material.dart';
import 'dart:async';

import 'package:lingo/AuthScreen.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  _SplashscreenState createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();

    // Start the fade-in animation
    Timer(const Duration(milliseconds: 1), () {
      setState(() {
        _opacity = 1.0;
      });
    });

    // Navigate to next screen
    Timer(const Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Authscreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF1E3A8A), // Indigo dark
              Color(0xFF4F46E5), // Primary Indigo
              Color.fromARGB(255, 93, 198, 243), // Sky blue accent
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: AnimatedOpacity(
            duration: const Duration(seconds: 2),
            opacity: _opacity,
            curve: Curves.easeInOut,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/logo.png', height: 150),
                const SizedBox(height: 20),
                const Text(
                  'Lingo',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Your AI Language Tutor',
                  style: TextStyle(fontSize: 16, color: Color(0xFFD1D5DB)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
