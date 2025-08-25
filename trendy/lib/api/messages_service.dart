// lib/services/messages_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

class MessagesService {
  final String baseUrl;

  MessagesService({required this.baseUrl});

  /// Create a new message (direct or group)
  Future<dynamic> createMessage(Map<String, dynamic> payload) async {
    final uri = Uri.parse('$baseUrl/messages/');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to create message: ${response.body}");
    }
  }

  /// Get messages for current user
  Future<List<dynamic>> getMessages({int skip = 0, int limit = 50}) async {
    final uri = Uri.parse('$baseUrl/messages/?skip=$skip&limit=$limit');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to fetch messages: ${response.body}");
    }
  }

  /// Get a message thread with replies
  Future<dynamic> getMessageThread(int messageId) async {
    final uri = Uri.parse('$baseUrl/messages/thread/$messageId');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to fetch message thread: ${response.body}");
    }
  }

  /// Update a message (only sender can update)
  Future<dynamic> updateMessage(int messageId, String content) async {
    final uri = Uri.parse('$baseUrl/messages/$messageId');
    final response = await http.put(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'content': content}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to update message: ${response.body}");
    }
  }

  /// Delete a message (only sender can delete)
  Future<String> deleteMessage(int messageId) async {
    final uri = Uri.parse('$baseUrl/messages/$messageId');
    final response = await http.delete(uri);

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception("Failed to delete message: ${response.body}");
    }
  }

  /// Create a voice channel in a group
  Future<dynamic> createVoiceChannel(Map<String, dynamic> payload) async {
    final uri = Uri.parse('$baseUrl/messages/voice-channels');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to create voice channel: ${response.body}");
    }
  }

  /// Join a voice channel
  Future<String> joinVoiceChannel(int channelId) async {
    final uri = Uri.parse('$baseUrl/messages/voice-channels/$channelId/join');
    final response = await http.post(uri);

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception("Failed to join voice channel: ${response.body}");
    }
  }

  /// Leave a voice channel
  Future<String> leaveVoiceChannel(int channelId) async {
    final uri = Uri.parse('$baseUrl/messages/voice-channels/$channelId/leave');
    final response = await http.post(uri);

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception("Failed to leave voice channel: ${response.body}");
    }
  }

  /// Get all voice channels for a group
  Future<List<dynamic>> getGroupVoiceChannels(int groupId) async {
    final uri = Uri.parse('$baseUrl/messages/voice-channels/$groupId');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to fetch group voice channels: ${response.body}");
    }
  }
}
