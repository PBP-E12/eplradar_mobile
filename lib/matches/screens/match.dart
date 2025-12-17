import 'package:eplradar_mobile/widgets/right_drawer.dart';
import 'package:flutter/material.dart';
import 'package:eplradar_mobile/matches/model/match_model.dart';
import 'package:eplradar_mobile/matches/screens/prediction_card.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MatchScreen extends StatefulWidget {
  const MatchScreen({super.key});

  @override
  State<MatchScreen> createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> {
  List<dynamic> klasemen = [];
  List<MatchModel> matches = [];
  List<ScorePredictionModel> predictions = [];
  
  bool isLoadingKlasemen = true;
  bool isLoadingMatches = true;
  bool isLoadingPredictions = true;
  
  String errorKlasemen = '';
  String errorMatches = '';
  String errorPredictions = '';

  @override
  void initState() {
    super.initState();
    fetchAllData();
  }

  Future<void> fetchAllData() async {
    await Future.wait([
      fetchKlasemen(),
      fetchMatches(),
      fetchPredictions(),
    ]);
  }

  Future<void> fetchKlasemen() async {
    setState(() {
      isLoadingKlasemen = true;
      errorKlasemen = '';
    });

    try {
      final response = await http.get(
        Uri.parse('http://localhost:8000/matches/api/klasemen/'),
      );

      if (response.statusCode == 200) {
        setState(() {
          klasemen = json.decode(response.body);
          isLoadingKlasemen = false;
        });
      } else {
        setState(() {
          errorKlasemen = 'Gagal memuat klasemen';
          isLoadingKlasemen = false;
        });
      }
    } catch (e) {
      setState(() {
        errorKlasemen = 'Error: $e';
        isLoadingKlasemen = false;
      });
    }
  }

  Future<void> fetchMatches() async {
    setState(() {
      isLoadingMatches = true;
      errorMatches = '';
    });

    try {
      final response = await http.get(
        Uri.parse('http://localhost:8000/matches/api/matches/'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          matches = data.map((json) => MatchModel.fromJson(json)).toList();
          isLoadingMatches = false;
        });
      } else {
        setState(() {
          errorMatches = 'Gagal memuat matches';
          isLoadingMatches = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMatches = 'Error: $e';
        isLoadingMatches = false;
      });
    }
  }

  Future<void> fetchPredictions() async {
    setState(() {
      isLoadingPredictions = true;
      errorPredictions = '';
    });

    try {
      final response = await http.get(
        Uri.parse('http://localhost:8000/matches/api/predictions/'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          predictions = data
              .map((json) => ScorePredictionModel.fromJson(json))
              .toList();
          isLoadingPredictions = false;
        });
      } else {
        setState(() {
          errorPredictions = 'Gagal memuat predictions';
          isLoadingPredictions = false;
        });
      }
    } catch (e) {
      setState(() {
        errorPredictions = 'Error: $e';
        isLoadingPredictions = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: RightDrawer(),
      backgroundColor: const Color(0xFF1A1C1E),
      appBar: AppBar(
        title: const Text(
          'EPL Radar',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF333438),
      ),
      body: RefreshIndicator(
        onRefresh: fetchAllData,
        color: const Color(0xFF3247B1),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Klasemen
              _buildSectionHeader('Klasemen'),
              _buildKlasemenSection(),
              
              const SizedBox(height: 24),
              
              // Match
              _buildSectionHeader('Pertandingan'),
              _buildMatchesSection(),
              
              const SizedBox(height: 24),
              
              // Prediksi
              _buildSectionHeader('Prediksi'),
              _buildPredictionsSection(),
              
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKlasemenSection() {
    if (isLoadingKlasemen) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: CircularProgressIndicator(color: Color(0xFF3247B1)),
        ),
      );
    }

    if (errorKlasemen.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          errorKlasemen,
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    if (klasemen.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          'Belum ada data klasemen',
          style: TextStyle(color: Colors.white54),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF333438),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.white10),
              ),
            ),
            child: Row(
              children: const [
                SizedBox(width: 30, child: Text('#', style: TextStyle(color: Colors.white70, fontSize: 12))),
                Expanded(child: Text('Tim', style: TextStyle(color: Colors.white70, fontSize: 12))),
                SizedBox(width: 40, child: Text('Main', style: TextStyle(color: Colors.white70, fontSize: 12), textAlign: TextAlign.center)),
                SizedBox(width: 40, child: Text('Poin', style: TextStyle(color: Colors.white70, fontSize: 12), textAlign: TextAlign.center)),
              ],
            ),
          ),
          // Rows - Tampilkan SEMUA data klasemen
          ...klasemen.map((club) => _buildKlasemenRow(club)).toList(),
        ],
      ),
    );
  }

  Widget _buildKlasemenRow(dynamic club) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white10)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 30,
            child: Text(
              '${club['rank']}',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(
              club['nama_klub'],
              style: const TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(
            width: 40,
            child: Text(
              '${club['total_matches']}',
              style: const TextStyle(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: 40,
            child: Text(
              '${club['poin']}',
              style: const TextStyle(
                color: Color(0xFF3247B1),
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMatchesSection() {
    if (isLoadingMatches) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: CircularProgressIndicator(color: Color(0xFF3247B1)),
        ),
      );
    }

    if (errorMatches.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          errorMatches,
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    if (matches.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          'Belum ada data pertandingan',
          style: TextStyle(color: Colors.white54),
        ),
      );
    }

    // Tampilkan SEMUA matches
    return Column(
      children: matches.map((match) => _buildMatchCard(match)).toList(),
    );
  }

  Widget _buildMatchCard(MatchModel match) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF333438),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Home team
          Expanded(
            child: Column(
              children: [
                Image.network(
                  'http://localhost:8000/static/img/club-matches/${match.homeTeam}.png',
                  width: 40,
                  height: 40,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.sports_soccer, color: Colors.white54, size: 40);
                  },
                ),
                const SizedBox(height: 8),
                Text(
                  match.homeTeam,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          // Score
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      '${match.homeScore}',
                      style: const TextStyle(
                        color: Color(0xFF3247B1),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text('-', style: TextStyle(color: Colors.white70, fontSize: 24)),
                    const SizedBox(width: 8),
                    Text(
                      '${match.awayScore}',
                      style: const TextStyle(
                        color: Color(0xFF3247B1),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Week ${match.week}',
                  style: const TextStyle(color: Colors.white54, fontSize: 10),
                ),
              ],
            ),
          ),
          // Away team
          Expanded(
            child: Column(
              children: [
                Image.network(
                  'http://localhost:8000/static/img/club-matches/${match.awayTeam}.png',
                  width: 40,
                  height: 40,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.sports_soccer, color: Colors.white54, size: 40);
                  },
                ),
                const SizedBox(height: 8),
                Text(
                  match.awayTeam,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPredictionsSection() {
    if (isLoadingPredictions) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: CircularProgressIndicator(color: Color(0xFF3247B1)),
        ),
      );
    }

    if (errorPredictions.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          errorPredictions,
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    if (predictions.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          'Belum ada prediksi',
          style: TextStyle(color: Colors.white54),
        ),
      );
    }

    return Column(
      children: predictions.map((pred) => PredictionCard(prediction: pred)).toList(),
    );
  }
}