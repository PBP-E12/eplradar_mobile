// lib/stats/services/stats_service.dart
import 'package:pbp_django_auth/pbp_django_auth.dart';
import '../models/stats_model.dart';

class StatsService {
  static const String baseUrl = "http://10.0.2.2:8000/stats/api";

  /// GET statistik pemain & klub
  static Future<Stats?> fetchStats(CookieRequest req) async {
    try {
      final json = await req.get("$baseUrl/stats/");
      return Stats.fromJson(json);
    } catch (e) {
      return null;
    }
  }
}
