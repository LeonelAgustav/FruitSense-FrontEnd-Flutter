import 'package:flutter/material.dart';
import '../../../../data/local/user_preferences.dart';

class ProfileProvider extends ChangeNotifier {
  final UserPreferences _prefs = UserPreferences();
  
  // State Tema
  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  // State Notifikasi
  bool _pushNotificationEnabled = true;
  bool get pushNotificationEnabled => _pushNotificationEnabled;

  bool _vibrationEnabled = false;
  bool get vibrationEnabled => _vibrationEnabled;

  // Init: Load semua preferensi saat app jalan
  Future<void> loadTheme() async {
    await _prefs.init(); // Pastikan prefs siap
    
    // Load Tema
    final savedTheme = _prefs.getTheme();
    _updateThemeMode(savedTheme);

    // Load Notifikasi
    _pushNotificationEnabled = _prefs.getPushNotification();
    _vibrationEnabled = _prefs.getVibration();
    
    notifyListeners();
  }

  // Update Tema
  void updateTheme(String newTheme) {
    _prefs.saveTheme(newTheme);
    _updateThemeMode(newTheme);
  }

  // Update Notifikasi
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