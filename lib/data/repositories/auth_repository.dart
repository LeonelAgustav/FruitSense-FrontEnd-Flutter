import '../api/api_service.dart';
import '../local/user_preferences.dart';
import '../models/auth_models.dart';

class AuthRepository {
  final ApiService _apiService = ApiService();
  final UserPreferences _userPreferences = UserPreferences();

  // --- LOGIN ---
  // Return String error message (null jika sukses) agar Provider tau detail errornya
  Future<String?> login(String email, String password) async {
    try {
      final responseMap = await _apiService.login(email, password);
      
      // Parse JSON ke Model
      final authResponse = AuthResponse.fromJson(responseMap);

      if (authResponse.accessToken != null) {
        // Simpan Token
        await _userPreferences.saveToken(authResponse.accessToken!);
        return null; // Sukses (tidak ada error)
      } else {
        return "Token tidak ditemukan dalam respon server.";
      }
    } catch (e) {
      return e.toString().replaceAll("Exception:", "").trim();
    }
  }

  // --- REGISTER ---
  Future<String?> register(String name, String email, String password) async {
    try {
      await _apiService.register(name, email, password);
      return null; // Sukses
    } catch (e) {
      return e.toString().replaceAll("Exception:", "").trim();
    }
  }

  // --- LOGOUT ---
  Future<void> logout() async {
    await _userPreferences.removeToken();
    try {
      await _apiService.logout();
    } catch (_) {}
  }
}