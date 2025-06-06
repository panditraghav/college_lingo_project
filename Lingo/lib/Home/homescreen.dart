import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lingo/services/api_service.dart';
import 'Appdrawer.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int progress = 0;
  int completed = 0;
  int totalLessons = 0;
  bool isLoadingProgress = true;

  final _apiServices = ApiService();
  @override
  void initState() {
    super.initState();
    requestAllPermissions(); // Request permissions on screen load
    fetchProgress();
  }

  Future<void> fetchProgress() async {
    try {
      final res = await _apiServices.getProgress();
      if (res.statusCode == 200) {
        final data = res.data;
        setState(() {
          progress = data['progress'] ?? 0;
          completed = data['completed'] ?? 0;
          totalLessons = data['totalLessons'] ?? 0;
          isLoadingProgress = false;
        });
      }
    } catch (e) {
      print('Error fetching progress: $e');
      setState(() {
        isLoadingProgress = false;
      });
    }
  }

  Future<void> requestAllPermissions() async {
    Map<Permission, PermissionStatus> statuses =
        await [
          Permission.camera,
          Permission.microphone,
          Permission.photos, // iOS
          Permission.storage, // Android
        ].request();

    statuses.forEach((permission, status) {
      if (status.isDenied) {
        print('$permission is denied');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      backgroundColor: const Color(0xFF1A1A1A),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
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
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Center(
                      child: Image.asset(
                        'assets/images/lingoo2.png',
                        height: 180,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Welcome to Lingo!',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'AI-Based Foreign Language Learning Platform',
                      style: TextStyle(fontSize: 14, color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        _buildActionButton(
                          icon: Icons.smart_toy,
                          label: "AI Tutor",
                          color: Colors.yellow[700]!,
                          onTap:
                              () => Navigator.pushNamed(context, '/ai_tutor'),
                        ),
                        _buildActionButton(
                          icon: Icons.book,
                          label: "Lessons",
                          color: Colors.lightBlue,
                          onTap: () => Navigator.pushNamed(context, '/lesson'),
                        ),
                        _buildActionButton(
                          icon: Icons.quiz,
                          label: "Test",
                          color: Colors.redAccent,
                          onTap: () => Navigator.pushNamed(context, '/pretest'),
                        ),
                        _buildActionButton(
                          icon: Icons.person_4_outlined,
                          label: "Profile",
                          color: Colors.green,
                          onTap: () => Navigator.pushNamed(context, '/profile'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    isLoadingProgress
                        ? const Center(child: CircularProgressIndicator())
                        : GestureDetector(
                          onTap:
                              () => Navigator.pushNamed(context, '/progress'),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 20,
                              horizontal: 20,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[900],
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.greenAccent,
                                  blurRadius: 6,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Your Learning Progress",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                LinearProgressIndicator(
                                  value: progress / 100,
                                  backgroundColor: Colors.white24,
                                  color: Colors.greenAccent,
                                  minHeight: 8,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "$progress% completed •",
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        height: 120,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.white),
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
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
