import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScrenThemeViewModel extends ChangeNotifier {
  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  ScrenThemeViewModel() {
    _loadTheme(); // 앱 시작 시 저장된 테마 불러오기
  }

  void toggleTheme(bool isDark) async {
    _isDarkMode = isDark;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _isDarkMode); // 테마 저장
  }

  void _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    notifyListeners();
  }
}
