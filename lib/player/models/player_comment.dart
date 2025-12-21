import 'dart:convert';

class PlayerComment {
  final int id;
  final String user;
  final String comment;
  final String createdAt;
  final String updatedAt;
  final bool isOwner;

  PlayerComment({
    required this.id,
    required this.user,
    required this.comment,
    required this.createdAt,
    required this.updatedAt,
    required this.isOwner,
  });

  factory PlayerComment.fromJson(Map<String, dynamic> json) {
    return PlayerComment(
      id: json['id'] as int,
      user: json['user'] as String,
      comment: json['comment'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      isOwner: json['is_owner'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user,
      'comment': comment,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'is_owner': isOwner,
    };
  }

  String get formattedDate {
    try {
      // Input format: "2025-10-26T16:24:00.000Z" (ISO format from Django)
      DateTime dt = DateTime.parse(createdAt);
      const months = [
        '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      return '${dt.day} ${months[dt.month]} ${dt.year}, ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return createdAt;
    }
  }
}

class PlayerCommentListResponse {
  final List<PlayerComment> comments;

  PlayerCommentListResponse({required this.comments});

  factory PlayerCommentListResponse.fromJson(Map<String, dynamic> json) {
    var commentsList = json['comments'] as List? ?? [];
    List<PlayerComment> comments = 
        commentsList.map((comment) => PlayerComment.fromJson(comment)).toList();
    
    return PlayerCommentListResponse(comments: comments);
  }
}
