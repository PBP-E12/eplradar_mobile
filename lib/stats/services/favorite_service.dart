// lib/stats/services/favorite_service.dart
import 'dart:convert';
import 'package:pbp_django_auth/pbp_django_auth.dart';

import '../models/favorite_model.dart';

class FavoriteService {
  static const String baseUrl = "http://10.0.2.2:8000/stats/api";

  /// Ambil semua favorit user
  static Future<FavoriteList> fetchFavorites(CookieRequest req) async {
    final json = await req.get("$baseUrl/favorite/");
    return FavoriteList.fromJson(json);
  }

  /// Tambah pemain ke favorit
  static Future<void> addFavorite(CookieRequest req, String playerId) async {
    await req.postJson(
      "$baseUrl/favorite/",
      jsonEncode({"player_id": playerId}),
    );
  }

  /// Hapus pemain dari favorit
  static Future<void> deleteFavorite(CookieRequest req, String playerId) async {
    await req.postJson(
      "$baseUrl/favorite/",
      jsonEncode({"player_id": playerId}),
    );
  }

  /// Update alasan (note)
  static Future<void> updateReason(
      CookieRequest req, String playerId, String reason) async {
    await req.postJson(
      "$baseUrl/favorite/",
      jsonEncode({
        "player_id": playerId,
        "reason": reason,
      }),
    );
  }

  /// Search pemain (untuk tambah favorit)
  static Future<List<dynamic>> searchPlayer(
      CookieRequest req, String query) async {
    final json = await req.get("$baseUrl/players/search/?q=$query");
    return json["players"];
  }
}
