import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:spfa/helpers/AuthenticationHelper.dart';
import 'package:spfa/helpers/DatabaseHelper.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';

void main() async {
  // Set up the SettingsController, which will glue user settings to multiple
  // Flutter Widgets.
  final settingsController = SettingsController(SettingsService());

  // Load the user's preferred theme while the splash screen is displayed.
  // This prevents a sudden theme change when the app is first displayed.
  await settingsController.loadSettings();

  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    // Initialize databaseFactory for ffi
    sqfliteFfiInit();
  }

  final dbHelper = DatabaseHelper();
  await dbHelper.database;

  final isLoggedIn = await getLoginState();
  final sessionExpired = isLoggedIn ? await isSessionExpired() : true;

  // Run the app and pass in the SettingsController. The app listens to the
  // SettingsController for changes, then passes it further down to the
  // SettingsView.
  runApp(MyApp(settingsController: settingsController, isLoggedIn: isLoggedIn && !sessionExpired));
}
