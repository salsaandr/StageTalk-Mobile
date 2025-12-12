// lib/providers/user_provider.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // <-- BARU: Import SharedPreferences
import '../models/User.dart';

class UserProvider with ChangeNotifier {
  User? _currentUser; 
  
  // Kunci untuk penyimpanan lokal
  static const String _kUserId = 'userId';
  static const String _kUsername = 'username';
  static const String _kIsArtist = 'isArtist';
  static const String _kProfilePicUrl = 'profilePicUrl';

  User? get currentUser => _currentUser;

  // 1. Method login yang diperbaiki: Menyimpan data ke Shared Preferences
  Future<void> login(int id, String username, bool isArtist, String? profilePicUrl) async {
    _currentUser = User(
      id: id,
      username: username,
      isArtist: isArtist,
      profilePicUrl: profilePicUrl,
    );

    // Menyimpan data ke penyimpanan lokal (persistency)
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kUserId, id);
    await prefs.setString(_kUsername, username);
    await prefs.setBool(_kIsArtist, isArtist);
    if (profilePicUrl != null) {
      await prefs.setString(_kProfilePicUrl, profilePicUrl);
    } else {
      await prefs.remove(_kProfilePicUrl);
    }
    
    notifyListeners();
  }
  
  // 2. Method untuk otomatis login saat aplikasi dibuka
  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt(_kUserId);
    
    if (id != null) {
      // Data ditemukan, buat objek User
      _currentUser = User(
        id: id,
        username: prefs.getString(_kUsername) ?? 'Unknown',
        isArtist: prefs.getBool(_kIsArtist) ?? false,
        profilePicUrl: prefs.getString(_kProfilePicUrl),
      );
    }
    notifyListeners(); 
  }

  // 3. Method logout yang diperbaiki: Menghapus data dari Shared Preferences
  void logout() async {
    _currentUser = null;
    
    // Menghapus data dari penyimpanan lokal
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kUserId);
    await prefs.remove(_kUsername);
    await prefs.remove(_kIsArtist);
    await prefs.remove(_kProfilePicUrl);
    
    notifyListeners();
  }
}