import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import '../models/player.dart';
import '../models/player_comment.dart';
import '../services/player_service.dart';
import '../widgets/player_comment_card.dart';
import '../../clubs/models/club.dart';

class PlayerCard extends StatelessWidget {
  final Player player;
  final Club club;
  final Color cardColor;
  final Function(BuildContext, Player, String) onShowDetail;

  const PlayerCard({
    Key? key,
    required this.player,
    required this.club,
    required this.cardColor,
    required this.onShowDetail,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: cardColor,
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => onShowDetail(context, player, club.namaKlub),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 4.0, left: 4.0, right: 4.0),
              child: _buildDynamicPlayerImage(player),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(player.position, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                      Text(
                        club.namaKlub,
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    player.name,
                    style: (player.currGoals > 10)? const TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold): const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Nationality: ${player.citizenship} | Age: ${player.age}",
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDynamicPlayerImage(Player player) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: double.infinity,
      height: 200,
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
}

class PlayerDetail extends StatefulWidget {
  final Player player;
  final String teamName;

  const PlayerDetail({
    Key? key,
    required this.player,
    required this.teamName,
  }) : super(key: key);

  @override
  State<PlayerDetail> createState() => _PlayerDetailState();
}

class _PlayerDetailState extends State<PlayerDetail> {
  final TextEditingController _commentController = TextEditingController();
  late Future<List<PlayerComment>> _commentsFuture;

  @override
  void initState() {
    super.initState();
    _refreshComments();
  }

  void _refreshComments() {
    final request = context.read<CookieRequest>();
    setState(() {
      _commentsFuture = PlayerService.fetchPlayerComments(request, widget.player.id);
    });
  }

  Future<void> _handleDeleteComment(int commentId) async {
    final request = context.read<CookieRequest>();
    try {
      final response = await request.post(
        'https://raihan-maulana41-eplradar.pbp.cs.ui.ac.id/players/api/comments/$commentId/delete/',
        {},
      );
      
      if (response != null && (response['status'] == 'success' || response['success'] == true)) {
        _refreshComments();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Comment deleted')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeroImage(),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPlayerHeader(),
                    const SizedBox(height: 24),
                    _buildStatsSection(),
                    const SizedBox(height: 32),
                    const Divider(color: Colors.grey),
                    const SizedBox(height: 16),
                    _buildCommentSection(request),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          right: 8,
          top: 8,
          child: IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.pop(context),
            style: IconButton.styleFrom(
              backgroundColor: Colors.black.withOpacity(0.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeroImage() {
    return Container(
      height: 300,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF374151), Color(0xFF1F2937)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: widget.player.fullProfilePictureUrl.isNotEmpty
          ? (widget.player.isLocalAsset
              ? Image.asset(widget.player.fullProfilePictureUrl, fit: BoxFit.contain)
              : Image.network(widget.player.fullProfilePictureUrl, fit: BoxFit.contain))
          : const Icon(Icons.person, size: 100, color: Colors.grey),
    );
  }

  Widget _buildPlayerHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.player.name,
          style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        _buildDetailRow("Klub Saat Ini", widget.teamName),
        _buildDetailRow("Posisi", widget.player.position),
        _buildDetailRow("Usia", widget.player.age.toString()),
        _buildDetailRow("Kewarganegaraan", widget.player.citizenship),
      ],
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

  Widget _buildStatsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Statistik Musim Ini",
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildStatCard("Gol", widget.player.currGoals.toString()),
            const SizedBox(width: 8),
            _buildStatCard("Assist", widget.player.currAssists.toString()),
            const SizedBox(width: 8),
            _buildStatCard("Match", widget.player.matchPlayed.toString()),
          ],
        ),
      ],
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

  Widget _buildCommentSection(CookieRequest request) {
    if (!request.loggedIn) {
      return const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Komentar",
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          Center(
            child: Text(
              "Silakan login untuk mengakses komentar",
              style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Komentar",
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        FutureBuilder<List<PlayerComment>>(
          future: _commentsFuture,
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
                return PlayerCommentCard(
                  comment: comments[index],
                  onDelete: () => _handleDeleteComment(comments[index].id),
                );
              },
            );
          },
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _commentController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Tambah komentar...",
            hintStyle: const TextStyle(color: Colors.grey),
            suffixIcon: IconButton(
              icon: const Icon(Icons.send, color: Colors.blueAccent),
              onPressed: () async {
                if (_commentController.text.isNotEmpty) {
                  final success = await PlayerService.createComment(
                    request, 
                    widget.player.id, 
                    _commentController.text
                  );
                  if (success) {
                    _commentController.clear();
                    _refreshComments();
                  }
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
