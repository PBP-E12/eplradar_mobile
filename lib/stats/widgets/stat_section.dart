import 'package:flutter/material.dart';
import '../models/stats_model.dart';
import 'stat_card.dart';

class StatSection extends StatelessWidget {
  final String title;
  final List<dynamic> items;

  const StatSection({
    super.key,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Text(
          title,
          style: const TextStyle(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),

        ...items.map((item) {
          int value = 0;

          if (item is PlayerItem) {
            if (title == "Top Scorer") value = item.goals;
            if (title == "Top Assist") value = item.assists;
            if (title == "Clean Sheet") value = item.cleanSheet;
          } else if (item is ClubItem) {
            if (title == "Top Scorer") value = item.totalGoals;
            if (title == "Top Assist") value = item.totalAssists;
            if (title == "Clean Sheet") value = item.totalCleansheet;
          }

          return StatCard(
            image: item is PlayerItem ? item.photo : item.clubLogo,
            title: item is PlayerItem ? item.name : item.club,
            subtitle: item is PlayerItem ? item.club : "",
            value: value,
            label: title == "Top Assist"
                ? "Assist"
                : (title == "Clean Sheet" ? "Kali" : "Gol"),
          );
        }),

        const SizedBox(height: 20),
      ],
    );
  }
}
