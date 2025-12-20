import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

import '../widgets/right_drawer.dart';
import '../stats/services/stats_service.dart';
import '../stats/models/stats_model.dart';
import 'home_stat.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final req = context.watch<CookieRequest>();

    return Scaffold(
      backgroundColor: const Color(0xFF1D1F22),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1D1F22),
        elevation: 0,
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
        ],
      ),
      endDrawer: const RightDrawer(),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            Container(
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
                children: const [
                  Text(
                    "Selamat Datang di EPL Radar",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Portal statistik dan berita Liga Inggris terlengkap. Dapatkan data match, pemain, dan klub terkini.",
                    style: TextStyle(color: Colors.white70, fontSize: 15),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // STATS 
            FutureBuilder<Stats?>(
              future: StatsService.fetchStats(req),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                    height: 120,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (!snapshot.hasData) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      "Gagal memuat statistik",
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }

                return HomeStat(stats: snapshot.data!);
              },
            ),

            const SizedBox(height: 32),

          ],
        ),
      ),
    );
  }
}
