import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key, required String userName, required String userEmail});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  String userName = 'Rahul';
  String userEmail = 'rahulpatna89@gmail.com';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      final url = Uri.parse('https://mock-api.calleyacd.com/api/auth/register');
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": "Dhrubo",
          "email": "dhrubo@yopmail.com",
          "password": "123"
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        setState(() {
          userName = data['user']?['username'] ?? 'Rahul';
          userEmail = data['user']?['email'] ?? 'rahulpatna89@gmail.com';
        });
      } else {
        print("Failed: ${response.statusCode}");
      }
    } catch (e) {
      print('API error: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 280,
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UserAccountsDrawerHeader(
                    accountName: Text(userName),
                    accountEmail: Text(userEmail),
                    currentAccountPicture: const CircleAvatar(
                      backgroundImage: NetworkImage(
                        'https://cdn-icons-png.flaticon.com/512/6997/6997662.png',
                      ),
                    ),
                    decoration: const BoxDecoration(color: Color(0xFF2764FA)),
                  ),
                  const DrawerItem(icon: Icons.flag, label: 'Getting Started'),
                  const DrawerItem(icon: Icons.sync, label: 'Sync Data'),
                  const DrawerItem(icon: Icons.emoji_events, label: 'Gamification'),
                  const DrawerItem(icon: Icons.send, label: 'Send Logs'),
                  const DrawerItem(icon: Icons.settings, label: 'Settings'),
                  const DrawerItem(icon: Icons.help, label: 'Help?'),
                  const DrawerItem(icon: Icons.cancel, label: 'Cancel Subscription'),
                  const Divider(thickness: 1),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text("App Info", style: TextStyle(color: Colors.grey)),
                  ),
                  const DrawerItem(icon: Icons.info, label: 'About Us'),
                  const DrawerItem(icon: Icons.privacy_tip, label: 'Privacy Policy'),
                  const DrawerItem(icon: Icons.system_update, label: 'Version 1.01.52'),
                  const DrawerItem(icon: Icons.share, label: 'Share App'),
                  const DrawerItem(icon: Icons.logout, label: 'Logout'),
                ],
              ),
            ),
    );
  }
}

class DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const DrawerItem({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, size: 22, color: Colors.black87),
      title: Text(label, style: const TextStyle(fontSize: 15)),
      onTap: () {},
    );
  }
}
