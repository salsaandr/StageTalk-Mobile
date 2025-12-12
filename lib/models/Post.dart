// lib/models/Post.dart
import 'User.dart';

class Post {
  final int id;
  final User user;
  final String content;
  final int likes;
  final int comments;
  final String createdAt;

  Post({
    required this.id,
    required this.user,
    required this.content,
    required this.likes,
    required this.comments,
    required this.createdAt,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: int.parse(json['id'].toString()),
      // Membuat objek User dari data JOIN
      user: User.fromJson(json), 
      content: json['content'] as String,
      likes: int.parse(json['likes'].toString()),
      comments: int.parse(json['comments'].toString()),
      createdAt: json['created_at'] as String,
    );
  }
}