import 'package:flutter/material.dart';
import 'package:eplradar_mobile/matches/model/match_model.dart';
import 'package:intl/intl.dart';

class PredictionCard extends StatelessWidget {
  final ScorePredictionModel prediction;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool isOwner;

  const PredictionCard({
    super.key,
    required this.prediction,
    this.onEdit,
    this.onDelete,
    required this.isOwner,
  });

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
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                  children: [
                    const TextSpan(text: 'Dibuat oleh '),
                    TextSpan(
                      text: prediction.user.username,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                DateFormat('dd MMM yyyy').format(prediction.createdAt),
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Match prediction
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Home team
              Expanded(
                child: Column(
                  children: [
                    Image.asset(
                      'images/clubs/${replaceSpacing(prediction.match.homeTeam)}.png',
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
                          color: Colors.blue,
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
                          color: Colors.blueAccent,
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
                      fontSize: 12,
                    ),
                  ),
                ],
              ),

              // Away team
              Expanded(
                child: Column(
                  children: [
                    Image.network(
                      'images/clubs/${replaceSpacing(prediction.match.awayTeam)}.png',
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

          const SizedBox(height: 16),

          if (isOwner)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: onEdit,
                  child: const Text(
                    'Edit',
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: 13,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                GestureDetector(
                  onTap: onDelete,
                  child: const Text(
                    'Hapus',
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  String replaceSpacing(String clubName) {
    return clubName.toLowerCase().replaceAll(' ', '_');
  }
}