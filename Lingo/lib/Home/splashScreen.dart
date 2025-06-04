import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:lingo/Authentication/AuthScreen.dart';
import 'package:lingo/services/api_service.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  _SplashscreenState createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen>
    with SingleTickerProviderStateMixin {
  final AudioPlayer _audioPlayer = AudioPlayer();
  double _opacity = 0.0;
  double _scale = 1.0;
  late AnimationController _controller;
  final ApiService _apiService = ApiService();

  void test() async {
    print("Cookie from function!");
    final cookie = await _apiService.getCookie();
    print(cookie);
  }

  Future<void> _initializeApiService() async {
    await _apiService.dio; // Ensure _setupDio has completed
    setState(() {}); // Rebuild to ensure Dio is ready
  }

  @override
  void initState() {
    _playSound();
    super.initState();
    _initializeApiService();
    test();

    // Initialize animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..forward();

    // Start fade and scale animation
    Timer(const Duration(milliseconds: 200), () {
      setState(() {
        _opacity = 1.0;
        _scale = 1.05;
      });
    });

    // Navigate to next screen after delay
    Timer(const Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Authscreen()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _playSound() async {
    await _audioPlayer.play(AssetSource('sound/Lingo.mp3'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: AnimatedOpacity(
          duration: const Duration(seconds: 2),
          opacity: _opacity,
          curve: Curves.easeInOut,
          child: AnimatedScale(
            scale: _scale,
            duration: const Duration(seconds: 2),
            curve: Curves.easeInOut,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/lingoo2.png', height: 150),
                const SizedBox(height: 40),
                const Text(
                  'Lingo',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 255, 255, 255),
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Your AI Language Tutor',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
