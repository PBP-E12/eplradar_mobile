import 'dart:convert';

Stats statsFromJson(String str) => Stats.fromJson(json.decode(str));

class Stats {
  final PlayerStats player;
  final ClubStats club;

  Stats({
    required this.player,
    required this.club,
  });

  factory Stats.fromJson(Map<String, dynamic> json) {
    return Stats(
      player: PlayerStats.fromJson(json["player"]),
      club: ClubStats.fromJson(json["club"]),
    );
  }
}


class PlayerStats {
  final List<PlayerItem> topScorer;
  final List<PlayerItem> topAssist;
  final List<PlayerItem> cleanSheet;

  PlayerStats({
    required this.topScorer,
    required this.topAssist,
    required this.cleanSheet,
  });

  factory PlayerStats.fromJson(Map<String, dynamic> json) {
    return PlayerStats(
      topScorer: List<PlayerItem>.from(
        json["top_scorer"].map((x) => PlayerItem.fromJson(x)),
      ),
      topAssist: List<PlayerItem>.from(
        json["top_assist"].map((x) => PlayerItem.fromJson(x)),
      ),
      cleanSheet: List<PlayerItem>.from(
        json["clean_sheet"].map((x) => PlayerItem.fromJson(x)),
      ),
    );
  }
}

class PlayerItem {
  final String id;        
  final String name;
  final String club;
  final String clubLogo;
  final String photo;
  final int goals;
  final int assists;
  final int cleanSheet;

  PlayerItem({
    required this.id,
    required this.name,
    required this.club,
    required this.clubLogo,
    required this.photo,
    required this.goals,
    required this.assists,
    required this.cleanSheet,
  });

  factory PlayerItem.fromJson(Map<String, dynamic> json) {
    return PlayerItem(
      id: json["id"],
      name: json["name"],
      club: json["club"],
      clubLogo: json["club_logo"] ?? "",
      photo: json["photo"] ?? "",
      goals: json["goals"] ?? 0,
      assists: json["assists"] ?? 0,
      cleanSheet: json["clean_sheet"] ?? 0,
    );
  }
}

// ================= CLUB =================

class ClubStats {
  final List<ClubItem> topScorer;
  final List<ClubItem> topAssist;
  final List<ClubItem> cleanSheet;

  ClubStats({
    required this.topScorer,
    required this.topAssist,
    required this.cleanSheet,
  });

  factory ClubStats.fromJson(Map<String, dynamic> json) {
    return ClubStats(
      topScorer: List<ClubItem>.from(
        json["top_scorer"].map((x) => ClubItem.fromJson(x)),
      ),
      topAssist: List<ClubItem>.from(
        json["top_assist"].map((x) => ClubItem.fromJson(x)),
      ),
      cleanSheet: List<ClubItem>.from(
        json["clean_sheet"].map((x) => ClubItem.fromJson(x)),
      ),
    );
  }
}

class ClubItem {
  final String club;
  final String clubLogo;
  final int totalGoals;
  final int totalAssists;
  final int totalCleansheet;

  ClubItem({
    required this.club,
    required this.clubLogo,
    required this.totalGoals,
    required this.totalAssists,
    required this.totalCleansheet,
  });

  factory ClubItem.fromJson(Map<String, dynamic> json) {
    return ClubItem(
      club: json["club"],
      clubLogo: json["club_logo"] ?? "",
      totalGoals: json["total_goals"] ?? 0,
      totalAssists: json["total_assists"] ?? 0,
      totalCleansheet: json["total_cleansheet"] ?? 0,
    );
  }
}
