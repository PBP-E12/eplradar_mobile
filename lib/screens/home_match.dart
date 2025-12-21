import 'package:flutter/material.dart';
import 'package:eplradar_mobile/matches/model/match_model.dart';
import 'package:eplradar_mobile/matches/screens/match.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class HomeMatch extends StatefulWidget {
  const HomeMatch({super.key});

  @override
  State<HomeMatch> createState() => _HomeMatchState();
}

class _HomeMatchState extends State<HomeMatch> {
  List<dynamic> klasemen = [];
  List<MatchModel> matches = [];

  bool isLoadingKlasemen = true;
  bool isLoadingMatches = true;

  String errorKlasemen = '';
  String errorMatches = '';

  @override
  void initState() {
    super.initState();
    fetchHomeData();
  }

  Future<void> fetchHomeData() async {
    await Future.wait([
      fetchKlasemen(),
      fetchMatches(),
    ]);
  }

 Future<void> fetchKlasemen() async {
    try {
      final request = context.read<CookieRequest>();
      final response = await request.get(
        'https://raihan-maulana41-eplradar.pbp.cs.ui.ac.id/matches/api/klasemen/',
      );

      setState(() {
        klasemen = response;
        isLoadingKlasemen = false;
      });
    } catch (e) {
      setState(() {
        errorKlasemen = e.toString();
        isLoadingKlasemen = false;
      });
    }
  }

  Future<void> fetchMatches() async {
    try {
      final request = context.read<CookieRequest>();
      final data = await request.get(
        'https://raihan-maulana41-eplradar.pbp.cs.ui.ac.id/matches/api/matches/',
      );

      setState(() {
        matches = (data as List).map((e) => MatchModel.fromJson(e)).toList();
        isLoadingMatches = false;
      });
    } catch (e) {
      setState(() {
        errorMatches = e.toString();
        isLoadingMatches = false;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTop5Klasemen(),
          const SizedBox(height: 32),
          _buildPertandinganTerakhir(),
        ],
      ),
    );
  }

  Widget _buildTop5Klasemen() {
    if (isLoadingKlasemen) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF3247B1)),
      );
    }

    final top5 = klasemen.take(5).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(
          title: 'Klasemen Teratas',
          onTap: () {
            Navigator.pushNamed(context, MatchScreen.routeName);
          },
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF333438),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              _klasemenTableHeader(),
              ...top5.map(_buildKlasemenRow).toList(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _klasemenTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white10)),
      ),
      child: Row(
        children: const [
          SizedBox(width: 24),
          Expanded(
            child: Text(
              'Teams',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ),
          _HeaderCell('Match'),
          _HeaderCell('Win'),
          _HeaderCell('Draw'),
          _HeaderCell('Lose'),
          _HeaderCell('Point'),
        ],
      ),
    );
  }

  Widget _buildKlasemenRow(dynamic club) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white10)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            child: Text(
              '${club['rank']}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              club['nama_klub'],
              style: const TextStyle(color: Colors.white),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          _smallCell('${club['total_matches']}'),
          _smallCell('${club['jumlah_win']}'),
          _smallCell('${club['jumlah_draw']}'),
          _smallCell('${club['jumlah_lose']}'),
          _smallCell(
            '${club['poin']}',
            color: Colors.blueAccent,
            bold: true,
          ),
        ],
      ),
    );
  }

  Widget _buildPertandinganTerakhir() {
    if (isLoadingMatches) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF3247B1)),
      );
    }

    final list = matches.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(
          title: 'Pertandingan Terakhir',
          onTap: () {
            Navigator.pushNamed(context, MatchScreen.routeName);
          },
        ),
        const SizedBox(height: 12),
        Column(
          children: list.map(_buildMatchCard).toList(),
        ),
      ],
    );
  }

  Widget _buildMatchCard(MatchModel match) {
    final logoUrlHome = _getLogoUrl(match.homeTeam);
    final logoUrlAway = _getLogoUrl(match.awayTeam);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF333438),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Home Team
          Image.network(
            logoUrlHome,
            width: 28,
            height: 28,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(
                Icons.sports_soccer,
                color: Colors.white54,
                size: 28,
              );
            },
          ),
          const SizedBox(width: 8),

          Expanded(
            child: Text(
              match.homeTeam,
              style: const TextStyle(color: Colors.white),
              overflow: TextOverflow.ellipsis,
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              '${match.homeScore} - ${match.awayScore}',
              style: const TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),

          // Away Team
          Expanded(
            child: Text(
              match.awayTeam,
              textAlign: TextAlign.end,
              style: const TextStyle(color: Colors.white),
              overflow: TextOverflow.ellipsis,
            ),
          ),

          const SizedBox(width: 8),

          Image.network(
            logoUrlAway,
            width: 28,
            height: 28,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(
                Icons.sports_soccer,
                color: Colors.white54,
                size: 28,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader({
    required String title,
    required VoidCallback onTap,
  }) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        TextButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => MatchScreen()));
          },
          child: const Text(
            "Lihat Semua →",
            style: TextStyle(color: Colors.blueAccent),
          ),
        ),
      ],
    );
  }

  Widget _smallCell(
    String text, {
    Color color = Colors.white70,
    bool bold = false,
  }) {
    return SizedBox(
      width: 40,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: color,
          fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  final String text;
  const _HeaderCell(this.text);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white70, fontSize: 12),
      ),
    );
  }

}

  String _getLogoUrl(String logoFilename) {
    final cleanFilename = logoFilename.replaceAll('.png', '');
    final filenameWithSpace = cleanFilename.replaceAll('_', ' ');
    final encodedFilename = Uri.encodeComponent(filenameWithSpace);
    return 'https://raihan-maulana41-eplradar.pbp.cs.ui.ac.id/static/img/club-matches/$encodedFilename.png';
  }

