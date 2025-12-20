class ClubComment {
  final int id;
  final String user;
  final String clubName;
  final String comment;
  final String createdAt;
  final bool isOwner;

  ClubComment({
    required this.id,
    required this.user,
    required this.clubName,
    required this.comment,
    required this.createdAt,
    required this.isOwner,
  });

  factory ClubComment.fromJson(Map<String, dynamic> json) {
    return ClubComment(
      id: json['id'] as int,
      user: json['user'] as String,
      clubName: json['club_name'] as String,
      comment: json['comment'] as String,
      createdAt: json['created_at'] as String,
      isOwner: json['is_owner'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user,
      'club_name': clubName,
      'comment': comment,
      'created_at': createdAt,
      'is_owner': isOwner,
    };
  }

  String get formattedDate {
    try {
      // Input format: "2025-10-26 16:24"
      final parts = createdAt.split(' ');
      if (parts.length == 2) {
        final dateParts = parts[0].split('-');
        final timeParts = parts[1].split(':');
        
        if (dateParts.length == 3 && timeParts.length == 2) {
          final month = _getMonthName(int.parse(dateParts[1]));
          return '${dateParts[2]} $month ${dateParts[0]}, ${timeParts[0]}:${timeParts[1]}';
        }
      }
      return createdAt;
    } catch (e) {
      return createdAt;
    }
  }

  String _getMonthName(int month) {
    const months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month];
  }
}

class CommentListResponse {
  final List<ClubComment> comments;

  CommentListResponse({required this.comments});

  factory CommentListResponse.fromJson(Map<String, dynamic> json) {
    var commentsList = json['data'] as List;
    List<ClubComment> comments = 
        commentsList.map((comment) => ClubComment.fromJson(comment)).toList();
    
    return CommentListResponse(comments: comments);
  }
}

class CommentRequest {
  final String clubName;
  final String comment;

  CommentRequest({
    required this.clubName,
    required this.comment,
  });

  Map<String, dynamic> toJson() {
    return {
      'club_name': clubName,
      'comment': comment,
    };
  }
}