import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spfa/helpers/AuthenticationHelper.dart';
import 'package:spfa/src/authentication/login_view.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {

  Timer? _sessionCheckTimer;
  String username = '';

  @override
  void initState() {
    super.initState();
    _startSessionCheck();
    _loadUserData();
  }

  @override
  void dispose() {
    _sessionCheckTimer
        ?.cancel(); // Cancel the timer when the screen is disposed
    super.dispose();
  }

  void _startSessionCheck() {
    _sessionCheckTimer = Timer.periodic(Duration(minutes: 1), (_) async {
      final expired = await isSessionExpired();
      if (expired) {
        _logout(context);
      }
    });
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? '';
    });
  }

  Future<void> _logout(BuildContext context) async {
    await saveLoginState(false); // Clear login state
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(username), // Display username
            accountEmail: null, // Optionally display email or other data
            currentAccountPicture: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.blue, // Background color
              child: Text(
                username.isNotEmpty ? username[0].toUpperCase() : '',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.pushNamed(context, '/home');
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () async {
              _logout(context);
            },
          ),
        ],
      ),
    );
  }
}
