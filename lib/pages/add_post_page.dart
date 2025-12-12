// lib/pages/add_post_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../providers/user_provider.dart';

class AddPostPage extends StatefulWidget {
  const AddPostPage({Key? key}) : super(key: key);

  @override
  _AddPostPageState createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  final TextEditingController _contentController = TextEditingController();
  final ApiService _apiService = ApiService();
  bool _isLoading = false;

  void _submitPost() async {
    if (_contentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Konten postingan tidak boleh kosong.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final currentUser = userProvider.currentUser;

      // --- Perbaikan dimulai di sini: Penanganan NULL ---
      if (currentUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: Anda harus login untuk membuat postingan.')),
        );
        return; // Hentikan proses jika user belum login
      }
      
      // Karena kita sudah memastikan currentUser TIDAK NULL, kita bisa menggunakan '!'
      final int userId = currentUser.id; 

      final success = await _apiService.addPost(
        userId: userId, // <-- Menggunakan ID yang aman dari Null
        content: _contentController.text,
      );
      // --- Perbaikan berakhir di sini ---

      if (success) {
        // Beri tahu HomePage untuk me-refresh feed
        Navigator.pop(context, 'post_added'); 
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal menambahkan postingan.')),
        );
      }
    } catch (e) {
      // Tangkap error jika terjadi masalah lain (misal: API error)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buat Postingan Baru'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(
                labelText: 'Apa yang sedang Anda pikirkan?',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _submitPost,
                    child: const Text('Kirim Postingan'),
                  ),
          ],
        ),
      ),
    );
  }
}