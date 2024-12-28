import 'package:flutter/material.dart';
import 'package:spfa/helpers/DatabaseHelper.dart';

class RegistrationView extends StatefulWidget {
  @override
  _RegistrationViewState createState() => _RegistrationViewState();
}

class _RegistrationViewState extends State<RegistrationView> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final DatabaseHelper dbHelper = DatabaseHelper();
  bool _isLoading = false;

  void _register(BuildContext context) async {
    final username = _usernameController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

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

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await dbHelper.registerUser(username, password);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration Successful')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Username already exists')),
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
      appBar: AppBar(title: Text('Register')),
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
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 450),
                    child: TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                          labelText: 'Username',
                          border: OutlineInputBorder(),
                          filled: true),
                    ),
                  ),
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
                  const SizedBox(height: 30),
                  ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 450),
                      child: TextField(
                        controller: _confirmPasswordController,
                        decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            border: OutlineInputBorder(),
                            filled: true),
                        obscureText: true,
                      )),
                  SizedBox(height: 20),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 450, minWidth: 250),
                    child: ElevatedButton(
                      onPressed: () => _register(context),
                      child: Text('Register'),
                    ),
                  ),
                ],
        ),
      ),
    );
  }
}
