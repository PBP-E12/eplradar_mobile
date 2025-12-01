import 'dart:convert';

List<MatchModel> matchModelFromJson(String str) => List<MatchModel>.from(json.decode(str).map((x) => MatchModel.fromJson(x)));

String matchModelToJson(List<MatchModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MatchModel {
    Model model;
    int pk;
    Fields fields;

    MatchModel({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory MatchModel.fromJson(Map<String, dynamic> json) => MatchModel(
        model: modelValues.map[json["model"]]!,
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "model": modelValues.reverse[model],
        "pk": pk,
        "fields": fields.toJson(),
    };
}

class Fields {
    String homeTeam;
    String awayTeam;
    int homeScore;
    int awayScore;
    int week;
    DateTime matchDate;

    Fields({
        required this.homeTeam,
        required this.awayTeam,
        required this.homeScore,
        required this.awayScore,
        required this.week,
        required this.matchDate,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        homeTeam: json["home_team"],
        awayTeam: json["away_team"],
        homeScore: json["home_score"],
        awayScore: json["away_score"],
        week: json["week"],
        matchDate: DateTime.parse(json["match_date"]),
    );

    Map<String, dynamic> toJson() => {
        "home_team": homeTeam,
        "away_team": awayTeam,
        "home_score": homeScore,
        "away_score": awayScore,
        "week": week,
        "match_date": matchDate.toIso8601String(),
    };
}

enum Model {
    MATCHES_MATCH
}

final modelValues = EnumValues({
    "matches.match": Model.MATCHES_MATCH
});

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
            reverseMap = map.map((k, v) => MapEntry(v, k));
            return reverseMap;
    }
}