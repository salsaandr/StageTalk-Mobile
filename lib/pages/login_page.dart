// lib/pages/login_page.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart'; 
import '../providers/user_provider.dart';
import '../models/User.dart'; 
import 'main_wrapper.dart'; 
// import 'home_page.dart'; // Halaman Home (tempat feed berada)

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _message = '';

  Future<void> _login() async {
    const url = 'http://10.0.2.2/stage_talk_api/login.php'; 
    
    // Reset pesan
    setState(() {
      _message = 'Loading...';
    });
    
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': _usernameController.text,
          'password': _passwordController.text,
        }),
      );

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['status'] == 'success') {
        
        // Asumsi API Anda mengembalikan objek user di kunci 'user'
        final userData = responseData['user']; 

        // 1. Buat objek User dari data respons API
        final loggedInUser = User(
          id: userData['id'] as int,
          username: userData['username'] as String,
          // Sesuaikan dengan kunci API Anda. Asumsi 'is_artist' adalah int 0 atau 1
          isArtist: (userData['is_artist'] as int) == 1, 
          profilePicUrl: userData['profile_pic_url'] as String?, // Nullable
        );

        // 2. Akses UserProvider (menggunakan listen: false karena kita memodifikasi state)
        final userProvider = Provider.of<UserProvider>(context, listen: false);

        // 3. Simpan data pengguna ke UserProvider
        userProvider.login(
          loggedInUser.id,
          loggedInUser.username,
          loggedInUser.isArtist,
          loggedInUser.profilePicUrl,
        );

        setState(() {
          _message = 'Login berhasil! Selamat datang, ${loggedInUser.username}';
        });

        // 4. Navigasi ke MainWrapper (yang berisi HomePage)
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MainWrapper()),
        );
      } else {
        setState(() {
          _message = responseData['message'] ?? 'Login gagal, coba lagi.';
        });
      }
    } catch (e) {
      setState(() {
        _message = 'Gagal terhubung ke server Laragon atau Error parsing data. Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('StageTalk Login', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome Back!', 
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Login', style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}