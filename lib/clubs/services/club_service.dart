import 'dart:convert';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import '../models/club.dart';
import '../models/club_comment.dart';

class ClubService {
  static const String baseUrl = 'https://raihan-maulana41-eplradar.pbp.cs.ui.ac.id/clubs';

  // Fetch all clubs
  static Future<List<Club>> fetchClubs(CookieRequest request) async {
    try {
      final response = await request.get('$baseUrl/api/clubs/');
      
      if (response != null) {
        final clubListResponse = ClubListResponse.fromJson(response);
        return clubListResponse.clubs;
      }
      
      return [];
    } catch (e) {
      throw Exception('Failed to load clubs: $e');
    }
  }

  // Fetch all comments
  static Future<List<ClubComment>> fetchComments(CookieRequest request) async {
    try {
      final response = await request.get('$baseUrl/api/comments/');
      
      if (response != null) {
        final commentListResponse = CommentListResponse.fromJson(response);
        return commentListResponse.comments;
      }
      
      return [];
    } catch (e) {
      throw Exception('Failed to load comments: $e');
    }
  }

  // Fetch comments for a specific club
  static Future<List<ClubComment>> fetchClubComments(
    CookieRequest request,
    String clubName,
  ) async {
    try {
      final allComments = await fetchComments(request);
      return allComments.where((c) => c.clubName == clubName).toList();
    } catch (e) {
      throw Exception('Failed to load club comments: $e');
    }
  }

  // Create a new comment
  static Future<bool> createComment(
    CookieRequest request,
    String clubName,
    String comment,
  ) async {
    try {
      final response = await request.post(
        '$baseUrl/api/comments/create/',
        jsonEncode({
          'club_name': clubName,
          'comment': comment,
        }),
      );

      if (response != null && response['success'] == true) {
        return true;
      }
      
      return false;
    } catch (e) {
      throw Exception('Failed to create comment: $e');
    }
  }

  // Update a comment
  static Future<bool> updateComment(
    CookieRequest request,
    int commentId,
    String newComment,
  ) async {
    try {
      final response = await request.post(
        '$baseUrl/api/comments/$commentId/update/',
        jsonEncode({
          'comment': newComment,
        }),
      );

      if (response != null && response['success'] == true) {
        return true;
      }
      
      return false;
    } catch (e) {
      throw Exception('Failed to update comment: $e');
    }
  }

  // Delete a comment
  static Future<bool> deleteComment(
    CookieRequest request,
    int commentId,
  ) async {
    try {
      final response = await request.post(
        '$baseUrl/api/comments/$commentId/delete/',
        jsonEncode({}),
      );

      if (response != null && response['success'] == true) {
        return true;
      }
      
      return false;
    } catch (e) {
      throw Exception('Failed to delete comment: $e');
    }
  }
}