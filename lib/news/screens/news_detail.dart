import 'package:flutter/material.dart';
import '../models/news_entry.dart';

class NewsDetailPage extends StatelessWidget {
  final NewsEntry news;

  const NewsDetailPage({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    // Base URL untuk gambar (sesuaikan dengan URL Django Anda)
    // Jika thumbnail sudah berisi URL lengkap, bagian ini tidak perlu
    const String baseUrl = 'http://127.0.0.1:8000'; 

    return Scaffold(
      backgroundColor: const Color(0xFF1D1F22), // Background gelap sesuai screenshot
      appBar: AppBar(
        title: const Text('Detail Berita'),
        backgroundColor: const Color(0xFF1D1F22),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar Utama
            SizedBox(
              width: double.infinity,
              height: 250,
              child: Image.network(
                // Cek apakah thumbnail url absolut atau relatif
                news.thumbnail.startsWith('http') 
                    ? news.thumbnail 
                    : '$baseUrl/media/${news.thumbnail}', // Sesuaikan path media Django
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey,
                    child: const Center(child: Icon(Icons.broken_image, color: Colors.white)),
                  );
                },
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Label Kategori & Tanggal
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          news.category,
                          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "${news.createdAt.day}-${news.createdAt.month}-${news.createdAt.year}",
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Judul Besar
                  Text(
                    news.title,
                    style: const TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Penulis & Views
                  Row(
                    children: [
                      const Icon(Icons.person, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(news.user, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                      const SizedBox(width: 16),
                      const Icon(Icons.remove_red_eye, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text("${news.newsViews} views", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Divider(color: Colors.grey),
                  const SizedBox(height: 20),

                  // Konten Berita
                  Text(
                    news.content,
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.white70,
                      height: 1.5,
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