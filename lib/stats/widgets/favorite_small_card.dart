// lib/stats/widgets/favorite_small_card.dart
import 'package:flutter/material.dart';

class FavoriteCardSmall extends StatelessWidget {
  final String image;
  final String name;
  final String club;
  final VoidCallback onDelete;
  final VoidCallback onTapEdit;

  const FavoriteCardSmall({
    super.key,
    required this.image,
    required this.name,
    required this.club,
    required this.onDelete,
    required this.onTapEdit,
  });

  @override
  Widget build(BuildContext context) {
    const String domain = "https://raihan-maulana41-eplradar.pbp.cs.ui.ac.id";

    const String placeholder =
        "https://upload.wikimedia.org/wikipedia/commons/a/a3/Image-not-found.png";

    String resolveImage(String path) {
      if (path.isEmpty) return placeholder;
      if (path.startsWith("http")) return path;
      if (path.startsWith("/")) return "$domain$path";
      return "$domain/$path";
    }

    return GestureDetector(
      onTap: onTapEdit,
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF3A3B3E),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                resolveImage(image),
                width: 55,
                height: 55,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.network(
                    placeholder,
                    width: 55,
                    height: 55,
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    club,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),

            IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
