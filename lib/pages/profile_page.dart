// lib/pages/profile_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  // Widget pembangun CircleAvatar, sama seperti di MainWrapper
  Widget _buildProfileAvatar(String? profilePicUrl, String username) {
    final String initial = username.isNotEmpty ? username[0].toUpperCase() : 'U';
    
    if (profilePicUrl != null && profilePicUrl.isNotEmpty) {
      return CircleAvatar(
        radius: 40,
        backgroundImage: NetworkImage(profilePicUrl),
        backgroundColor: Colors.white,
      );
    } else {
      return CircleAvatar(
        radius: 40,
        backgroundColor: Colors.blueAccent[700],
        child: Text(
          initial,
          style: const TextStyle(color: Colors.white, fontSize: 36),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final currentUser = userProvider.currentUser;

    // Pastikan pengguna sudah login sebelum menampilkan detail
    if (currentUser == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: const Center(child: Text('Please log in to view your profile.')),
      );
    }

    final String username = currentUser.username;
    final String status = currentUser.isArtist ? 'Artist' : 'Fan';
    final Color statusColor = currentUser.isArtist ? Colors.red : Colors.blue;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Avatar
              _buildProfileAvatar(currentUser.profilePicUrl, username),
              const SizedBox(height: 16),

              // Username
              Text(
                username,
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              // Status (Artist/Fan)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 40),

              const Divider(),
              
              // Detail Tambahan
              ListTile(
                leading: const Icon(Icons.mail),
                title: Text('Username: ${currentUser.username}'),
              ),
              ListTile(
                leading: const Icon(Icons.fingerprint),
                title: Text('User ID: ${currentUser.id}'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}