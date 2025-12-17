import 'package:flutter/material.dart';
import 'package:eplradar_mobile/matches/model/match_model.dart';
import 'package:intl/intl.dart';

class PredictionCard extends StatelessWidget {
  final ScorePredictionModel prediction;

  const PredictionCard({super.key, required this.prediction});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF333438),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User info and date
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Oleh: ${prediction.user.username}',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
              Text(
                DateFormat('dd MMM yyyy').format(prediction.match.matchDate),
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 11,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Match prediction
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Home team
              Expanded(
                child: Column(
                  children: [
                    Image.network(
                      'http://localhost:8000/static/img/club-matches/${prediction.match.homeTeam}.png',
                      width: 40,
                      height: 40,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.sports_soccer,
                          color: Colors.white54,
                          size: 40,
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    Text(
                      prediction.match.homeTeam,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),

              // Score
              Column(
                children: [
                  Row(
                    children: [
                      Text(
                        '${prediction.homeScorePrediction}',
                        style: const TextStyle(
                          color: Color(0xFF3247B1),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        '-',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${prediction.awayScorePrediction}',
                        style: const TextStyle(
                          color: Color(0xFF3247B1),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Prediksi',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),

              // Away team
              Expanded(
                child: Column(
                  children: [
                    Image.network(
                      'http://localhost:8000/static/img/club-matches/${prediction.match.awayTeam}.png',
                      width: 40,
                      height: 40,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.sports_soccer,
                          color: Colors.white54,
                          size: 40,
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    Text(
                      prediction.match.awayTeam,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Created at info
          Center(
            child: Text(
              'Diprediksi pada: ${DateFormat('dd MMM yyyy, HH:mm').format(prediction.createdAt)}',
              style: const TextStyle(
                color: Colors.white38,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}