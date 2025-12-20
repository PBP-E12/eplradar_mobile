class Club {
  final int id;
  final String namaKlub;
  final String logoFilename;
  final int jumlahWin;
  final int jumlahDraw;
  final int jumlahLose;
  final int totalMatches;
  final int points;

  Club({
    required this.id,
    required this.namaKlub,
    required this.logoFilename,
    required this.jumlahWin,
    required this.jumlahDraw,
    required this.jumlahLose,
    required this.totalMatches,
    required this.points,
  });

  factory Club.fromJson(Map<String, dynamic> json) {
    return Club(
      id: json['id'] as int,
      namaKlub: json['nama_klub'] as String,
      logoFilename: json['logo_filename'] as String,
      jumlahWin: json['jumlah_win'] as int,
      jumlahDraw: json['jumlah_draw'] as int,
      jumlahLose: json['jumlah_lose'] as int,
      totalMatches: json['total_matches'] as int,
      points: json['points'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_klub': namaKlub,
      'logo_filename': logoFilename,
      'jumlah_win': jumlahWin,
      'jumlah_draw': jumlahDraw,
      'jumlah_lose': jumlahLose,
      'total_matches': totalMatches,
      'points': points,
    };
  }

  double get winPercentage {
    if (totalMatches == 0) return 0.0;
    return (jumlahWin / totalMatches) * 100;
  }

  String get formGuide {
    return 'W:$jumlahWin D:$jumlahDraw L:$jumlahLose';
  }
}

class ClubListResponse {
  final List<Club> clubs;

  ClubListResponse({required this.clubs});

  factory ClubListResponse.fromJson(Map<String, dynamic> json) {
    var clubsList = json['data'] as List;
    List<Club> clubs = clubsList.map((club) => Club.fromJson(club)).toList();
    
    return ClubListResponse(clubs: clubs);
  }
}