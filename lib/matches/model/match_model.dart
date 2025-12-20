import 'dart:convert';

List<MatchModel> matchModelFromJson(String str) => List<MatchModel>.from(
    json.decode(str).map((x) => MatchModel.fromJson(x)));

String matchModelToJson(List<MatchModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MatchModel {
  final int id;
  final String homeTeam;
  final String awayTeam;
  final int homeScore;
  final int awayScore;
  final int week;
  final DateTime matchDate;

  MatchModel({
    required this.id,
    required this.homeTeam,
    required this.awayTeam,
    required this.homeScore,
    required this.awayScore,
    required this.week,
    required this.matchDate,
  });

  factory MatchModel.fromJson(Map<String, dynamic> json) => MatchModel(
    id: json["id"],
    homeTeam: json["home_team"],
    awayTeam: json["away_team"],
    homeScore: json["home_score"] ?? 0,
    awayScore: json["away_score"] ?? 0,
    week: json["week"],
    matchDate: DateTime.parse(json["match_date"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "home_team": homeTeam,
    "away_team": awayTeam,
    "home_score": homeScore,
    "away_score": awayScore,
    "week": week,
    "match_date": matchDate.toIso8601String(),
  };
}

// Score Prediction Model
class ScorePredictionModel {
  final int id;
  final UserData user;
  final MatchData match;
  final int homeScorePrediction;
  final int awayScorePrediction;
  final DateTime createdAt;

  ScorePredictionModel({
    required this.id,
    required this.user,
    required this.match,
    required this.homeScorePrediction,
    required this.awayScorePrediction,
    required this.createdAt,
  });

  factory ScorePredictionModel.fromJson(Map<String, dynamic> json) =>
    ScorePredictionModel(
      id: json["id"],
      user: UserData.fromJson(json["user"]),
      match: MatchData.fromJson(json["match"]),
      homeScorePrediction: json["home_score_prediction"],
      awayScorePrediction: json["away_score_prediction"],
      createdAt: DateTime.parse(json["created_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "user": user.toJson(),
        "match": match.toJson(),
        "home_score_prediction": homeScorePrediction,
        "away_score_prediction": awayScorePrediction,
        "created_at": createdAt.toIso8601String(),
      };
}

class UserData {
  final int id;
  final String username;

  UserData({
    required this.id,
    required this.username,
  });

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
    id: json["id"],
    username: json["username"],
  );

  Map<String, dynamic> toJson() => {
      "id": id,
      "username": username,
    };
  }

class MatchData {
  final int id;
  final String homeTeam;
  final String awayTeam;
  final DateTime matchDate;

  MatchData({
    required this.id,
    required this.homeTeam,
    required this.awayTeam,
    required this.matchDate,
  });

  factory MatchData.fromJson(Map<String, dynamic> json) => MatchData(
    id: json["id"],
    homeTeam: json["home_team"],
    awayTeam: json["away_team"],
    matchDate: DateTime.parse(json["match_date"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "home_team": homeTeam,
    "away_team": awayTeam,
    "match_date": matchDate.toIso8601String(),
  };
}