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
    final fields = json['fields'] as Map<String, dynamic>? ?? json;
    final pk = (json['pk'] ?? json['id'] ?? fields['id'])?.toString() ?? "";

    return Player(
      id: pk,
      name: fields['name']?.toString() ?? "",
      position: fields['position']?.toString() ?? "",
      team: fields['team'] is int ? fields['team'] as int : int.tryParse(fields['team']?.toString() ?? "0") ?? 0,
      profilePictureUrl: fields['profile_picture_url']?.toString(),
      citizenship: fields['citizenship']?.toString() ?? "",
      age: fields['age'] is int ? fields['age'] as int : int.tryParse(fields['age']?.toString() ?? "0") ?? 0,
      currGoals: fields['curr_goals'] is int ? fields['curr_goals'] as int : int.tryParse(fields['curr_goals']?.toString() ?? "0") ?? 0,
      currAssists: fields['curr_assists'] is int ? fields['curr_assists'] as int : int.tryParse(fields['curr_assists']?.toString() ?? "0") ?? 0,
      matchPlayed: fields['match_played'] is int ? fields['match_played'] as int : int.tryParse(fields['match_played']?.toString() ?? "0") ?? 0,
      currCleansheet: fields['curr_cleansheet'] is int ? fields['curr_cleansheet'] as int : int.tryParse(fields['curr_cleansheet']?.toString() ?? "0") ?? 0,
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

  static const String baseUrl = 'https://raihan-maulana41-eplradar.pbp.cs.ui.ac.id';
  static const String apiUrl = '$baseUrl/players/api/';

  String get fullProfilePictureUrl {
    if (profilePictureUrl == null || profilePictureUrl!.isEmpty) return "";
    if (profilePictureUrl!.startsWith('http')) return profilePictureUrl!;
    // Standard Django media URL construction
    return '$baseUrl/media/$profilePictureUrl';
  }

  static Future<bool> create(CookieRequest request, Map<String, dynamic> playerData) async {
    try {
      final response = await request.post(apiUrl, playerData);
      return response != null && response['status'] == 'success';
    } catch (e) {
      print('Error creating player: $e');
      return false;
    }
  }

  Future<bool> delete(CookieRequest request) async {
    try {
      final response = await request.post('$apiUrl$id/', {}); 
      return response != null && response['status'] == 'success';
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
    if (json == null) return PlayerListResponse(players: []);
    
    List<dynamic> list;
    if (json is String) {
      try {
        list = jsonDecode(json);
      } catch (e) {
        print("Error decoding PlayerListResponse: $e");
        return PlayerListResponse(players: []);
      }
    } else if (json is List) {
      list = json;
    } else if (json is Map<String, dynamic> && json['data'] != null) {
      list = json['data'] as List;
    } else {
      list = [];
    }
    
    return PlayerListResponse(
      players: list.map((p) => Player.fromJson(p as Map<String, dynamic>)).toList(),
    );
  }
}
