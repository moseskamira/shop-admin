import 'package:flutter/material.dart';
import 'package:shop_owner_app/core/models/theme_preferences.dart';

class ThemeChangeProvider with ChangeNotifier {
  ThemeChangeProvider(this._isDarkTheme);

  ThemePreferences themePreferences = ThemePreferences();

  bool _isDarkTheme;

  bool get isDarkTheme => _isDarkTheme;

  set isDarkTheme(bool value) {
    _isDarkTheme = value;
    themePreferences.setTheme(value);
    notifyListeners();
  }
}
