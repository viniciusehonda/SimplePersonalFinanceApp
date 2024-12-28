import 'dart:io';

import 'package:flutter/material.dart';
import 'package:spfa/helpers/DatabaseHelper.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final DatabaseHelper dbHelper = DatabaseHelper();
  bool _isLoading = false;

  void _login(BuildContext context) async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    if (username.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Username cannot be empty')),
      );
      return;
    }

    if (password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password cannot be empty')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final user = await dbHelper.loginUser(username, password);

      if (user != null) {
        // Successful login
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login Successful')),
        );
      } else {
        // Invalid credentials
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid Username or Password')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text('Login')),
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(27),
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.blueAccent, Colors.lightBlueAccent])),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _isLoading
              ? [CircularProgressIndicator()]
              : [
                  const SizedBox(height: 30),
                  const Text("Login",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 26)),
                  const SizedBox(height: 30),
                  ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 450),
                      child: TextField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          border: OutlineInputBorder(),
                          filled: true,
                        ),
                      )),
                  const SizedBox(height: 30),
                  ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 450),
                      child: TextField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(),
                            filled: true),
                        obscureText: true,
                      )),
                  SizedBox(height: 20),
                  ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 450, minWidth: 250),
                      child: ElevatedButton(
                          onPressed: () => _login(context),
                          child: Text('Login'))),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 450, minWidth: 250),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      child: Text('Register',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          )),
                    ),
                  ),
                ],
        ),
      ),
    );
  }
}
