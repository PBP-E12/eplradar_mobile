import 'dart:convert';

FavoriteList favoriteListFromJson(String str) =>
    FavoriteList.fromJson(json.decode(str));

class FavoriteList {
  final List<FavoriteItem> favorites;

  FavoriteList({required this.favorites});

  factory FavoriteList.fromJson(Map<String, dynamic> json) {
    return FavoriteList(
      favorites: List<FavoriteItem>.from(
        json["favorites"].map((x) => FavoriteItem.fromJson(x)),
      ),
    );
  }
}

class FavoriteItem {
  final int favId;
  final String playerId;   
  final String name;
  final String club;
  final String photo;
  final String reason;

  FavoriteItem({
    required this.favId,
    required this.playerId,
    required this.name,
    required this.club,
    required this.photo,
    required this.reason,
  });

  factory FavoriteItem.fromJson(Map<String, dynamic> json) {
    return FavoriteItem(
      favId: json["fav_id"],
      playerId: json["player_id"],         
      name: json["name"],
      club: json["club"],
      photo: json["photo"] ?? "",
      reason: json["reason"] ?? "",
    );
  }
}
