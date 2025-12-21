import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

import '../clubs/models/club.dart';
import '../clubs/screens/club_list_screen.dart';
import '../clubs/screens/club_detail_screen.dart';

class HomeClub extends StatelessWidget {
  const HomeClub({super.key});

  Future<List<Club>> fetchTopClubs(CookieRequest request) async {
    final response = await request.get(
      'https://raihan-maulana41-eplradar.pbp.cs.ui.ac.id/clubs/api/clubs/',
    );

    if (response != null && response['data'] != null) {
      List<Club> clubs = (response['data'] as List)
          .map((c) => Club.fromJson(c))
          .toList();

      clubs.sort((a, b) => b.points.compareTo(a.points));
      return clubs.take(4).toList();
    }

    return [];
  }

  String _getLogoUrl(String logoFilename) {
    final cleanFilename = logoFilename.replaceAll('.png', '');
    final filenameWithSpace = cleanFilename.replaceAll('_', ' ');
    final encodedFilename = Uri.encodeComponent(filenameWithSpace);
    return 'https://raihan-maulana41-eplradar.pbp.cs.ui.ac.id/static/img/club-matches/$encodedFilename.png';
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
                "Profil Klub",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ClubListScreen(),
                    ),
                  );
                },
                child: const Text(
                  "Lihat Semua Profil →",
                  style: TextStyle(color: Colors.blueAccent),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          FutureBuilder<List<Club>>(
            future: fetchTopClubs(request),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Text(
                    "Belum ada data klub.",
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              }

              final clubs = snapshot.data!;

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.1,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: clubs.length,
                itemBuilder: (context, index) {
                  final club = clubs[index];
                  return _buildClubCard(context, club);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildClubCard(BuildContext context, Club club) {
    final logoUrl = _getLogoUrl(club.logoFilename);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ClubDetailScreen(club: club),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF2A2D32),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: const Color(0xFF3F3F46),
            width: 1,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: const Color(0xFF3F3F46),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Image.network(
                  logoUrl,
                  width: 55,
                  height: 55,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.shield,
                      size: 40,
                      color: Colors.white54,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              club.namaKlub,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              '${club.points} poin',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[400],
              ),
            ),
          ],
        ),
      ),
    );
  }
}