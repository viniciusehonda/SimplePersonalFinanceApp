import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spfa/src/authentication/login_view.dart';

const maxSessionDuration = Duration(hours: 1);

Future<void> saveLoginState(bool isLoggedIn, {String? username}) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('isLoggedIn', isLoggedIn);

  if (isLoggedIn) {
    await prefs.setString('username', username ?? "");
    final loginTime =
        DateTime.now().millisecondsSinceEpoch; // Save the login time
    await prefs.setInt('loginTimestamp', loginTime);
  } else {
    await prefs.remove('username');
    await prefs.remove('loginTimestamp'); // Clear the timestamp on logout
  }
}

Future<bool> getLoginState() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('isLoggedIn') ?? false;
}

Future<bool> isSessionExpired() async {
  final prefs = await SharedPreferences.getInstance();
  final loginTimestamp = prefs.getInt('loginTimestamp');

  if (loginTimestamp == null) {
    return true; // No timestamp means the session is expired
  }

  final loginTime = DateTime.fromMillisecondsSinceEpoch(loginTimestamp);
  final currentTime = DateTime.now();
  return currentTime.difference(loginTime) > maxSessionDuration;
}

Future<void> checkSession(BuildContext context) async {
  final expired = await isSessionExpired();
  if (expired) {
    await saveLoginState(false);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginView()),
    );
  }
}

Future<String?> getUsername() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('username');
}
