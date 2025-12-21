// lib/player/models/player.dart

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
    return Player(
      id: json['id']?.toString() ?? "",
      name: json['name']?.toString() ?? "",
      position: json['position']?.toString() ?? "",
      team: json['team_id'] is int ? json['team_id'] as int : int.tryParse(json['team_id']?.toString() ?? "0") ?? 0,
      profilePictureUrl: json['profile_picture_url']?.toString(),
      citizenship: json['citizenship']?.toString() ?? "",
      age: json['age'] is int ? json['age'] as int : int.tryParse(json['age']?.toString() ?? "0") ?? 0,
      currGoals: json['curr_goals'] is int ? json['curr_goals'] as int : int.tryParse(json['curr_goals']?.toString() ?? "0") ?? 0,
      currAssists: json['curr_assists'] is int ? json['curr_assists'] as int : int.tryParse(json['curr_assists']?.toString() ?? "0") ?? 0,
      matchPlayed: json['match_played'] is int ? json['match_played'] as int : int.tryParse(json['match_played']?.toString() ?? "0") ?? 0,
      currCleansheet: json['curr_cleansheet'] is int ? json['curr_cleansheet'] as int : int.tryParse(json['curr_cleansheet']?.toString() ?? "0") ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'position': position,
      'team_id': team,
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

  bool get isLocalAsset {
    return profilePictureUrl == null || profilePictureUrl!.isEmpty || !profilePictureUrl!.startsWith('http');
  }

  String get fullProfilePictureUrl {
    if (profilePictureUrl != null && profilePictureUrl!.startsWith('http')) {
      return profilePictureUrl!;
    }

    if (profilePictureUrl != null && profilePictureUrl!.isNotEmpty) {
      try {
        // Decode the path component safely. We split to get the filename first.
        String encodedFileName = profilePictureUrl!.split('/').last;
        // Use Uri.decodeFull/Component only if it contains a % to avoid illegal encoding errors
        // on already decoded strings with special characters.
        String fileName = encodedFileName.contains('%')
            ? Uri.decodeComponent(encodedFileName)
            : encodedFileName;

        return 'assets/images/players/$fileName';
      } catch (e) {
        // Fallback to name-based logic if decoding fails
      }
    }

    // Fallback using the player name as filename
    String fileName = name.replaceAll(' ', '_');
    return 'assets/images/players/$fileName.png';
  }

  static Future<bool> create(CookieRequest request, Map<String, dynamic> playerData) async {
    try {
      final response = await request.post(apiUrl, playerData);
      return response != null && response['status'] == 'success';
    } catch (e) {
      return false;
    }
  }

  Future<bool> delete(CookieRequest request) async {
    try {
      final response = await request.post('$apiUrl$id/', {});
      return response != null && response['status'] == 'success';
    } catch (e) {
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
    if (json is Map<String, dynamic> && json['players'] != null) {
      list = json['players'] as List;
    } else if (json is List) {
      list = json;
    } else {
      list = [];
    }

    return PlayerListResponse(
      players: list.map((p) => Player.fromJson(p as Map<String, dynamic>)).toList(),
    );
  }
}