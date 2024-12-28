import 'dart:convert';
import 'package:crypto/crypto.dart';

String hashPassword(String password) {
  final bytes = utf8.encode(password); // Convert password to bytes
  final digest = sha256.convert(bytes); // Hash the password
  return digest.toString(); // Return hashed password as a string
}
