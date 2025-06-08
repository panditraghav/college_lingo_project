import 'dart:ui';
import 'package:flutter/material.dart';

class PretestScreen extends StatelessWidget {
  const PretestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: Stack(
        children: [
          // Decorative blurred background circles
          Positioned(
            top: -100,
            left: -100,
            child: _blurredCircle(200, Colors.deepPurpleAccent),
          ),
          Positioned(
            bottom: -120,
            right: -80,
            child: _blurredCircle(180, Colors.tealAccent),
          ),
          Positioned(
            top: 100,
            right: -50,
            child: _blurredCircle(100, Colors.purple.withOpacity(0.3)),
          ),
          // Main content
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 60),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      Center(
                        child: Image.asset(
                          'assets/images/lingoo2.png',
                          height: 150,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Lingo AI',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Sharpen your grammar skills with a quick pre-test!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
                const SizedBox(height: 50),
                _buildButton(
                  context: context,
                  label: 'Start Test',
                  icon: Icons.play_arrow,
                  color: Colors.deepPurple,
                  onTap: () {
                    Navigator.pushNamed(context, '/test');
                  },
                ),
                const SizedBox(height: 30),
                _buildButton(
                  context: context,
                  label: 'Report',
                  icon: Icons.insert_chart_outlined,
                  color: Colors.teal,
                  onTap: () {
                    Navigator.pushNamed(context, '/report');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required BuildContext context,
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.6),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: Colors.white),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _blurredCircle(double size, Color color) {
    return ClipOval(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 80.0, sigmaY: 80.0),
        child: Container(
          width: size,
          height: size,
          color: color.withOpacity(0.4),
        ),
      ),
    );
  }
}
