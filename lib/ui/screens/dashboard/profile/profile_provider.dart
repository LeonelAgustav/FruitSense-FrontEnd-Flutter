// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import '../../../../data/local/user_preferences.dart';
import '../../../../data/api/api_service.dart';
import '../../../../data/models/auth_models.dart';

class ProfileProvider extends ChangeNotifier {
  final UserPreferences _prefs = UserPreferences();
  final ApiService _apiService = ApiService();

  UserData? _user;
  UserData? get user => _user;

  // State Tema & Notif
  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  bool _pushNotificationEnabled = true;
  bool get pushNotificationEnabled => _pushNotificationEnabled;

  bool _vibrationEnabled = false;
  bool get vibrationEnabled => _vibrationEnabled;

  Future<void> loadTheme() async {
    await _prefs.init();
    final savedTheme = _prefs.getTheme();
    _updateThemeMode(savedTheme);

    _pushNotificationEnabled = _prefs.getPushNotification();
    _vibrationEnabled = _prefs.getVibration();

    // Load data user juga saat start
    loadUserProfile();

    notifyListeners();
  }

  // 🔥 FETCH DATA USER DARI BACKEND 🔥
  Future<void> loadUserProfile() async {
    try {
      final response = await _apiService.getProfile();
      // Response: { "user": { "id": "...", "name": "...", "avatar_url": "..." } }
      if (response['user'] != null) {
        _user = UserData.fromJson(response['user']);
        notifyListeners();
      }
    } catch (e) {
      print("Gagal load profile: $e");
    }
  }

  void updateTheme(String newTheme) {
    _prefs.saveTheme(newTheme);
    _updateThemeMode(newTheme);
  }

  void updatePushNotification(bool value) {
    _pushNotificationEnabled = value;
    _prefs.savePushNotification(value);
    notifyListeners();
  }

  void updateVibration(bool value) {
    _vibrationEnabled = value;
    _prefs.saveVibration(value);
    notifyListeners();
  }

  void _updateThemeMode(String themeString) {
    switch (themeString) {
      case 'LIGHT':
        _themeMode = ThemeMode.light;
        break;
      case 'DARK':
        _themeMode = ThemeMode.dark;
        break;
      default:
        _themeMode = ThemeMode.system;
    }
    notifyListeners();
  }
}
