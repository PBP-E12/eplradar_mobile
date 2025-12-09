import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import '../models/news_entry.dart';
import 'news_detail.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  final ScrollController _scrollController = ScrollController();
  
  String selectedCategory = "Semua";
  String selectedSort = "Terbaru";
  
  final List<String> categories = [
    "Semua",
    "Transfer",
    "Update",
    "Exclusive",
    "Match",
    "Rumor",
    "Analysis"
  ];

  Future<List<NewsEntry>> fetchNews(CookieRequest request) async {
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

  List<NewsEntry> _filterAndSortNews(List<NewsEntry> originalList) {
    List<NewsEntry> filteredList = List.from(originalList);

    if (selectedCategory != "Semua") {
      filteredList = filteredList.where((news) => 
        news.category.toLowerCase() == selectedCategory.toLowerCase()
      ).toList();
    }

    if (selectedSort == "Terbaru") {
      filteredList.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } else {
      filteredList.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    }

    return filteredList;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    const Color bgColor = Color(0xFF1D1F22);
    const Color cardColor = Color(0xFF2A2D32);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text('EPL Radar'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/hero_news.jpg'), 
                  fit: BoxFit.cover,
                  opacity: 0.4,
                ),
                color: Colors.black,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Berita",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Temukan berita terpercaya terkait bursa transfer, hasil pertandingan, dan berita menarik lainnya.",
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
                    child: const Text("Lihat Berita"),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Berita Terkini",
                    style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  const Text("Login untuk menambahkan berita.", style: TextStyle(color: Colors.grey, fontSize: 12)),
                  const SizedBox(height: 15),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildCustomDropdown(
                          value: selectedCategory,
                          items: categories,
                          onChanged: (val) {
                            setState(() {
                              selectedCategory = val!;
                            });
                          },
                        ),
                        const SizedBox(width: 10),
                        _buildCustomDropdown(
                          value: selectedSort,
                          items: ["Terbaru", "Terlama"],
                          onChanged: (val) {
                            setState(() {
                              selectedSort = val!;
                            });
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            FutureBuilder(
              future: fetchNews(request),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: CircularProgressIndicator(),
                  ));
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}", style: const TextStyle(color: Colors.white)));
                } else {
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(40.0),
                        child: Text('Belum ada berita tersimpan.', style: TextStyle(color: Colors.grey)),
                      ),
                    );
                  } else {
                    List<NewsEntry> displayedNews = _filterAndSortNews(snapshot.data!);

                    if (displayedNews.isEmpty) {
                       return const Center(
                         child: Padding(
                           padding: EdgeInsets.all(40.0),
                           child: Text('Tidak ada berita di kategori ini.', style: TextStyle(color: Colors.grey))
                         )
                       );
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: displayedNews.length,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemBuilder: (_, index) {
                        return _buildNewsCard(context, displayedNews[index], cardColor);
                      },
                    );
                  }
                }
              },
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomDropdown({
    required String value, 
    required List<String> items, 
    required Function(String?) onChanged
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2D32),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade800),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: items.contains(value) ? value : items.first,
          dropdownColor: const Color(0xFF2A2D32),
          style: const TextStyle(color: Colors.white, fontSize: 14),
          icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
          onChanged: onChanged,
          items: items.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildNewsCard(BuildContext context, NewsEntry news, Color cardColor) {
    const String baseUrl = 'http://127.0.0.1:8000'; 

    return Card(
      color: cardColor,
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewsDetailPage(news: news),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 200,
              width: double.infinity,
              child: Image.network(
                 news.thumbnail.startsWith('http') 
                    ? news.thumbnail 
                    : '$baseUrl/media/${news.thumbnail}',
                fit: BoxFit.cover,
                errorBuilder: (ctx, err, stack) => Container(
                  color: Colors.grey[800],
                  child: const Center(child: Icon(Icons.image, color: Colors.white54)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        news.category,
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      Text(
                        "${news.createdAt.day}/${news.createdAt.month}/${news.createdAt.year}",
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    news.title,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    news.content,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                  const Row(
                    children: [
                      Text(
                        "Baca selengkapnya",
                        style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_forward, size: 14, color: Colors.blueAccent),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}