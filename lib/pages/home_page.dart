// lib/pages/home_page.dart
import 'package:flutter/material.dart';
import '../models/Post.dart';
import '../services/api_service.dart';
import '../widgets/post_card.dart';
import '../pages/add_post_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Post>> futurePosts;
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    futurePosts = apiService.fetchFeedPosts();
    _fetchPosts();
  }

  void _fetchPosts() {
    setState(() {
      futurePosts = apiService.fetchFeedPosts();
    });
  }

  void _navigateToAddPost() async {
    // Navigasi ke halaman AddPostPage
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddPostPage()),
    );

  // Jika AddPostPage mengembalikan 'post_added', maka refresh feed
    if (result == 'post_added') {
      _fetchPosts(); 
    }
  }


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('StageTalk'),
          actions: const [
            Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: Icon(Icons.search),
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Fan'),
              Tab(text: 'Artist'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildFeed(futurePosts), // Fan Feed
            _buildFeed(futurePosts), // Artist Feed (Saat ini menggunakan data yang sama)
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _navigateToAddPost, // Panggil fungsi navigasi saat ditekan
          child: const Icon(Icons.add),
          backgroundColor: Colors.blueAccent, // Sesuaikan warna
      ),
    )
    );
  }

  Widget _buildFeed(Future<List<Post>> postsFuture) {
    return FutureBuilder<List<Post>>(
      future: postsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'Gagal memuat data: ${snapshot.error}. Cek Laragon dan URL (10.0.2.2).',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
          );
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return PostCard(post: snapshot.data![index]);
            },
          );
        }
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Belum ada postingan.'),
              const SizedBox(height: 10),
              OutlinedButton(
                onPressed: _fetchPosts,
                child: const Text('Refresh Feed'),
              ),
            ],
          ),
        );
      },
    );
  }
}