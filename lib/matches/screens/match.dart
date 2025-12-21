import 'package:eplradar_mobile/screens/login.dart';
import 'package:eplradar_mobile/widgets/right_drawer.dart';
import 'package:flutter/material.dart';
import 'package:eplradar_mobile/matches/model/match_model.dart';
import 'package:eplradar_mobile/matches/screens/prediction_card.dart';
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

  late ScrollController _scrollController;
  final TextEditingController _homeScoreController = TextEditingController();
  final TextEditingController _awayScoreController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    fetchAllData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _homeScoreController.dispose();
    _awayScoreController.dispose();
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
      final request = context.read<CookieRequest>();
      final data = await request.get(
        'https://raihan-maulana41-eplradar.pbp.cs.ui.ac.id/matches/api/matches/',
      );

      setState(() {
        matches = (data as List).map((json) => MatchModel.fromJson(json)).toList();
        isLoadingMatches = false;
      });
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
      final request = context.read<CookieRequest>();
      final data = await request.get(
        'https://raihan-maulana41-eplradar.pbp.cs.ui.ac.id/matches/api/predictions/',
      );

      setState(() {
        predictions = (data as List)
            .map((json) => ScorePredictionModel.fromJson(json))
            .toList();
        isLoadingPredictions = false;
      });
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
              const SizedBox(height: 20),
              _buildSectionHeader('Klasemen'),
              const SizedBox(height: 4),
              _buildKlasemenSection(),
              
              const SizedBox(height: 24),
              
              _buildMatchHeader(),
              const SizedBox(height: 4),
              _buildMatchesSection(),
              
              const SizedBox(height: 24),
              
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
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/match.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Match",
            style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            "Dapatkan informasi terkait pertandingan dan klasemen tim favoritmu di musim ini!",
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
            child: const Text("Lihat Jadwal Pertandingan"),
          )
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
              child: Text("Semua Pekan"),
            ),
            ...weeks.map((week) {
              return DropdownMenuItem<int?>(
                value: week,
                child: Text("Pekan ke-$week"),
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
    
    final filteredMatches = selectedWeek == null ? matches : matches.where((match) => match.week == selectedWeek).toList();

    if (filteredMatches.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          'Belum ada data pertandingan',
          style: TextStyle(color: Colors.white54),
        ),
      );
    }

    return Column(
      children: filteredMatches.map(_buildMatchCard).toList(),
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
    final request = context.watch<CookieRequest>();
    final String? username = request.jsonData["username"];
    final bool isLoggedIn =
        request.loggedIn && username != null && username.trim().isNotEmpty;

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
            return PredictionCard(  // REMOVED const from here
              prediction: pred,
              isOwner: username != null && pred.user.username == username,
              onEdit: () {
                setState(() {
                  editingPrediction = pred;
                  selectedMatch = matches.firstWhere((m) => m.id == pred.match.id);
                  homeScore = pred.homeScorePrediction;
                  awayScore = pred.awayScorePrediction;
                });
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
    final request = context.watch<CookieRequest>();
    final String? username = request.jsonData["username"];
    final bool isLoggedIn =
        request.loggedIn && username != null && username.trim().isNotEmpty;

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
              onPressed: () {
                setState(() {
                  editingPrediction = null;
                  selectedMatch = null;
                  homeScore = 0;
                  awayScore = 0;
                  _homeScoreController.clear();
                  _awayScoreController.clear();
                });
                _showPredictionDialog();
              },
            ),
        ],
      ),
    );
  }

  void _showPredictionDialog() {
    _homeScoreController.text = homeScore.toString();
    _awayScoreController.text = awayScore.toString();

    showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
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
                    Text(
                      editingPrediction == null ? 'Prediksi Skor' : 'Edit Prediksi Skor',
                      style: const TextStyle(
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

                    DropdownButtonFormField<MatchModel>(
                      value: selectedMatch,
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
                      onChanged: editingPrediction == null
                          ? (v) {
                              setDialogState(() {
                                selectedMatch = v;
                              });
                            }
                          : null,
                      decoration: _inputDecoration('Pilih Pertandingan'),
                    ),

                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _scoreBox(_homeScoreController, (v) {
                          homeScore = v;
                        }),
                        const Text(
                          ':',
                          style: TextStyle(color: Colors.white, fontSize: 22),
                        ),
                        _scoreBox(_awayScoreController, (v) {
                          awayScore = v;
                        }),
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
      },
    );
  }

  Widget _scoreBox(TextEditingController controller, Function(int) onChanged) {
    return Container(
      width: 60,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF333438),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
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
    if (selectedMatch == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih pertandingan terlebih dahulu'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final request = context.read<CookieRequest>();

    try {
      if (editingPrediction == null) {
        final response = await request.postJson(
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
            const SnackBar(
              content: Text('Prediksi Berhasil Disimpan'),
              backgroundColor: Colors.white,
            ),
          );
          
          setState(() {
            selectedMatch = null;
            homeScore = 0;
            awayScore = 0;
            _homeScoreController.clear();
            _awayScoreController.clear();
          });
          
          await fetchPredictions();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response['message'] ?? 'Gagal menyimpan prediksi'),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      } else {
        final response = await request.postJson(
          'https://raihan-maulana41-eplradar.pbp.cs.ui.ac.id/matches/api/predictions/${editingPrediction!.id}/update/',
          jsonEncode({
            'home_score_prediction': homeScore,
            'away_score_prediction': awayScore,
          }),
        );

        if (response['status'] == 'success') {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Prediksi Berhasil Diedit'),
              backgroundColor: Colors.white,
            ),
          );
          
          setState(() {
            editingPrediction = null;
            selectedMatch = null;
            homeScore = 0;
            awayScore = 0;
            _homeScoreController.clear();
            _awayScoreController.clear();
          });
          
          await fetchPredictions();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response['message'] ?? 'Gagal mengedit prediksi'),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  Future<void> deletePrediction(int predictionId) async {
    final request = context.read<CookieRequest>();
    
    try {
      final response = await request.postJson(
        'https://raihan-maulana41-eplradar.pbp.cs.ui.ac.id/matches/api/predictions/$predictionId/delete/',
        jsonEncode({}),
      );

      if (response['status'] == 'success') {
        await fetchPredictions();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Prediksi Berhasil Dihapus'),
              backgroundColor: Colors.white,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response['message'] ?? 'Gagal menghapus prediksi'),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  String _getLogoUrl(String logoFilename) {
    final cleanFilename = logoFilename.replaceAll('.png', '');
    final filenameWithSpace = cleanFilename.replaceAll('_', ' ');
    final encodedFilename = Uri.encodeComponent(filenameWithSpace);
    return 'https://raihan-maulana41-eplradar.pbp.cs.ui.ac.id/static/img/club-matches/$encodedFilename.png';
  }
}