import 'package:shared_preferences/shared_preferences.dart';
import '../api/api_service.dart';
import '../local/user_preferences.dart';

class AuthRepository {
  final ApiService _apiService = ApiService();
  final UserPreferences _userPreferences = UserPreferences();

  // --- LOGIN ---
  Future<bool> login(String email, String password) async {
    try {
      // 1. Minta API Service untuk login
      final response = await _apiService.login(email, password);

      // 2. Cek apakah ada token di response
      // Sesuaikan key 'token' dengan JSON response backend Anda
      if (response['data'] != null && response['data']['token'] != null) {
        String token = response['data']['token'];
        
        // 3. Simpan Token ke HP
        await _userPreferences.saveToken(token);
        
        // Opsional: Simpan info user lain jika perlu (nama, email, dll)
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Login Error: $e");
      return false; // Gagal Login
    }
  }

  // --- REGISTER ---
  Future<bool> register(String name, String email, String password) async {
    try {
      await _apiService.register(name, email, password);
      return true; // Register sukses
    } catch (e) {
      print("Register Error: $e");
      return false;
    }
  }

  // --- LOGOUT ---
  Future<void> logout() async {
    try {
      // 1. Hapus Token dari HP
      await _userPreferences.removeToken();
      
      // 2. Panggil endpoint logout di backend (jika ada)
      await _apiService.logout();
    } catch (e) {
      print("Logout Error: $e");
    }
  }
  
  // --- CEK STATUS LOGIN ---
  // Berguna untuk Splash Screen: menentukan mau ke Dashboard atau Login Screen
  Future<bool> isLoggedIn() async {
    String? token = await _userPreferences.getToken();
    return token != null && token.isNotEmpty;
  }
}