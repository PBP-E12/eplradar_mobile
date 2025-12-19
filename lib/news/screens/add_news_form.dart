import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class AddNewsPage extends StatefulWidget {
  const AddNewsPage({super.key});

  @override
  State<AddNewsPage> createState() => _AddNewsPageState();
}

class _AddNewsPageState extends State<AddNewsPage> {
  final _formKey = GlobalKey<FormState>();

  String title = "";
  String content = "";
  String category = "Transfer";
  String thumbnail = "";
  bool isFeatured = false;

  final List<String> categories = [
    "Transfer",
    "Update",
    "Exclusive",
    "Match",
    "Rumor",
    "Analysis"
  ];

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add News"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      backgroundColor: const Color(0xFF1D1F22),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField("Title", (val) => title = val),
              _buildTextField("Thumbnail URL", (val) => thumbnail = val),
              _buildDropdown(),
              _buildContentField(),
              SwitchListTile(
                value: isFeatured,
                onChanged: (val) {
                  setState(() {
                    isFeatured = val;
                  });
                },
                title: const Text("Featured", style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    final response = await request.postJson(
                      "http://127.0.0.1:8000/news/create-news-flutter",
                      jsonEncode({
                        "title": title,
                        "content": content,
                        "category": category,
                        "thumbnail": thumbnail,
                        "is_featured": isFeatured
                      }),
                    );

                    if (response["status"] == "success") {
                      Navigator.pop(context);
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text("Submit"),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, Function(String) onSaved) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          filled: true,
          fillColor: const Color(0xFF2A2D32),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        validator: (val) => val == null || val.isEmpty ? "Required" : null,
        onSaved: (val) => onSaved(val!),
      ),
    );
  }

  Widget _buildContentField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        maxLines: 6,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: "Content",
          labelStyle: const TextStyle(color: Colors.white70),
          filled: true,
          fillColor: const Color(0xFF2A2D32),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        validator: (val) => val == null || val.isEmpty ? "Required" : null,
        onSaved: (val) => content = val!,
      ),
    );
  }

  Widget _buildDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: DropdownButtonFormField(
        value: category,
        dropdownColor: const Color(0xFF2A2D32),
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFF2A2D32),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        style: const TextStyle(color: Colors.white),
        items: categories.map((c) {
          return DropdownMenuItem(
            value: c,
            child: Text(c),
          );
        }).toList(),
        onChanged: (val) {
          setState(() {
            category = val!;
          });
        },
      ),
    );
  }
}
