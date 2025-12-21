import 'package:eplradar_mobile/screens/menu.dart';
import 'package:eplradar_mobile/matches/screens/match.dart';
import 'package:eplradar_mobile/stats/screens/stats_home_screen.dart';
import 'package:eplradar_mobile/clubs/screens/club_list_screen.dart';
import 'package:eplradar_mobile/news/screens/news.dart';
import 'package:eplradar_mobile/player/screens/playerspage.dart';
import 'package:eplradar_mobile/screens/login.dart';
import 'package:eplradar_mobile/screens/register.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    Provider<CookieRequest>(
      create: (_) => CookieRequest(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EPL Radar Stats',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF1D1F22),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1D1F22),
          elevation: 0,
        ),
      ),

      initialRoute: MyHomePage.routeName,
      routes: {
        MyHomePage.routeName: (_) => const MyHomePage(),
        MatchScreen.routeName: (_) => const MatchScreen(),
        StatsHomeScreen.routeName: (_) => const StatsHomeScreen(),
        ClubListScreen.routeName: (_) => const ClubListScreen(),
        PlayersPage.routeName: (_) => const PlayersPage(),
        NewsPage.routeName: (_) => const NewsPage(),
        LoginPage.routeName: (_) => const LoginPage(),
        RegisterPage.routeName: (_) => const RegisterPage(),
      },
    );
  }
}
