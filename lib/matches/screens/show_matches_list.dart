import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:intl/intl.dart';
import 'package:eplradar_mobile/matches/model/match_model.dart';

class ShowMatchesList extends StatefulWidget {
  final int selectedWeek;

  const ShowMatchesList({super.key, required this.selectedWeek});

  @override
  State<ShowMatchesList> createState() => _ShowMatchesListState();
}

class _ShowMatchesListState extends State<ShowMatchesList> {
  Future<List<MatchModel>> fetchMatches(CookieRequest request) async {
    // Ganti dengan URL backend Anda
    String url = 'http://localhost:8000/matches/api/matches/?week=${widget.selectedWeek}';

    final response = await request.get(url);

    List<MatchModel> matches = [];
    for (var match in response) {
      matches.add(MatchModel.fromJson(match));
    }

    return matches;
  }

  Map<String, List<MatchModel>> _groupMatchesByDate(List<MatchModel> matches) {
    Map<String, List<MatchModel>> grouped = {};

    for (var match in matches) {
      String dateKey = DateFormat('yyyy-MM-dd').format(match.matchDate);
      if (!grouped.containsKey(dateKey)) {
        grouped[dateKey] = [];
      }
      grouped[dateKey]!.add(match);
    }

    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return FutureBuilder<List<MatchModel>>(
      future: fetchMatches(request),
      builder: (context, AsyncSnapshot<List<MatchModel>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF3247B1),
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 80,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${snapshot.error}',
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {});
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3247B1),
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.inbox,
                  size: 80,
                  color: Colors.grey,
                ),
                const SizedBox(height: 16),
                Text(
                  'Tidak ada pertandingan di Pekan ${widget.selectedWeek}.',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        } else {
          final groupedMatches = _groupMatchesByDate(snapshot.data!);
          final sortedDates = groupedMatches.keys.toList()..sort();

          return RefreshIndicator(
            onRefresh: () async {
              setState(() {});
            },
            color: const Color(0xFF3247B1),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF333438),
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListView.builder(
                itemCount: sortedDates.length,
                itemBuilder: (context, index) {
                  final dateKey = sortedDates[index];
                  final matchesOnDate = groupedMatches[dateKey]!;
                  final date = DateTime.parse(dateKey);

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Date Header
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Text(
                          DateFormat('EEEE, dd MMMM yyyy').format(date),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      // Matches for this date
                      ...matchesOnDate.map((match) => _buildMatchCard(match)),

                      if (index < sortedDates.length - 1)
                        const SizedBox(height: 24),
                    ],
                  );
                },
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildMatchCard(MatchModel match) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Home Team -> TODO: Masukin url logo tim nya
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: Text(
                    match.homeTeam,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.right,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 12),
                Image.network(
                  'http://localhost:8000/logotim.png',
                  width: 40,
                  height: 40,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.sports_soccer,
                        color: Colors.white54,
                        size: 20,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // VS Button
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF3247B1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Text(
              'VS',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // Away Team -> TODO: Masukin url logo tim nya
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.network(
                  'http://localhost:8000/logotim.png',
                  width: 40,
                  height: 40,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.sports_soccer,
                        color: Colors.white54,
                        size: 20,
                      ),
                    );
                  },
                ),
                const SizedBox(width: 12),
                Flexible(
                  child: Text(
                    match.awayTeam,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}