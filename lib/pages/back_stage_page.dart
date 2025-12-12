import 'package:flutter/material.dart';

class BackStagePage extends StatelessWidget {
  const BackStagePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BackStage Chat'),
      ),
      body: ListView(
        children: const [
          ListTile(
            leading: CircleAvatar(backgroundColor: Colors.red, child: Text('S')),
            title: Text('Sky (Artist)'),
            subtitle: Text('See you at the concert!'),
            trailing: Text('10:45 AM'),
          ),
          ListTile(
            leading: CircleAvatar(backgroundColor: Colors.blue, child: Text('Y')),
            title: Text('Yuna (Fan)'),
            subtitle: Text('Bagi link homework dong'),
            trailing: Text('Yesterday'),
          ),
          // Placeholder untuk chat
        ],
      ),
    );
  }
}