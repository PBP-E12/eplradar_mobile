import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import '../../screens/login.dart';
import '../../widgets/right_drawer.dart';
import '../services/stats_service.dart';
import '../services/favorite_service.dart';
import '../models/stats_model.dart';
import '../models/favorite_model.dart';
import '../widgets/favorite_small_card.dart';
import '../widgets/stat_section.dart';
import 'favorites_screen.dart';

class StatsHomeScreen extends StatefulWidget {
  static const routeName = '/stats';
  const StatsHomeScreen({super.key});

  @override
  State<StatsHomeScreen> createState() => _StatsHomeScreenState();
}

class _StatsHomeScreenState extends State<StatsHomeScreen> {
  Stats? stats;
  FavoriteList? favorites;

  bool loadingStats = true;
  bool loadingFav = true;

  String filter = "pemain"; 

  @override
  void initState() {
    super.initState();
    loadStats();
    loadFavorites();
  }

  Future<void> loadStats() async {
    final req = context.read<CookieRequest>();

    final result = await StatsService.fetchStats(req);
    stats = result;

    setState(() => loadingStats = false);
  }

  Future<void> loadFavorites() async {
    final req = context.read<CookieRequest>();

    try {
      favorites = await FavoriteService.fetchFavorites(req);
    } catch (_) {
      favorites = FavoriteList(favorites: []);
    }

    setState(() => loadingFav = false);
  }

  Future<void> deleteFavorite(String id) async {
    final req = context.read<CookieRequest>();

    await FavoriteService.deleteFavorite(req, id);
    loadFavorites();
  }

  Widget heroSection() {
    return Container(
      height: 280,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/stats.png"),
          fit: BoxFit.cover,
          opacity: 0.75,
        ),
      ),
      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 28),
      alignment: Alignment.bottomLeft,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Statistik",
            style: TextStyle(
              color: Colors.white,
              fontSize: 42,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Dapatkan informasi terkait gol, assist, dan clean sheet pemain Liga Inggris",
            style: TextStyle(color: Colors.white70, fontSize: 15),
          ),
          const SizedBox(height: 18),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF2563eb),
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Scrollable.ensureVisible(
                statsKey.currentContext!,
                duration: const Duration(milliseconds: 500),
              );
            },
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Lihat Statistik"),
              ],
            ),
          ),
          SizedBox(height: 36),
        ],
      ),
    );
  }

  Widget favoriteSection() {
    final req = context.watch<CookieRequest>();
    final String? username = req.jsonData["username"];
    final bool isLoggedIn = req.loggedIn && username != null && username.trim().isNotEmpty;

    if (!isLoggedIn) {
      return Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF2B2C2F),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            const Text(
              "Login untuk menambahkan pemain favorit",
              style: TextStyle(color: Colors.grey, fontSize: 15),
            ),
            const SizedBox(height: 12),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF2563eb),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),

              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                );

                if (result == true) {
                  loadFavorites();
                }
              },

              child: const Text("Login"),
            ),
          ],
        ),
      );
    }

    if (loadingFav) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (favorites == null || favorites!.favorites.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF2B2C2F),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            const Text(
              "Belum ada pemain favorit",
              style: TextStyle(color: Colors.grey),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FavoritesScreen()),
                ).then((_) => loadFavorites());
              },
              child: const Text("Tambah Favorit"),
            ),
          ],
        ),
      );
    }

    final two = favorites!.favorites.take(2).toList();

    return Container(
      padding: const EdgeInsets.all(18),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2B2C2F),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Pemain Favorit Saya",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          const SizedBox(height: 12),

          ...two.map(
            (f) => FavoriteCardSmall(
              image: f.photo,
              name: f.name,
              club: f.club,
              onDelete: () => deleteFavorite(f.playerId),
              onTapEdit: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FavoritesScreen()),
                ).then((_) => loadFavorites());
              },
            ),
          ),

          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FavoritesScreen()),
                ).then((_) => loadFavorites());
              },
              child: const Text("Lihat Selengkapnya"),
            ),
          ),
        ],
      ),
    );
  }

  Widget filterButtons() {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          filterButton("Pemain", "pemain"),
          const SizedBox(width: 24),
          filterButton("Klub", "klub"),
        ],
      ),
    );
  }

  Widget filterButton(String label, String value) {
    final active = (filter == value);

    return GestureDetector(
      onTap: () => setState(() => filter = value),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: active ? Color(0xFF2563eb) : Colors.grey,
        ),
      ),
    );
  }

  final statsKey = GlobalKey();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1D1F22),
      appBar: AppBar(
        title: const Text(
          'Statistik',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF1D1F22),
        elevation: 0,
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
        ],
      ),
      endDrawer: RightDrawer(),
      body: loadingStats
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                heroSection(),
                const SizedBox(height: 24),
                favoriteSection(),
                filterButtons(),

                // Anchor untuk scroll
                Container(key: statsKey),

                if (stats != null)
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        StatSection(
                          title: "Top Scorer",
                          items: filter == "pemain"
                              ? stats!.player.topScorer
                              : stats!.club.topScorer,
                        ),
                        StatSection(
                          title: "Top Assist",
                          items: filter == "pemain"
                              ? stats!.player.topAssist
                              : stats!.club.topAssist,
                        ),
                        StatSection(
                          title: "Clean Sheet",
                          items: filter == "pemain"
                              ? stats!.player.cleanSheet
                              : stats!.club.cleanSheet,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
    );
  }
}
