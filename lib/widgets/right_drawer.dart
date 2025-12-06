import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

import '../screens/menu.dart';
import '../news/screens/news.dart';
import '../stats/screens/stats_home_screen.dart';
import '../screens/login.dart';
import '../screens/register.dart';

class RightDrawer extends StatelessWidget {
  const RightDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    final String? username = request.jsonData["username"];
    final bool isLoggedIn =
        request.loggedIn && username != null && username.trim().isNotEmpty;

    return Drawer(
      backgroundColor: const Color(0xFF1D1F22),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Color(0xFF2B2D31)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "EPL Radar",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                const SizedBox(height: 8),

                Text(
                  isLoggedIn ? "Hi, $username" : "Not Logged In",
                  style: const TextStyle(color: Colors.white70, fontSize: 16),
                ),

                const SizedBox(height: 12),

                const Text(
                  "Semua statistik, berita, dan data EPL lengkap.",
                  style: TextStyle(color: Colors.white54, fontSize: 13),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          _item(
            context,
            icon: Icons.home_outlined,
            title: "Home",
            page: const MyHomePage(),
          ),
          _item(
            context,
            icon: Icons.newspaper,
            title: "Match",
            page: const NewsPage(),   // TODO: ganti nanti
          ),
          _item(
            context,
            icon: Icons.analytics,
            title: "Statistik",
            page: const StatsHomeScreen(),
          ),
          _item(
            context,
            icon: Icons.person_search,
            title: "Pemain",
            page: const NewsPage(), // TODO : ganti nanti
          ),
          _item(
            context,
            icon: Icons.shield_outlined,
            title: "Klub",
            page: const NewsPage(), // TODO: ganti nanti
          ),
          _item(
            context,
            icon: Icons.article_outlined,
            title: "Berita",
            page: const NewsPage(),   // TODO: ganti nanti
          ),

          const Divider(
            color: Colors.white24,
            thickness: 0.4,
            indent: 16,
            endIndent: 16,
          ),

          if (!isLoggedIn)
            _item(
              context,
              icon: Icons.login,
              title: "Login",
              page: const LoginPage(),
              color: const Color(0xFF2563EB),
            ),

          if (!isLoggedIn)
            _item(
              context,
              icon: Icons.person_add_alt,
              title: "Register",
              page: const RegisterPage(),
              color: const Color(0xFF2563EB),
            ),

          if (isLoggedIn)
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.redAccent),
              title: const Text(
                "Logout",
                style: TextStyle(color: Colors.redAccent),
              ),
              onTap: () async {
                Navigator.pop(context); // tutup drawer

                final req = context.read<CookieRequest>();
                await req.logout("http://10.0.2.2:8000/auth/logout/");

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const MyHomePage()),
                  (_) => false,
                );
              },
            ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _item(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Widget page,
    Color color = Colors.white,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: TextStyle(color: color)),
      onTap: () {
        Navigator.pop(context); // tutup drawer
        Navigator.push(context, MaterialPageRoute(builder: (_) => page));
      },
    );
  }
}
