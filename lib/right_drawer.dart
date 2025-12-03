import 'package:eplradar_mobile/screens/menu.dart';
import 'package:flutter/material.dart';
import 'package:eplradar_mobile/news/screens/news.dart';

class RightDrawer extends StatelessWidget {
  const RightDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
            // Bagian drawer header
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                children: [
                  Text(
                    'Football News',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(10)),
                  Text("Seluruh berita sepak bola terkini di sini!",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                      ),
                  ),
                ],
              ),
            ),
          // Bagian routing
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Home'),
            // Bagian redirection ke Page Home
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyHomePage(title: ""),
                )
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.newspaper),
            title: const Text('Match'),
            // Bagian redirection ke Page Match
            onTap: () {
              Navigator.pushReplacement(
                // TODO: Ganti route ke page yang sesuai (kalo nanti pagenya udh ada)
                context,
                MaterialPageRoute(
                  builder: (context) => NewsPage()
                )
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.analytics_outlined),
            title: const Text('Statistik'),
            // Bagian redirection ke Page Statistik
            onTap: () {
              Navigator.pushReplacement(
                // TODO: Ganti route ke page yang sesuai (kalo nanti pagenya udh ada)
                context,
                MaterialPageRoute(
                  builder: (context) => NewsPage()
                )
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.person_search_outlined),
            title: const Text('Pemain'),
            // Bagian redirection ke Page Pemain
            onTap: () {
              Navigator.pushReplacement(
                // TODO: Ganti route ke page yang sesuai (kalo nanti pagenya udh ada)
                context,
                MaterialPageRoute(
                  builder: (context) => NewsPage()
                )
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.shield_outlined),
            title: const Text('Klub'),
            // Bagian redirection ke Page Klub
            onTap: () {
              Navigator.pushReplacement(
                // TODO: Ganti route ke page yang sesuai (kalo nanti pagenya udh ada)
                context,
                MaterialPageRoute(
                  builder: (context) => NewsPage()
                )
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.newspaper),
            title: const Text('Berita'),
            // Bagian redirection ke Page Berita
            onTap: () {
              Navigator.pushReplacement(
                // TODO: Ganti route ke page yang sesuai (kalo nanti pagenya udh ada)
                context,
                MaterialPageRoute(
                  builder: (context) => NewsPage()
                )
              );
            },
          ),
        ],
      ),
    );
  }
}