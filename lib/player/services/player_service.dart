// lib/player/services/player_service.dart

import 'dart:convert';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import '../models/player.dart';
import '../models/player_comment.dart';

class PlayerService {
  static const String baseUrl = 'https://raihan-maulana41-eplradar.pbp.cs.ui.ac.id/players';

  // Fetch all players or filtered by team
  static Future<List<Player>> fetchPlayers(CookieRequest request, {String teamId = 'all'}) async {
    try {
      final response = await request.get('$baseUrl/api/?team=$teamId');
      if (response != null) {
        return PlayerListResponse.fromJson(response).players;
      }
      return [];
    } catch (e) {
      print('Error fetching players: $e');
      throw Exception('Failed to load players: $e');
    }
  }

  // Fetch comments for a specific player
  static Future<List<PlayerComment>> fetchPlayerComments(
    CookieRequest request, 
    String playerId
  ) async {
    try {
      // Trying the most likely correct path structure based on your URL config
      final response = await request.get('$baseUrl/$playerId/comments/');
      if (response != null) {
        return PlayerCommentListResponse.fromJson(response).comments;
      }
      return [];
    } catch (e) {
      print('Error fetching player comments: $e');
      throw Exception('Failed to load player comments: $e');
    }
  }

  // Create a new comment for a player
  static Future<bool> createComment(
    CookieRequest request,
    String playerId,
    String comment,
  ) async {
    try {
      // Ensure the URL matches the path('<uuid:player_id>/comments/') pattern exactly
      // trailing slash is vital in Django
      final response = await request.post(
        '$baseUrl/$playerId/comments/',
        {
          'comment': comment,
        },
      );

      if (response != null && response['status'] == 'success') {
        return true;
      }
      return false;
    } catch (e) {
      print('Error creating comment: $e');
      return false;
    }
  }

  // Delete a comment
  static Future<bool> deleteComment(
    CookieRequest request,
    int commentId,
  ) async {
    try {
      // Using the generic API endpoint for comment deletion
      final response = await request.post(
        'https://raihan-maulana41-eplradar.pbp.cs.ui.ac.id/players/api/comments/$commentId/delete/',
        {},
      );

      if (response != null && (response['status'] == 'success' || response['success'] == true)) {
        return true;
      }
      return false;
    } catch (e) {
      print('Error deleting comment: $e');
      return false;
    }
  }
}
