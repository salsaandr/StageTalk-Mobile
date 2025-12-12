// lib/main_wrapper.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
import '../providers/user_provider.dart'; // <-- Pastikan path ini benar!
import 'back_stage_page.dart';
import 'home_page.dart';
import 'notifications_page.dart';
import 'search_page.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({Key? key}) : super(key: key);

  @override
  _MainWrapperState createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const SearchPage(),
    const BackStagePage(),
    const NotificationsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  // LOGIKA LOGOUT
  void _handleLogout() {
    // 1. Dapatkan instance UserProvider tanpa listen
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    
    // 2. Panggil method logout
    userProvider.logout();

    // 3. Tutup Drawer
    Navigator.of(context).pop(); 

    // Opsional: Navigasi ke Halaman Login jika diperlukan (tergantung logika routing Anda)
    // Navigator.of(context).pushReplacementNamed('/login'); 
  }

  // Widget pembangun CircleAvatar berdasarkan URL
  Widget _buildProfileAvatar(String? profilePicUrl, String username) {
    final String initial = username.isNotEmpty ? username[0].toUpperCase() : 'U';
    
    if (profilePicUrl != null && profilePicUrl.isNotEmpty) {
      // Jika URL tersedia, gunakan NetworkImage
      return CircleAvatar(
        backgroundImage: NetworkImage(profilePicUrl),
        backgroundColor: Colors.white,
      );
    } else {
      // Jika URL kosong, gunakan inisial
      return CircleAvatar(
        backgroundColor: Colors.blueAccent[700],
        child: Text(
          initial,
          style: const TextStyle(color: Colors.white, fontSize: 24),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Akses UserProvider untuk mendapatkan data pengguna
    final userProvider = Provider.of<UserProvider>(context);
    final currentUser = userProvider.currentUser;
    
    // Tentukan nilai default jika pengguna belum login
    final String username = currentUser?.username ?? 'Guest User';
    final String status = (currentUser?.isArtist == 1) 
        ? 'Artist Account' 
        : (currentUser != null ? 'Fan Account' : 'Please Log In');
    final String profilePicUrl = currentUser?.profilePicUrl ?? '';


    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            // HEADER DRAWER (User Data)
            UserAccountsDrawerHeader(
              accountName: Text(username), 
              accountEmail: Text(status), 
              currentAccountPicture: _buildProfileAvatar(profilePicUrl, username),
              decoration: BoxDecoration(color: Colors.blueAccent[400]),
            ),
            
            // NAVIGATION ITEMS
            ListTile(leading: const Icon(Icons.home), title: const Text('Home'), onTap: () => _onItemTapped(0)),
            const ListTile(leading: Icon(Icons.person), title: Text('Profile')),
            const ListTile(leading: Icon(Icons.notifications), title: Text('Notifications')),
            const ListTile(leading: Icon(Icons.settings), title: Text('Settings')),
            
            const Divider(),

            // LOGOUT BUTTON
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red), 
              title: const Text('Logout', style: TextStyle(color: Colors.red)),
              onTap: _handleLogout,
            ),
          ],
        ),
      ),
      
      body: _pages[_currentIndex],
      
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.mic), label: 'BackStageTalk'), 
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notification'),
        ],
      ),
    );
  }
}