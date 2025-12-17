import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:eplradar_mobile/matches/model/club_model.dart';

class ShowKlasemen extends StatefulWidget {
  const ShowKlasemen({super.key});

  @override
  State<ShowKlasemen> createState() => _ShowKlasemenState();
}

class _ShowKlasemenState extends State<ShowKlasemen> {
  Future<List<ClubModel>> fetchKlasemen(CookieRequest request) async {
    String url = 'http://localhost:8000/matches/api/klasemen/';

    final response = await request.get(url);

    List<ClubModel> clubs = [];
    for (var club in response) {
      clubs.add(ClubModel.fromJson(club));
    }

    return clubs;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      backgroundColor: const Color(0xFF1D1F22),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1D1F22),
        elevation: 0,
        title: const Text(
          'Klasemen',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: FutureBuilder<List<ClubModel>>(
        future: fetchKlasemen(request),
        builder: (context, AsyncSnapshot<List<ClubModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF3247B1),
              ),
            );
          }
          else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 80, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${snapshot.error}',
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }
          else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                ' Data klasemen tidak ditemukan.',
                style: TextStyle(color: Colors.white70, fontSize: 18),
              ),
            );
          }
          else {
            return RefreshIndicator(
              onRefresh: () async {
                setState(() {});
              },
              color: const Color(0xFF3247B1),
              child: Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF333438),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final club = snapshot.data![index];
                    return _buildKlasemenRow(club);
                  },
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildKlasemenRow(ClubModel club) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          // Rank
          SizedBox(
            width: 30,
            child: Text(
              '${club.rank}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Logo -> TODO: Buat url logo club nya
          Image.network(
            'http://localhost:8000/urllogo.png',
            width: 30,
            height: 30,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(
                Icons.sports_soccer,
                color: Colors.white54,
                size: 30,
              );
            },
          ),

          const SizedBox(width: 12),

          // Club Name
          Expanded(
            child: Text(
              club.namaKlub,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // Stats
          SizedBox(
            width: 40,
            child: Text(
              '${club.totalMatches}',
              style: const TextStyle(color: Colors.white70, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: 40,
            child: Text(
              '${club.jumlahWin}',
              style: const TextStyle(color: Colors.white70, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: 40,
            child: Text(
              '${club.jumlahDraw}',
              style: const TextStyle(color: Colors.white70, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: 40,
            child: Text(
              '${club.jumlahLose}',
              style: const TextStyle(color: Colors.white70, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: 50,
            child: Text(
              '${club.poin}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}