import 'dart:developer' as devtools show log;

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shop_owner_app/core/firebase_api.dart';
import 'package:shop_owner_app/core/models/theme_preferences.dart';

import 'my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseApi().initNotifications();

  final isDarkTheme = await ThemePreferences().getTheme();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(MyApp(isDarkTheme: isDarkTheme));
}

extension Log on Object {
  void log() => devtools.log(toString());
}
