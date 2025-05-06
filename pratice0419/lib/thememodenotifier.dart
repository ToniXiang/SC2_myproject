import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeModeNotifier extends ChangeNotifier {
  String _themeMode = '淺色模式';

  String get themeMode => _themeMode;

  ThemeModeNotifier() {
    _loadThemePreference();
  }

  void setThemeMode(String newMode) async {
    _themeMode = newMode;
    notifyListeners();
    await _saveThemePreference(newMode);
  }

  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    _themeMode = prefs.getString('themeMode') ?? '淺色模式';
    notifyListeners();
  }

  Future<void> _saveThemePreference(String themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('themeMode', themeMode);
  }
}