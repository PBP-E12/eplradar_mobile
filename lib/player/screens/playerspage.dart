import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import '../models/player.dart';
import '../widgets/player_card.dart';
import '../services/player_service.dart';
import '../../clubs/models/club.dart';
import '../../clubs/services/club_service.dart';

class PlayersPage extends StatefulWidget {
  static const routeName = '/players';
  const PlayersPage({super.key});

  @override
  State<PlayersPage> createState() => _PlayersPageState();
}

class _PlayersPageState extends State<PlayersPage> {
  final ScrollController _scrollController = ScrollController();
  String selectedTeamId = 'all';
  List<Club> clubs = [];

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final request = context.read<CookieRequest>();
      try {
        final fetchedClubs = await ClubService.fetchClubs(request);
        if (mounted) {
          setState(() {
            clubs = fetchedClubs;
          });
        }
      } catch (e) {
        debugPrint('Error fetching clubs: $e');
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _showPlayerDetail(BuildContext context, Player player, String teamName) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: const Color(0xFF2A2D32),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: PlayerDetail(player: player, teamName: teamName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    const Color bgColor = Color(0xFF1D1F22);
    const Color cardColor = Color(0xFF2A2D32);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text('EPL Radar'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/playershero.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Pemain",
                    style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Dapatkan informasi terkait pemain favoritmu di liga inggris musim ini",
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _scrollController.animateTo(
                        500,
                        duration: const Duration(milliseconds: 800),
                        curve: Curves.easeInOut,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Lihat Seluruh Pemain"),
                  )
                ],
              ),
            ),

            // Section Header and Filter
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Profil Pemain Musim Ini",
                    style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  _buildCustomDropdown(),
                ],
              ),
            ),

            // Player Cards List
            FutureBuilder<List<Player>>(
              future: PlayerService.fetchPlayers(request, teamId: selectedTeamId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.all(20),
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (snapshot.hasError) {
                  return Padding(
                    padding: const EdgeInsets.all(40),
                    child: Center(
                      child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.red)),
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(40),
                    child: Center(
                      child: Text('Belum ada data pemain.', style: TextStyle(color: Colors.grey)),
                    ),
                  );
                } else {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.length,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemBuilder: (context, index) {
                      final player = snapshot.data![index];
                      final club = clubs.firstWhere(
                        (c) => c.id == player.team,
                        orElse: () => Club(id: 0, namaKlub: "Unknown", logoFilename: "", jumlahWin: 0, jumlahDraw: 0, jumlahLose: 0, totalMatches: 0, points: 0),
                      );
                      return PlayerCard(
                        player: player, 
                        club: club, 
                        cardColor: cardColor, 
                        onShowDetail: _showPlayerDetail
                      );
                    },
                  );
                }
              },
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2D32),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade800),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedTeamId,
          dropdownColor: const Color(0xFF2A2D32),
          style: const TextStyle(color: Colors.white),
          icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
          onChanged: (val) {
            setState(() {
              selectedTeamId = val!;
            });
          },
          items: [
            const DropdownMenuItem(value: 'all', child: Text("All Teams")),
            ...clubs.map((club) => DropdownMenuItem(
              value: club.id.toString(),
              child: Text(club.namaKlub),
            )),
          ],
        ),
      ),
    );
  }
}
