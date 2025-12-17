import 'package:flutter/material.dart';
import 'package:eplradar_mobile/matches/model/match_model.dart';
import 'package:eplradar_mobile/matches/screens/prediction_card.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ShowPredictionList extends StatefulWidget {
  final int? matchId; // Optional: untuk filter berdasarkan match tertentu

  const ShowPredictionList({super.key, this.matchId});

  @override
  State<ShowPredictionList> createState() => _ShowPredictionListState();
}

class _ShowPredictionListState extends State<ShowPredictionList> {
  List<ScorePredictionModel> predictions = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchPredictions();
  }

  Future<void> fetchPredictions() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final url = widget.matchId != null ? 'http://localhost:8000/api/predictions/match/${widget.matchId}/' : 'http://localhost:8000/api/predictions/';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          predictions = data.map((json) => ScorePredictionModel.fromJson(json)).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Gagal memuat prediksi: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1C1E),
      appBar: AppBar(
        title: Text(
          widget.matchId != null ? 'Prediksi Pertandingan' : 'Semua Prediksi',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF333438),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchPredictions,
          ),
        ],
      ),
      body: isLoading
        ? const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF3247B1),
            ),
          )
        : errorMessage.isNotEmpty
          ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 60,
                ),
                const SizedBox(height: 16),
                Text(
                  errorMessage,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: fetchPredictions,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3247B1),
                  ),
                  child: const Text('Coba Lagi'),
                ),
              ],
            ),
          )
        : predictions.isEmpty
            ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.graphic_eq,
                    color: Colors.white54,
                    size: 60,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Belum ada prediksi',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Jadilah orang pertama yang membuat prediksi!',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            )
            : RefreshIndicator(
                onRefresh: fetchPredictions,
                color: const Color(0xFF3247B1),
                child: ListView.builder(
                  itemCount: predictions.length,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemBuilder: (context, index) {
                    return PredictionCard(
                      prediction: predictions[index],
                    );
                  },
                ),
              ),
      );
  }
}