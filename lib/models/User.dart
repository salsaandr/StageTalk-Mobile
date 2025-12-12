// lib/models/User.dart
class User {
  final int id;
  final String username;
  final bool isArtist;
  final String? profilePicUrl;

  User({
    required this.id,
    required this.username,
    required this.isArtist,
    this.profilePicUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: int.parse(json['user_id'].toString()),
      username: json['username'] as String,
      // Handle bool parsing
      isArtist: json['is_artist'].toString() == '1' || json['is_artist'] == true, 
      profilePicUrl: json['profile_pic_url'] as String?,
    );
  }
}