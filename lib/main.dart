import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shop_owner_app/core/firebase_api.dart';
import 'package:shop_owner_app/core/models/theme_preferences.dart';

import 'my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Future.wait(
    [
      FirebaseApi().initNotifications(),
      _setPreferredOrientations(),
    ],
  );
  runApp(MyApp(isDarkTheme: await ThemePreferences().getTheme()));
}

Future<void> _setPreferredOrientations() async {
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
}
