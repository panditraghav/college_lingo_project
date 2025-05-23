import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.black),
            child: Center(
              child: Text(
                'Lingo Menu',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          _buildDrawerItem(context, Icons.home, 'Home', '/home'),
          _buildDrawerItem(context, Icons.person, 'Profile', '/profile'),
          _buildDrawerItem(context, Icons.settings, 'Settings', '/settings'),
          _buildDrawerItem(context, Icons.smart_toy, 'AI Tutor', '/ai_tutor'),
          _buildDrawerItem(context, Icons.book, 'Lessons', '/lesson'),
          _buildDrawerItem(context, Icons.quiz, 'Test', '/test'),
          _buildDrawerItem(context, Icons.leaderboard, 'Results', '/results'),
          _buildDrawerItem(context, Icons.show_chart, 'Progress', '/progress'),
          const Divider(),
          _buildDrawerItem(context, Icons.logout, 'Logout', '/logout'),
        ],
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
      leading: Icon(icon, color: Colors.black87),
      title: Text(label, style: const TextStyle(fontSize: 16)),
      onTap: () {
        Navigator.pop(context); // Close the drawer
        Navigator.pushNamed(context, route);
      },
    );
  }
}
