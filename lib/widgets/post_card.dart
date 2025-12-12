// lib/widgets/post_card.dart
import 'package:flutter/material.dart';
import '../models/Post.dart';

class PostCard extends StatelessWidget {
  final Post post;

  const PostCard({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    // Tentukan URL gambar
    final String? profilePicUrl = post.user.profilePicUrl;
    
    // Tentukan warna latar belakang placeholder
    final Color avatarBgColor = post.user.isArtist ? Colors.red : Colors.blueGrey;

    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Post (Profile Pic, Username, Artist/Fan Label)
            ListTile(
              leading: CircleAvatar(
                // LOGIKA PERBAIKAN DI SINI
                backgroundColor: avatarBgColor,
                
                // 1. Cek apakah profilePicUrl tersedia dan tidak kosong
                backgroundImage: (profilePicUrl != null && profilePicUrl.isNotEmpty) 
                    ? NetworkImage(profilePicUrl) as ImageProvider<Object>?
                    : null,
                    
                // 2. Jika tidak ada gambar, tampilkan inisial
                child: (profilePicUrl == null || profilePicUrl.isEmpty)
                    ? Text(
                        post.user.username[0].toUpperCase(), // Pastikan huruf besar
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      )
                    : null, // Jika ada gambar, child harus null
              ),
              // ... (lanjutan kode lainnya)
              title: Text(
                post.user.username,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                post.user.isArtist ? '@${post.user.username} - Artist' : '@${post.user.username} - Fan',
                style: TextStyle(fontSize: 12, color: post.user.isArtist ? Colors.red : Colors.grey),
              ),
              trailing: const Icon(Icons.more_vert),
            ),
            
            // Content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(post.content),
            ),

            // Post Info (Date)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                post.createdAt,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
            
            const Divider(),

            // Action Row (Likes, Comments)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildActionButton(Icons.favorite_border, post.likes.toString(), Colors.black),
                _buildActionButton(Icons.comment_outlined, post.comments.toString(), Colors.black),
                _buildActionButton(Icons.bookmark, 'Bookmark', Colors.black),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String text, Color color) {
    return TextButton(
      onPressed: (){},
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 4),
          Text(text, style: TextStyle(color: color)),
        ],
      ),
    );
  }
}