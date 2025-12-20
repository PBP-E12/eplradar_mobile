import 'package:eplradar_mobile/widgets/right_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import '../models/club.dart';
import '../services/club_service.dart';
import 'club_detail_screen.dart';

class ClubListScreen extends StatefulWidget {
  const ClubListScreen({Key? key}) : super(key: key);

  @override
  State<ClubListScreen> createState() => _ClubListScreenState();
}

class _ClubListScreenState extends State<ClubListScreen> {
  late Future<List<Club>> _clubsFuture;

  @override
  void initState() {
    super.initState();
    _loadClubs();
  }

  void _loadClubs() {
    final request = context.read<CookieRequest>();
    setState(() {
      _clubsFuture = ClubService.fetchClubs(request);
    });
  }

  // Helper function to get correct logo filename
  String _getLogoUrl(String logoFilename) {
    // Remove any .png extension if it exists
    final cleanFilename = logoFilename.replaceAll('.png', '');
    // Replace underscore with space (karena file di server pakai spasi)
    final filenameWithSpace = cleanFilename.replaceAll('_', ' ');
    // URL encode spaces to %20
    final encodedFilename = Uri.encodeComponent(filenameWithSpace);
    return 'https://raihan-maulana41-eplradar.pbp.cs.ui.ac.id/static/img/club-matches/$encodedFilename.png';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: RightDrawer(),
      backgroundColor: const Color(0xFF1D1F22),
      appBar: AppBar(
        title: const Text(
          'Klub',
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
      body: RefreshIndicator(
        onRefresh: () async {
          _loadClubs();
        },
        color: const Color(0xFF3B82F6),
        backgroundColor: const Color(0xFF2B2D31),
        child: FutureBuilder<List<Club>>(
          future: _clubsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF3B82F6),
                ),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.redAccent,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error: ${snapshot.error}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _loadClubs,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3B82F6),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.sports_soccer,
                      size: 64,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No clubs found',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              );
            }

            final clubs = snapshot.data!;

            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  // Header Section with Gradient
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 32,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFF3B82F6),
                          const Color(0xFF2563EB),
                        ],
                      ),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(32),
                        bottomRight: Radius.circular(32),
                      ),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Profil Klub Musim Ini',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Temukan info terlengkap terkait tim\nfavoritmu di liga inggris musim ini',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white.withOpacity(0.9),
                            height: 1.4,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Clubs Grid
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.8,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: clubs.length,
                      itemBuilder: (context, index) {
                        final club = clubs[index];
                        return _buildClubCard(club);
                      },
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildClubCard(Club club) {
    final logoUrl = _getLogoUrl(club.logoFilename);
    
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ClubDetailScreen(club: club),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF2B2D31),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFF3F3F46),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Club Logo
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: const Color(0xFF3F3F46),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Image.network(
                  logoUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const CircularProgressIndicator(
                      color: Color(0xFF3B82F6),
                      strokeWidth: 2,
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    // Debug: print URL yang error
                    debugPrint('Error loading logo for ${club.namaKlub}');
                    debugPrint('URL: $logoUrl');
                    return const Icon(
                      Icons.shield,
                      size: 60,
                      color: Colors.white54,
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Club Name
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                club.namaKlub,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            const SizedBox(height: 8),

            // Stats Row (W D L)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildStatBadge(club.jumlahWin.toString(), Colors.green),
                const SizedBox(width: 8),
                _buildStatBadge(club.jumlahDraw.toString(), Colors.yellow),
                const SizedBox(width: 8),
                _buildStatBadge(club.jumlahLose.toString(), Colors.red),
              ],
            ),

            const SizedBox(height: 12),

            // Match Info
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF3B82F6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${club.totalMatches} pertandingan • ${club.points} poin',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildStatBadge(String value, Color color) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color,
          width: 1.5,
        ),
      ),
      child: Center(
        child: Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ),
    );
  }
}