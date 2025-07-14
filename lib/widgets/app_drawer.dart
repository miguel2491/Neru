import 'package:flutter/material.dart';
import '../screens/chat/ChatScreen.dart';
import '../screens/login/login_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Color(0xFF494859),
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Color(0xFF302F40)),
            margin: EdgeInsets.zero,
            padding: const EdgeInsets.all(12),
            child: const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Menú',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
          ListTile(
            title: Text('Chat', style: TextStyle(color: Colors.white)),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ChatScreen()),
            ),
          ),
          ListTile(
            title: Text('Cerrar sesión', style: TextStyle(color: Colors.white)),
            onTap: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => LoginScreen()),
            ),
          ),
        ],
      ),
    );
  }
}
