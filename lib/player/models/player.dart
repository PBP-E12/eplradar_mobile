import 'dart:convert';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class Player {
  final String id;
  final String name;
  final String position;
  final int team;
  final String? profilePictureUrl;
  final String citizenship;
  final int age;
  final int currGoals;
  final int currAssists;
  final int matchPlayed;
  final int currCleansheet;

  Player({
    required this.id,
    required this.name,
    required this.position,
    required this.team,
    this.profilePictureUrl,
    required this.citizenship,
    required this.age,
    required this.currGoals,
    required this.currAssists,
    required this.matchPlayed,
    required this.currCleansheet,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    // Django's serializers.serialize('json', ...) format:
    // [{"model": "...", "pk": "...", "fields": {...}}]
    final fields = json['fields'] as Map<String, dynamic>? ?? json;
    final pk = json['pk'] as String? ?? (json['id']?.toString() ?? "");

    return Player(
      id: pk,
      name: fields['name'] as String? ?? "",
      position: fields['position'] as String? ?? "",
      team: fields['team'] as int? ?? 0,
      profilePictureUrl: fields['profile_picture_url'] as String?,
      citizenship: fields['citizenship'] as String? ?? "",
      age: fields['age'] as int? ?? 0,
      currGoals: fields['curr_goals'] as int? ?? 0,
      currAssists: fields['curr_assists'] as int? ?? 0,
      matchPlayed: fields['match_played'] as int? ?? 0,
      currCleansheet: fields['curr_cleansheet'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'position': position,
      'team': team,
      'profile_picture_url': profilePictureUrl,
      'citizenship': citizenship,
      'age': age,
      'curr_goals': currGoals,
      'curr_assists': currAssists,
      'match_played': matchPlayed,
      'curr_cleansheet': currCleansheet,
    };
  }

  static const String apiUrl = 'http://127.0.0.1:8000/players/api/';

  // Create method - matches Django POST logic (Add)
  static Future<bool> create(CookieRequest request, Map<String, dynamic> playerData) async {
    try {
      final response = await request.post(apiUrl, playerData);
      if (response != null && response['status'] == 'success') {
        return true;
      }
      return false;
    } catch (e) {
      print('Error creating player: $e');
      return false;
    }
  }

  // Delete method - matches Django POST logic (Delete if player_id is present)
  Future<bool> delete(CookieRequest request) async {
    try {
      final response = await request.post(apiUrl, {
        'player_id': id,
      });
      if (response != null && response['status'] == 'success') {
        return true;
      }
      return false;
    } catch (e) {
      print('Error deleting player: $e');
      return false;
    }
  }
}

class PlayerListResponse {
  final List<Player> players;

  PlayerListResponse({required this.players});

  factory PlayerListResponse.fromJson(dynamic json) {
    if (json is List) {
      return PlayerListResponse(
        players: json.map((p) => Player.fromJson(p as Map<String, dynamic>)).toList(),
      );
    }
    return PlayerListResponse(players: []);
  }
}
