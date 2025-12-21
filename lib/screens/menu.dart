import 'package:flutter/material.dart';
import '../widgets/right_drawer.dart';
import 'home_stat.dart';
import 'home_news.dart';

class MyHomePage extends StatefulWidget {
  static const routeName = '/home';
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFF1D1F22),
      appBar: AppBar(
        title: const Text(
          'Home',
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
            const HomeStat(),
            const SizedBox(height: 32),
            const HomeNews(),
            const SizedBox(height: 40),

          ],
        ),
      ),
    );
  }
}
