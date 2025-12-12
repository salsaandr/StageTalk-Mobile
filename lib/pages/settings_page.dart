// lib/pages/settings_page.dart
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: const [
          // Grup Akun
          Padding(
            padding: EdgeInsets.only(top: 16.0, left: 16.0, bottom: 8.0),
            child: Text('Account Settings', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blueAccent)),
          ),
          ListTile(
            leading: Icon(Icons.lock),
            title: Text('Change Password'),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
          ),
          ListTile(
            leading: Icon(Icons.email),
            title: Text('Update Email'),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
          ),
          
          Divider(),

          // Grup Notifikasi
          Padding(
            padding: EdgeInsets.only(top: 8.0, left: 16.0, bottom: 8.0),
            child: Text('Notifications', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blueAccent)),
          ),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Push Notifications'),
            trailing: Switch(value: true, onChanged: null), // Contoh Switch
          ),
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text('Likes and Comments'),
            trailing: Switch(value: true, onChanged: null),
          ),

          Divider(),
          
          // Grup Lainnya
          Padding(
            padding: EdgeInsets.only(top: 8.0, left: 16.0, bottom: 8.0),
            child: Text('App Information', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blueAccent)),
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('About StageTalk'),
            trailing: Text('v1.0.0'),
          ),
        ],
      ),
    );
  }
}