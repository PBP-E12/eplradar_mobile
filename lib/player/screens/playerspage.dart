import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import '../models/player.dart';
import '../models/player_comment.dart';
import '../widgets/player_card.dart';
import '../widgets/player_comment_card.dart';
import '../../clubs/models/club.dart';

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

  Future<List<Player>> fetchPlayers(CookieRequest request) async {
    final response = await request.get(
        'https://raihan-maulana41-eplradar.pbp.cs.ui.ac.id/players/api/?team=$selectedTeamId');

    return PlayerListResponse.fromJson(response).players;
  }

  Future<List<Club>> fetchClubs(CookieRequest request) async {
    final response = await request.get('https://raihan-maulana41-eplradar.pbp.cs.ui.ac.id/clubs/api/clubs/');
    if (response != null && response['data'] != null) {
      return (response['data'] as List).map((c) => Club.fromJson(c)).toList();
    }
    return [];
  }

  Future<List<PlayerComment>> fetchComments(CookieRequest request, String playerId) async {
    final response = await request.get('https://raihan-maulana41-eplradar.pbp.cs.ui.ac.id/players/api/$playerId/comments/');
    return PlayerCommentListResponse.fromJson(response).comments;
  }

  Future<void> submitComment(CookieRequest request, String playerId, String commentText) async {
    final response = await request.post(
      'https://raihan-maulana41-eplradar.pbp.cs.ui.ac.id/players/api/$playerId/comments/',
      {'comment': commentText},
    );
    if (response['status'] == 'success') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Comment posted!")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'] ?? "Failed to post comment")),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final request = context.read<CookieRequest>();
      final fetchedClubs = await fetchClubs(request);
      setState(() {
        clubs = fetchedClubs;
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _showPlayerDetail(BuildContext context, Player player, String teamName) {
    final request = context.read<CookieRequest>();
    final TextEditingController commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Dialog(
              backgroundColor: const Color(0xFF2A2D32),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildDynamicPlayerImage(player, isDialog: true),
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            player.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildDetailRow("Klub Saat Ini", teamName),
                          _buildDetailRow("Posisi", player.position),
                          _buildDetailRow("Usia", player.age.toString()),
                          _buildDetailRow("Kewarganegaraan", player.citizenship),
                          const SizedBox(height: 24),
                          const Text(
                            "Statistik Musim Ini",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              _buildStatCard("Gol", player.currGoals.toString()),
                              const SizedBox(width: 8),
                              _buildStatCard("Assist", player.currAssists.toString()),
                              const SizedBox(width: 8),
                              _buildStatCard("Match", player.matchPlayed.toString()),
                            ],
                          ),
                          const SizedBox(height: 32),
                          const Divider(color: Colors.grey),
                          const SizedBox(height: 16),
                          const Text(
                            "Komentar",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          FutureBuilder<List<PlayerComment>>(
                            future: fetchComments(request, player.id),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Center(child: CircularProgressIndicator());
                              }
                              final comments = snapshot.data ?? [];
                              if (comments.isEmpty) {
                                return const Text("Belum ada komentar.", style: TextStyle(color: Colors.grey));
                              }
                              return ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: comments.length,
                                itemBuilder: (context, index) {
                                  return PlayerCommentCard(comment: comments[index]);
                                },
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: commentController,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: "Tambah komentar...",
                              hintStyle: const TextStyle(color: Colors.grey),
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.send, color: Colors.blueAccent),
                                onPressed: () async {
                                  if (commentController.text.isNotEmpty) {
                                    await submitComment(request, player.id, commentController.text);
                                    commentController.clear();
                                    setModalState(() {}); // Refresh comments
                                  }
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Center(
                            child: TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Close", style: TextStyle(color: Colors.blueAccent)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDynamicPlayerImage(Player player, {bool isDialog = false}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: double.infinity,
          height: isDialog ? 300 : 200, // Constrained height
          decoration: isDialog ? const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF374151), Color(0xFF1F2937)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ) : null,
          child: player.fullProfilePictureUrl.isNotEmpty
              ? (player.isLocalAsset
                  ? Image.asset(
                      player.fullProfilePictureUrl,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.person, color: Colors.grey, size: 50),
                    )
                  : Image.network(
                      player.fullProfilePictureUrl,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.person, color: Colors.grey, size: 50),
                    ))
              : const Icon(Icons.person, color: Colors.grey, size: 50),
        );
      }
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF374151),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomDropdown({
    required String value,
    required List<DropdownMenuItem<String>> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2D32),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade800),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          dropdownColor: const Color(0xFF2A2D32),
          style: const TextStyle(color: Colors.white),
          icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
          onChanged: onChanged,
          items: items,
        ),
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
            // Hero Section (Styled)
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
                  _buildCustomDropdown(
                    value: selectedTeamId,
                    items: [
                      const DropdownMenuItem(value: 'all', child: Text("All Teams")),
                      ...clubs.map((club) => DropdownMenuItem(
                        value: club.id.toString(),
                        child: Text(club.namaKlub),
                      )),
                    ],
                    onChanged: (val) {
                      setState(() {
                        selectedTeamId = val!;
                      });
                    },
                  ),
                ],
              ),
            ),

            // Player Cards List
            FutureBuilder(
              future: fetchPlayers(request),
              builder: (context, AsyncSnapshot<List<Player>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.all(20),
                    child: Center(child: CircularProgressIndicator()),
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
}
