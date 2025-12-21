import 'package:eplradar_mobile/screens/login.dart';
import 'package:eplradar_mobile/widgets/right_drawer.dart';
import 'package:flutter/material.dart';
import 'package:eplradar_mobile/matches/model/match_model.dart';
import 'package:eplradar_mobile/matches/screens/prediction_card.dart';
import 'package:http/http.dart' as http;
import 'package:pbp_django_auth/pbp_django_auth.dart';

import 'dart:convert';

import 'package:provider/provider.dart';

class MatchScreen extends StatefulWidget {
  static const routeName = '/match';
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

  ScorePredictionModel? editingPrediction;

  String errorKlasemen = '';
  String errorMatches = '';
  String errorPredictions = '';

  int? selectedWeek;

  MatchModel? selectedMatch;
  int homeScore = 0;
  int awayScore = 0;
  int userId = 1;

  late ScrollController _scrollController;


  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    fetchAllData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
        Uri.parse('https://raihan-maulana41-eplradar.pbp.cs.ui.ac.id/matches/api/klasemen/'),
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
        Uri.parse('https://raihan-maulana41-eplradar.pbp.cs.ui.ac.id/matches/api/matches/'),
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
        Uri.parse('https://raihan-maulana41-eplradar.pbp.cs.ui.ac.id/matches/api/predictions/'),
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
      endDrawer: const RightDrawer(),
      backgroundColor: const Color(0xFF1A1C1E),
      appBar: AppBar(
        title: const Text(
          'Match',
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
        onRefresh: fetchAllData,
        color: const Color(0xFF3247B1),
        child: SingleChildScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeroSection(),
              // Klasemen
              const SizedBox(height: 20),
              _buildSectionHeader('Klasemen'),
              const SizedBox(height: 4),
              _buildKlasemenSection(),
              
              const SizedBox(height: 24),
              
              // Match
              _buildMatchHeader(),
              const SizedBox(height: 4),
              _buildMatchesSection(),
              
              const SizedBox(height: 24),
              
              // Prediksi
              _buildPredictionHeader(),
              const SizedBox(height: 4),
              _buildPredictionsSection(),
              
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      height: 280,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/match.png"),
          fit: BoxFit.cover,
          opacity: 0.75,
        ),
      ),
      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 28),
      alignment: Alignment.bottomLeft,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Match",
            style: TextStyle(
              color: Colors.white,
              fontSize: 42,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Dapatkan informasi terkait pertandingan dan klasemen tim favoritmu di musim ini!",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 15,
            ),
          ),
          SizedBox(height: 20),
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
            child: const Text("Lihat Seluruh Pertandingan"),
          ),
          SizedBox(height: 36),
        ],
      ),
    );
  }

  Widget _buildMatchHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          const Text(
            'Pertandingan',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          _buildWeekFilterInline(),
        ],
      ),
    );
  }

  Widget _buildWeekFilterInline() {
    final weeks = matches.map((m) => m.week).toSet().toList()..sort();

    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF3247B1),
        borderRadius: BorderRadius.circular(28),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int?>(
          value: selectedWeek,
          isDense: true,
          dropdownColor: const Color(0xFF3247B1),
          style: const TextStyle(color: Colors.white, fontSize: 12),
          items: [
            const DropdownMenuItem<int?>(
              value: null,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Semua Pekan"),
                ],
              ),
            ),
            ...weeks.map((week) {
              return DropdownMenuItem<int?>(
                value: week,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Pekan ke-$week"),
                  ],
                ),
              );
            }),
          ],
          onChanged: (value) {
            setState(() {
              selectedWeek = value;
            });
          },
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
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.white10),
              ),
            ),
            child: Row(
              children: const [
                Expanded(child: Text('Teams', style: TextStyle(color: Colors.white70, fontSize: 12))),
                SizedBox(width: 40, child: Text('Match', style: TextStyle(color: Colors.white70, fontSize: 12), textAlign: TextAlign.center)),
                SizedBox(width: 48, child: Text('Win', style: TextStyle(color: Colors.white70, fontSize: 12), textAlign: TextAlign.center)),
                SizedBox(width: 40, child: Text('Draw', style: TextStyle(color: Colors.white70, fontSize: 12), textAlign: TextAlign.center)),
                SizedBox(width: 40, child: Text('Lose', style: TextStyle(color: Colors.white70, fontSize: 12), textAlign: TextAlign.center)),
                SizedBox(width: 40, child: Text('Point', style: TextStyle(color: Colors.white70, fontSize: 12), textAlign: TextAlign.center)),
              ],
            ),
          ),
          // Tampilkan semua data klasemen
          ...klasemen.map((club) => _buildKlasemenRow(club)).toList(),
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
              '${club['jumlah_win']}',
              style: const TextStyle(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: 40,
            child: Text(
              '${club['jumlah_draw']}',
              style: const TextStyle(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: 40,
            child: Text(
              '${club['jumlah_lose']}',
              style: const TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: 40,
            child: Text(
              '${club['poin']}',
              style: const TextStyle(color: Colors.blueAccent),
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
    
    final filteredMatch = selectedWeek == null ? matches : matches.where((match) => match.week == selectedWeek).toList();

    if (filteredMatch.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          'Belum ada data pertandingan',
          style: TextStyle(color: Colors.white54),
        ),
      );
    }

    return Column(
      children: filteredMatch.map(_buildMatchCard).toList(),
    );
  }

  Widget _buildMatchCard(MatchModel match){
    final logoUrlHome = _getLogoUrl(match.homeTeam);
    final logoUrlAway = _getLogoUrl(match.awayTeam);

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
                  logoUrlHome,
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
                        color: Colors.blueAccent,
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
                        color: Colors.blueAccent,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Week ${match.week}',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          // Away team
          Expanded(
            child: Column(
              children: [
                Image.network(
                  logoUrlAway,
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
    final req = context.watch<CookieRequest>();
    final String? username = req.jsonData["username"];
    final bool isLoggedIn =
        req.loggedIn && username != null && username.trim().isNotEmpty;

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

    return Column(
      children: [
        if (!isLoggedIn)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Text(
                    'Login untuk menambahkan prediksi',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                    child: const Text('Login'),
                  ),
                ],
              ),
            ),
          ),

        if (predictions.isEmpty)
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Belum ada prediksi',
              style: TextStyle(color: Colors.grey),
            ),
          )
        else
          ...predictions.map((pred) {
            return PredictionCard(
              prediction: pred,
              isOwner: username != null && pred.user.username == username,
              onEdit: () {
                editingPrediction = pred;
                selectedMatch = matches.firstWhere((m) => m.id == pred.match.id);
                homeScore = pred.homeScorePrediction;
                awayScore = pred.awayScorePrediction;

                _showPredictionDialog();
              },
              onDelete: () {
                deletePrediction(pred.id);
              },
            );
          }).toList(),
      ],
    );
  }

  Widget _buildPredictionHeader() {
    final req = context.watch<CookieRequest>();
    final String? username = req.jsonData["username"];
    final bool isLoggedIn =
        req.loggedIn && username != null && username.trim().isNotEmpty;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          const Text(
            'Prediksi',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),

          if (isLoggedIn)
            IconButton(
              icon: const Icon(Icons.add, color: Colors.white),
              onPressed: _showPredictionDialog,
            ),
        ],
      ),
    );
  }

  void _showPredictionDialog() {
    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          backgroundColor: const Color(0xFF1A1C1E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Prediksi Skor',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Tebak skor pertandingan tim favoritmu!',
                  style: TextStyle(color: Colors.white54),
                ),
                const SizedBox(height: 20),

                /// Dropdown Match
                DropdownButtonFormField<MatchModel>(
                  dropdownColor: const Color(0xFF333438),
                  items: matches.map((m) {
                    return DropdownMenuItem(
                      value: m,
                      child: Text(
                        '${m.homeTeam} vs ${m.awayTeam}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  }).toList(),
                  onChanged: (v) => selectedMatch = v,
                  decoration: _inputDecoration('Pilih Pertandingan'),
                ),

                const SizedBox(height: 20),

                /// Score Input
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _scoreBox(homeScore, (v) => homeScore = v),
                    const Text(
                      ':',
                      style: TextStyle(color: Colors.white, fontSize: 22),
                    ),
                    _scoreBox(awayScore, (v) => awayScore = v),
                  ],
                ),

                const SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.redAccent,
                          side: const BorderSide(color: Colors.redAccent),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Batal'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          foregroundColor: Colors.white,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: _submitPrediction,
                        child: const Text('Simpan Prediksi'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _scoreBox(int value, Function(int) onChanged) {
    return Container(
      width: 60,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF333438),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white, fontSize: 18),
        decoration: const InputDecoration(border: InputBorder.none),
        onChanged: (v) {
          onChanged(int.tryParse(v) ?? 0);
        },
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      filled: true,
      fillColor: const Color(0xFF333438),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }

  Future<void> _submitPrediction() async {
    if (selectedMatch == null) return;

    final req = context.read<CookieRequest>();

    if(editingPrediction == null){
      final response = await req.postJson(
        'https://raihan-maulana41-eplradar.pbp.cs.ui.ac.id/matches/api/predictions/create/',
        jsonEncode({
          'match_id': selectedMatch!.id,
          'home_score_prediction': homeScore,
          'away_score_prediction': awayScore,
        }),
      );

      if (response['status'] == 'success') {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Prediksi Berhasil Disimpan'),
          ),
        );
        fetchPredictions();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['message'] ?? 'Gagal menyimpan prediksi'),
          ),
        );
      }
    }
    else{
      final response = await req.postJson(
        'https://raihan-maulana41-eplradar.pbp.cs.ui.ac.id/matches/api/predictions/${editingPrediction!.id}/update/',
        jsonEncode({
          'home_score_prediction': homeScore,
          'away_score_prediction': awayScore,
        }),
      );

      if (response['status'] == 'success') {
        editingPrediction = null;
        Navigator.pop(context);
        fetchPredictions();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Prediksi Berhasil Diedit'),
          ),
        );
      }
    }
  }

  Future<void> updatePrediction(int predictionId) async {
    await http.put(
      Uri.parse(
        'https://raihan-maulana41-eplradar.pbp.cs.ui.ac.id/matches/api/predictions/$predictionId/update/',
      ),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'home_score_prediction': homeScore,
        'away_score_prediction': awayScore,
      }),
    );

    fetchPredictions();
  }

  Future<void> deletePrediction(int predictionId) async {
    await http.delete(
      Uri.parse(
        'https://raihan-maulana41-eplradar.pbp.cs.ui.ac.id/matches/api/predictions/$predictionId/delete/',
      ),
    );

    fetchPredictions();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Berhasil Menghapus Prediksi'),
      ),
    );
  }

  String replaceSpacing(String clubName) {
    return clubName.toLowerCase().replaceAll(' ', '_');
  }

   String _getLogoUrl(String logoFilename) {
    final cleanFilename = logoFilename.replaceAll('.png', '');
    final filenameWithSpace = cleanFilename.replaceAll('_', ' ');
    final encodedFilename = Uri.encodeComponent(filenameWithSpace);
    return 'https://raihan-maulana41-eplradar.pbp.cs.ui.ac.id/static/img/club-matches/$encodedFilename.png';
  }
}