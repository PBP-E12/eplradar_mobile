// To parse this JSON data, do
//
//     final newsEntry = newsEntryFromJson(jsonString);

import 'dart:convert';

List<NewsEntry> newsEntryFromJson(String str) => List<NewsEntry>.from(json.decode(str).map((x) => NewsEntry.fromJson(x)));

String newsEntryToJson(List<NewsEntry> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class NewsEntry {
    int id;
    int userId;
    String user;
    String title;
    String content;
    String category;
    String thumbnail;
    int newsViews;
    DateTime createdAt;
    bool isFeatured;

    NewsEntry({
        required this.id,
        required this.userId,
        required this.user,
        required this.title,
        required this.content,
        required this.category,
        required this.thumbnail,
        required this.newsViews,
        required this.createdAt,
        required this.isFeatured,
    });

    factory NewsEntry.fromJson(Map<String, dynamic> json) => NewsEntry(
        id: json["id"],
        userId: json["user_id"],
        user: json["user"],
        title: json["title"],
        content: json["content"],
        category: json["category"],
        thumbnail: json["thumbnail"],
        newsViews: json["news_views"],
        createdAt: DateTime.parse(json["created_at"]),
        isFeatured: json["is_featured"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "user": user,
        "title": title,
        "content": content,
        "category": category,
        "thumbnail": thumbnail,
        "news_views": newsViews,
        "created_at": createdAt.toIso8601String(),
        "is_featured": isFeatured,
    };
}
