// Lokasi: lib/screens/news.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

// Pastikan import ini mengarah ke file model yang benar
import '../models/news_entry.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {

  Future<List<NewsEntry>> fetchNews(CookieRequest request) async {
    // Sesuaikan URL. Gunakan 10.0.2.2 untuk Android Emulator.
    final response = await request.get('http://127.0.0.1:8000/news/json/news_list');

    var data = response;

    List<NewsEntry> listNews = [];
    for (var d in data) {
      if (d != null) {
        listNews.add(NewsEntry.fromJson(d));
      }
    }
    return listNews;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('News List'),
      ),
      body: FutureBuilder(
        future: fetchNews(request),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
             return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text(
                  'Belum ada berita tersimpan.',
                  style: TextStyle(fontSize: 20, color: Colors.grey),
                ),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (_, index) {
                  NewsEntry news = snapshot.data![index];
                  
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Judul
                          Text(
                            news.title,
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          
                          // Kategori
                          Text(
                            news.category,
                             style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.blue[600],
                              fontWeight: FontWeight.w500
                            ),
                          ),
                          const SizedBox(height: 10),
                          
                          // Konten (Safe Mode: Pakai maxLines, bukan substring)
                          Text(
                            news.content, 
                            maxLines: 2, 
                            overflow: TextOverflow.ellipsis, 
                          ),
                          const SizedBox(height: 10),

                          // Footer: HANYA MENAMPILKAN VIEWS
                          Text(
                            "Views: ${news.newsViews}",
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          }
        },
      ),
    );
  }
}