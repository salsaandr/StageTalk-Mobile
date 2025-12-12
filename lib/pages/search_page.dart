import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, 
        title: TextField(
          decoration: InputDecoration(
            hintText: 'Search footage and users',
            prefixIcon: const Icon(Icons.search, color: Colors.grey),
            suffixIcon: IconButton(
              icon: const Icon(Icons.cancel, color: Colors.grey),
              onPressed: () {},
            ),
            border: InputBorder.none,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text('Artist you follow', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            _buildFollowItem('Yuna', '@yunayunafanoll'),
            _buildFollowItem('Sky', '@skyeasybadge'),
            const Divider(),
            const Text('Trending Hashtag', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            _buildHashtag('#Treasure_fan_Win'),
            _buildHashtag('#XL_Exit'),
          ],
        ),
      ),
    );
  }

  Widget _buildFollowItem(String name, String handle) {
    return ListTile(
      leading: const CircleAvatar(backgroundColor: Colors.lightGreen),
      title: Text(name),
      subtitle: Text(handle),
      trailing: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent, 
          shadowColor: Colors.transparent,
        ),
        child: const Text('Follow', style: TextStyle(color: Colors.blue)),
      ),
    );
  }

  Widget _buildHashtag(String tag) {
    return ListTile(
      title: Text(tag, style: const TextStyle(color: Colors.blue)),
      trailing: const Icon(Icons.trending_up, color: Colors.grey),
    );
  }
}