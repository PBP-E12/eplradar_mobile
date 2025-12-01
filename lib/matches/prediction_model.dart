import 'dart:convert';

List<PredictionModel> predictionModelFromJson(String str) => List<PredictionModel>.from(json.decode(str).map((x) => PredictionModel.fromJson(x)));

String predictionModelToJson(List<PredictionModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PredictionModel {
    String model;
    int pk;
    Fields fields;

    PredictionModel({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory PredictionModel.fromJson(Map<String, dynamic> json) => PredictionModel(
        model: json["model"],
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "model": model,
        "pk": pk,
        "fields": fields.toJson(),
    };
}

class Fields {
    int user;
    int match;
    int homeScorePrediction;
    int awayScorePrediction;
    DateTime createdAt;

    Fields({
        required this.user,
        required this.match,
        required this.homeScorePrediction,
        required this.awayScorePrediction,
        required this.createdAt,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        user: json["user"],
        match: json["match"],
        homeScorePrediction: json["home_score_prediction"],
        awayScorePrediction: json["away_score_prediction"],
        createdAt: DateTime.parse(json["created_at"]),
    );

    Map<String, dynamic> toJson() => {
        "user": user,
        "match": match,
        "home_score_prediction": homeScorePrediction,
        "away_score_prediction": awayScorePrediction,
        "created_at": createdAt.toIso8601String(),
    };
}