// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/Post.dart';
import '../models/User.dart';

class ApiService {

  static const String _baseUrl = "http://10.0.2.2/stage_talk_api/";

  Future<List<Post>> fetchFeedPosts() async {
    final url = Uri.parse('${_baseUrl}get_posts.php');
    
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data.containsKey('posts')) {
          final List<dynamic> postsJson = data['posts'];
          return postsJson.map((json) => Post.fromJson(json)).toList();
        }
        return [];
      } else {
        throw Exception('Failed to load posts. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching posts: $e');
      throw Exception('Failed to connect to API. Pastikan Laragon berjalan dan path sudah benar.');
    }
  }

  Future<bool> addPost({required int userId, required String content}) async {
  final url = Uri.parse('http://10.0.2.2/stage_talk_api/add_post.php'); 

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_id': userId,
          'content': content,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['status'] == 'success'; 
      }
      return false;
    } catch (e) {
      print('Error during addPost: $e');
      return false;
    }
  }

  Future<List<User>> searchUsers(String query) async {
    // Pastikan query tidak kosong
    if (query.trim().isEmpty) {
      return []; 
    }
    
    // Asumsi kita akan membuat file search_users.php
    final url = Uri.parse('${_baseUrl}search_users.php?q=${Uri.encodeComponent(query)}'); 
    
    try {
      final response = await http.get(url).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        if (response.body.isEmpty) return [];

        final decodedBody = jsonDecode(response.body);

        if (decodedBody is List<dynamic>) {
          // Asumsi API mengembalikan List<User>
          return decodedBody.map((json) => User.fromJson(json)).toList();
        } else {
          throw Exception('Invalid search API response format');
        }
      } else {
        throw Exception('Failed to load search results. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error searching users: $e');
      return []; // Kembalikan list kosong jika terjadi error
    }
  }

  // Tambahkan fungsi lain (misal: postLike, postComment, dll.)
}