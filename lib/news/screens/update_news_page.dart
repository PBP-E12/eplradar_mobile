import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import '../models/news_entry.dart';

class UpdateNewsPage extends StatefulWidget {
  final NewsEntry news;

  const UpdateNewsPage({super.key, required this.news});

  @override
  State<UpdateNewsPage> createState() => _UpdateNewsPageState();
}

class _UpdateNewsPageState extends State<UpdateNewsPage> {
  final _formKey = GlobalKey<FormState>();

  late String title;
  late String content;
  late String category;
  late String thumbnail;
  bool isFeatured = false;

  final List<String> categories = [
    "Transfer",
    "Update",
    "Exclusive",
    "Match",
    "Rumor",
    "Analysis",
  ];

  @override
  void initState() {
    super.initState();
    title = widget.news.title;
    content = widget.news.content;
    thumbnail = widget.news.thumbnail;
    isFeatured = widget.news.isFeatured;

    // PERBAIKAN: Mencari kategori yang cocok secara case-insensitive
    // Jika "analysis" (dari DB) masuk, akan dicocokkan dengan "Analysis" (di List)
    category = categories.firstWhere(
      (item) => item.toLowerCase() == widget.news.category.toLowerCase(),
      orElse: () => categories.first, // Default jika tidak ada yang cocok
    );
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    const baseUrl = "https://raihan-maulana41-eplradar.pbp.cs.ui.ac.id";

    return Scaffold(
      backgroundColor: const Color(0xFF1D1F22),
      appBar: AppBar(
        title: const Text("Update News"),
        backgroundColor: const Color(0xFF1D1F22),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildField(
                label: "Judul",
                initialValue: title,
                onSaved: (v) => title = v!,
              ),
              _buildField(
                label: "Thumbnail URL",
                initialValue: thumbnail,
                onSaved: (v) => thumbnail = v!,
              ),
              DropdownButtonFormField<String>(
                value: category,
                dropdownColor: const Color(0xFF2A2D32),
                items: categories
                    .map((c) => DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(color: Colors.white))))
                    .toList(),
                onChanged: (v) => setState(() {
                  category = v!;
                }),
                decoration: _inputDecoration("Kategori"),
                style: const TextStyle(color: Colors.white), 
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: content,
                maxLines: 6,
                style: const TextStyle(color: Colors.white),
                onSaved: (v) => content = v!,
                decoration: _inputDecoration("Konten"),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;
                  _formKey.currentState!.save();

                  final res = await request.post(
                    "$baseUrl/news/update-news-ajax/${widget.news.id}/",
                    {
                      "title": title,
                      "content": content,
                      "category": category,
                      "thumbnail": thumbnail,
                      "is_featured": isFeatured ? "on" : "",
                    },
                  );

                  if (res['success'] == true) {
                    if (context.mounted) {
                      Navigator.pop(context, true);
                    }
                  } else {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(res['message'] ?? "Gagal update")),
                      );
                    }
                  }
                },
                child: const Text("Update Berita"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required String label,
    required String initialValue,
    required Function(String?) onSaved,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        initialValue: initialValue,
        style: const TextStyle(color: Colors.white),
        onSaved: onSaved,
        validator: (v) =>
            v == null || v.isEmpty ? "Tidak boleh kosong" : null,
        decoration: _inputDecoration(label),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.grey),
      filled: true,
      fillColor: const Color(0xFF2A2D32),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}