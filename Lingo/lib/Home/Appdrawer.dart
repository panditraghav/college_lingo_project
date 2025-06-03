import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: Drawer(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1A1A40), Color(0xFF2C003E), Color(0xFF1A1A40)],
            ),
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Container(
                padding: const EdgeInsets.only(top: 40, bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ShaderMask(
                      shaderCallback:
                          (bounds) => const LinearGradient(
                            colors: [Colors.cyanAccent, Colors.purpleAccent],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ).createShader(bounds),
                      blendMode: BlendMode.srcIn,
                      child: Image.asset(
                        'assets/images/lingoo2.png',
                        height: 150,
                      ),
                    ),
                  ],
                ),
              ),

              _buildDrawerItem(context, Icons.home, 'Home', '/home'),
              _buildDrawerItem(context, Icons.person, 'Profile', '/profile'),
              // _buildDrawerItem(
              //   context,
              //   Icons.settings,
              //   'Settings',
              //   '/settings',
              // ),
              _buildDrawerItem(
                context,
                Icons.smart_toy,
                'AI Tutor',
                '/ai_tutor',
              ),
              _buildDrawerItem(context, Icons.book, 'Lessons', '/lesson'),
              _buildDrawerItem(context, Icons.quiz, 'Test', '/test'),
              // _buildDrawerItem(
              //   context,
              //   Icons.leaderboard,
              //   'Results',
              //   '/results',
              // ),
              // _buildDrawerItem(
              //   context,
              //   Icons.show_chart,
              //   'Progress',
              //   '/progress',
              // ),
              // const Divider(color: Colors.white54),
              // _buildDrawerItem(context, Icons.logout, 'Logout', '/logout'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context,
    IconData icon,
    String label,
    String route,
  ) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        label,
        style: const TextStyle(fontSize: 16, color: Colors.white),
      ),
      onTap: () {
        Navigator.pop(context); // Close the drawer
        Navigator.pushNamed(context, route);
      },
    );
  }
}
