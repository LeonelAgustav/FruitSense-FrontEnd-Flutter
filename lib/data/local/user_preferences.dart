import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';

class UserPreferences {
  static final UserPreferences _instance = UserPreferences._internal();
  factory UserPreferences() => _instance;
  UserPreferences._internal();

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  Future<void> _checkInstance() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // ============================================================
  // --- THEME LOGIC ---
  // ============================================================
  
  String getTheme() {
    return _prefs?.getString(AppConstants.prefsKeyTheme) ?? 'SYSTEM';
  }

  Future<void> saveTheme(String theme) async {
    await _checkInstance();
    await _prefs?.setString(AppConstants.prefsKeyTheme, theme);
  }

  // ============================================================
  // --- TOKEN LOGIC (AUTH) ---
  // ============================================================
  
  static const String _keyToken = 'user_token';

  Future<void> saveToken(String token) async {
    await _checkInstance();
    await _prefs?.setString(_keyToken, token);
  }

  Future<String?> getToken() async {
    await _checkInstance();
    return _prefs?.getString(_keyToken);
  }

  Future<void> removeToken() async {
    await _checkInstance();
    await _prefs?.remove(_keyToken);
  }

  // ============================================================
  // --- NOTIFICATION LOGIC ---
  // ============================================================
  
  bool getPushNotification() {
    return _prefs?.getBool(AppConstants.prefsKeyPushNotif) ?? true;
  }

  Future<void> savePushNotification(bool isEnabled) async {
    await _checkInstance();
    await _prefs?.setBool(AppConstants.prefsKeyPushNotif, isEnabled);
  }

  bool getVibration() {
    return _prefs?.getBool(AppConstants.prefsKeyVibration) ?? false;
  }

  Future<void> saveVibration(bool isEnabled) async {
    await _checkInstance();
    await _prefs?.setBool(AppConstants.prefsKeyVibration, isEnabled);
  }

  // ============================================================
  // --- FCM TOKEN LOGIC ---
  // ============================================================
  static const String _keyFcmToken = 'fcm_token';

  Future<void> saveFcmToken(String token) async {
    await _checkInstance();
    await _prefs?.setString(_keyFcmToken, token);
  }

  Future<String?> getFcmToken() async {
    await _checkInstance();
    return _prefs?.getString(_keyFcmToken);
  }
}