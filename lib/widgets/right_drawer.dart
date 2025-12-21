import 'package:eplradar_mobile/clubs/screens/club_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

import 'package:eplradar_mobile/matches/screens/match.dart';
import '../screens/menu.dart';
import '../news/screens/news.dart';
import '../stats/screens/stats_home_screen.dart';
import '../player/screens/playerspage.dart';
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

          const SizedBox(height: 12),

          _item(
            context,
            icon: Icons.home_outlined,
            title: "Home",
            routeName: MyHomePage.routeName,
          ),
          _item(
            context,
            icon: Icons.newspaper,
            title: "Match",
            routeName: MatchScreen.routeName,
          ),
          _item(
            context,
            icon: Icons.analytics,
            title: "Statistik",
            routeName: StatsHomeScreen.routeName,
          ),
          _item(
            context,
            icon: Icons.sports_soccer_sharp,
            title: "Klub",
            routeName: ClubListScreen.routeName,
          ),
          _item(
            context,
            icon: Icons.person,
            title: "Pemain",
            routeName: PlayersPage.routeName,
            ),
          _item(
            context,
            icon: Icons.article_outlined,
            title: "Berita",
            routeName: NewsPage.routeName,
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
              routeName: LoginPage.routeName,
              color: const Color(0xFF2563EB),
            ),

          if (!isLoggedIn)
            _item(
              context,
              icon: Icons.person_add_alt,
              title: "Register",
              routeName: RegisterPage.routeName,
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
                Navigator.pop(context);

                final req = context.read<CookieRequest>();

                try {
                  await req.logout(
                    "https://raihan-maulana41-eplradar.pbp.cs.ui.ac.id/auth/logout/",
                  );

                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    LoginPage.routeName,
                    (_) => false,
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Logout failed: $e")),
                  );
                }
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
    required String routeName,
    Color color = Colors.white,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: TextStyle(color: color)),
      onTap: () {
        Navigator.pop(context);

        final currentRoute = ModalRoute.of(context)?.settings.name;
        if (currentRoute != routeName) {
          Navigator.pushNamed(context, routeName);
        }
      },
    );
  }
}
