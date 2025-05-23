import 'package:flutter/material.dart';

class Authscreen extends StatefulWidget {
  const Authscreen({super.key});

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<Authscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF1E3A8A),
              Color(0xFF4F46E5),
              Color.fromARGB(255, 93, 198, 243),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo.png', height: 180),
            const SizedBox(height: 40),

            // Login Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF4F46E5),
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {
                // TODO: Handle Login action
              },
              child: const Text(
                'Login',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 15),

            TextButton(
              onPressed: () {
                // TODO: Navigate to sign-in screen
              },
              child: const Text(
                'Already have an account? Sign In',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'OR',
              style: TextStyle(
                color: Color.fromARGB(179, 255, 255, 255),
                fontSize: 26,
              ),
            ),

            const SizedBox(height: 20),

            // Google Sign-In Button
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black87,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              icon: Image.asset('assets/images/google.png', height: 24),
              label: const Text(
                'Continue with Google',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              onPressed: () {
                // TODO: Implement Google Sign-In
              },
            ),
          ],
        ),
      ),
    );
  }
}
