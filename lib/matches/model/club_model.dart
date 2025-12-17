import 'dart:convert';

List<ClubModel> clubModelFromJson(String str) => List<ClubModel>.from(
    json.decode(str).map((x) => ClubModel.fromJson(x)));

String clubModelToJson(List<ClubModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ClubModel {
  final int id;
  final int rank;
  final String namaKlub;
  final int jumlahWin;
  final int jumlahDraw;
  final int jumlahLose;
  final int totalMatches;
  final int poin;

  ClubModel({
    required this.id,
    required this.rank,
    required this.namaKlub,
    required this.jumlahWin,
    required this.jumlahDraw,
    required this.jumlahLose,
    required this.totalMatches,
    required this.poin,
  });

  factory ClubModel.fromJson(Map<String, dynamic> json) => ClubModel(
        id: json["id"],
        rank: json["rank"],
        namaKlub: json["nama_klub"],
        jumlahWin: json["jumlah_win"],
        jumlahDraw: json["jumlah_draw"],
        jumlahLose: json["jumlah_lose"],
        totalMatches: json["total_matches"],
        poin: json["poin"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "rank": rank,
        "nama_klub": namaKlub,
        "jumlah_win": jumlahWin,
        "jumlah_draw": jumlahDraw,
        "jumlah_lose": jumlahLose,
        "total_matches": totalMatches,
        "poin": poin,
      };

  String getLogoUrl(String baseUrl) {
    return '$baseUrl/static/img/club-matches/$namaKlub.png';
  }
}

class WeekRangeModel {
  final int minWeek;
  final int maxWeek;
  final List<int> weeks;

  WeekRangeModel({
    required this.minWeek,
    required this.maxWeek,
    required this.weeks,
  });

  factory WeekRangeModel.fromJson(Map<String, dynamic> json) => WeekRangeModel(
        minWeek: json["min_week"],
        maxWeek: json["max_week"],
        weeks: List<int>.from(json["weeks"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "min_week": minWeek,
        "max_week": maxWeek,
        "weeks": List<dynamic>.from(weeks.map((x) => x)),
      };
}