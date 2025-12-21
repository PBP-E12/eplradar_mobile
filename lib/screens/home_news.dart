import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

import 'package:eplradar_mobile/news/models/news_entry.dart';
import 'package:eplradar_mobile/news/screens/news_detail.dart';
import 'package:eplradar_mobile/news/screens/news.dart';

class HomeNews extends StatelessWidget {
  const HomeNews({super.key});

  Future<List<NewsEntry>> fetchLatestNews(CookieRequest request) async {
    final response = await request.get(
      'https://raihan-maulana41-eplradar.pbp.cs.ui.ac.id/news/json/news_list',
    );

    List<NewsEntry> listNews = [];
    for (var d in response) {
      listNews.add(NewsEntry.fromJson(d));
    }

    // sort terbaru & ambil 3
    listNews.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return listNews.take(3).toList();
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    const Color cardColor = Color(0xFF2A2D32);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Berita Terbaru",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, NewsPage.routeName);
                },
                child: const Text(
                  "Lihat Semua Berita →",
                  style: TextStyle(color: Colors.blueAccent),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          /// LIST BERITA
          FutureBuilder<List<NewsEntry>>(
            future: fetchLatestNews(request),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Text(
                    "Belum ada berita.",
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              }

              return Column(
                children: snapshot.data!
                    .map((news) => _buildNewsCard(context, news, cardColor))
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNewsCard(
      BuildContext context, NewsEntry news, Color cardColor) {
    const String baseUrl =
        'https://raihan-maulana41-eplradar.pbp.cs.ui.ac.id';

    return Card(
      color: cardColor,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => NewsDetailPage(news: news),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// THUMBNAIL
            SizedBox(
              height: 160,
              width: double.infinity,
              child: Image.network(
                news.thumbnail.startsWith('http')
                    ? news.thumbnail
                    : '$baseUrl/media/${news.thumbnail}',
                fit: BoxFit.cover,
              ),
            ),

            /// CONTENT
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${news.category} • "
                    "${news.createdAt.day}/${news.createdAt.month}/${news.createdAt.year}",
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    news.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
