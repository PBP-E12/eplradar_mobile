// lib/player/services/player_service.dart

import 'dart:convert';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import '../models/player.dart';
import '../models/player_comment.dart';

class PlayerService {
  static const String baseUrl = 'https://raihan-maulana41-eplradar.pbp.cs.ui.ac.id/players/api';

  // Fetch all players or filtered by team
  static Future<List<Player>> fetchPlayers(CookieRequest request, {String teamId = 'all'}) async {
    try {
      final response = await request.get('$baseUrl/?team=$teamId');
      if (response != null) {
        final playerListResponse = PlayerListResponse.fromJson(response);
        return playerListResponse.players;
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
      final response = await request.get('$baseUrl/$playerId/comments/');
      if (response != null) {
        final commentListResponse = PlayerCommentListResponse.fromJson(response);
        return commentListResponse.comments;
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
}
