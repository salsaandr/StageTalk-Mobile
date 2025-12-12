import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('StageTalk'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Semua'),
              Tab(text: 'Anda'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildAllNotifications(),
            const Center(child: Text('Notifikasi untuk Anda')),
          ],
        ),
      ),
    );
  }

  Widget _buildAllNotifications() {
    return ListView(
      children: [
        _buildNotificationItem(
          title: 'Treasure mentioned you in a post.',
          subtitle: 'Had a blast at my Dickie McParty birthday celebration...',
          time: '5 minutes ago',
          icon: Icons.person_add_alt,
          iconColor: Colors.purple,
        ),
        _buildNotificationItem(
          title: 'Kinaya followed Pepper and Sam.',
          time: '33 minutes ago',
          icon: Icons.people_outline,
          iconColor: Colors.orange,
        ),
        _buildNotificationItem(
          title: 'Sky and 21 others liked your post.',
          time: '4d ago',
          icon: Icons.favorite,
          iconColor: Colors.pink,
        ),
        _buildNotificationItem(
          title: 'Jean Pablo and 3 others started following you.',
          time: '1 year ago',
          icon: Icons.person_add_alt_1,
          iconColor: Colors.blue,
        ),
      ],
    );
  }

  Widget _buildNotificationItem({required String title, String? subtitle, required String time, required IconData icon, required Color iconColor}) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: iconColor.withOpacity(0.2),
        child: Icon(icon, color: iconColor),
      ),
      title: Text(title, style: const TextStyle(fontSize: 14)),
      subtitle: subtitle != null ? Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)) : null,
      trailing: Text(time, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      onTap: () {},
    );
  }
}