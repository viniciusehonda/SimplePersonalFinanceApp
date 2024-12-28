import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:spfa/helpers/CryptoHelper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    if (!kIsWeb &&
        (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
      // Initialize the ffi database factory for desktop
      databaseFactory = databaseFactoryFfi;
    }

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'login.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT UNIQUE,
        password TEXT
      )
    ''');
  }

  Future<int> registerUser(String username, String password) async {
    if (username.isEmpty || password.isEmpty) {
      throw Exception('Username and password cannot be empty');
    }

    final hashedPassword = hashPassword(password); // Hash the password

    final db = await database;
    return await db.insert(
      'users',
      {'username': username, 'password': hashedPassword},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, dynamic>?> loginUser(
      String username, String password) async {
    if (username.isEmpty || password.isEmpty) {
      throw Exception('Username and password cannot be empty');
    }

    final hashedPassword = hashPassword(password); // Hash the input password
    final db = await database;
    final result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, hashedPassword], // Compare hashed passwords
    );
    return result.isNotEmpty ? result.first : null;
  }
}
