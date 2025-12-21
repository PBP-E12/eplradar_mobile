import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

import '../player/models/player.dart';
import '../player/screens/playerspage.dart';
import '../player/widgets/player_card.dart';
import '../player/services/player_service.dart';
import '../clubs/models/club.dart';
import '../clubs/services/club_service.dart';

class HomePlayer extends StatelessWidget {
  const HomePlayer({super.key});

  Future<Map<String, dynamic>> fetchData(CookieRequest request) async {
    try {
      final players = await PlayerService.fetchPlayers(request);
      players.sort((a, b) => b.currGoals.compareTo(a.currGoals));
      
      final clubs = await ClubService.fetchClubs(request);
      
      return {
        'players': players.take(6).toList(),
        'clubs': clubs,
      };
    } catch (e) {
      debugPrint('Error fetching home player data: $e');
      return {'players': <Player>[], 'clubs': <Club>[]};
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Top Scorers",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, PlayersPage.routeName);
                },
                child: const Text(
                  "Lihat Semua Pemain →",
                  style: TextStyle(color: Colors.blueAccent),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          FutureBuilder<Map<String, dynamic>>(
            future: fetchData(request),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              final players = snapshot.data?['players'] as List<Player>? ?? [];
              final clubs = snapshot.data?['clubs'] as List<Club>? ?? [];

              if (players.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Center(
                    child: Text(
                      "Belum ada data pemain.",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                );
              }

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 0.75, // Taller but narrower for 3x2 box
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: players.length,
                itemBuilder: (context, index) {
                  final player = players[index];
                  final club = clubs.firstWhere(
                    (c) => c.id == player.team,
                    orElse: () => Club(id: 0, namaKlub: "Unknown", logoFilename: "", jumlahWin: 0, jumlahDraw: 0, jumlahLose: 0, totalMatches: 0, points: 0),
                  );
                  return _buildPlayerHomeCard(context, player, club.namaKlub);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerHomeCard(BuildContext context, Player player, String teamName) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => Dialog(
            backgroundColor: const Color(0xFF2A2D32),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: PlayerDetail(player: player, teamName: teamName),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF2A2D32),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFF3F3F46),
            width: 1,
          ),
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFF3F3F46),
                  shape: BoxShape.circle,
                ),
                child: ClipOval(
                  child: player.fullProfilePictureUrl.isNotEmpty
                      ? (player.isLocalAsset
                          ? Image.asset(
                              player.fullProfilePictureUrl,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) => const Icon(Icons.person, size: 30, color: Colors.white54),
                            )
                          : Image.network(
                              player.fullProfilePictureUrl,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) => const Icon(Icons.person, size: 30, color: Colors.white54),
                            ))
                      : const Icon(Icons.person, size: 30, color: Colors.white54),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              player.name,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              '${player.currGoals} gol',
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[400],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
