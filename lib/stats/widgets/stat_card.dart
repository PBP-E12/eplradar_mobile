import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;
  final int value;
  final String label;

  const StatCard({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    const placeholder =
        "https://upload.wikimedia.org/wikipedia/commons/a/a3/Image-not-found.png";

    const String proxyBase =
        "https://raihan-maulana41-eplradar.pbp.cs.ui.ac.id/proxy-image/";

    String proxyImage(String url) {
      return "$proxyBase?url=${Uri.encodeComponent(url)}";
    }

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF333438),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              image.isNotEmpty ? proxyImage(image) : placeholder,
              width: 70,
              height: 70,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Image.network(placeholder);
              },
            ),
          ),
          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (subtitle.isNotEmpty)
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
          ),

          Column(
            children: [
              Text(
                "$value",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              Text(label, style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }
}
