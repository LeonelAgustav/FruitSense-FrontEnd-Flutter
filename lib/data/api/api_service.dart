import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/auth_models.dart'; // Pastikan model sudah ada
// Import model lain jika perlu

class ApiService {
  // ⚠️ PENTING: Ganti IP ini sesuai environment
  // Emulator: 'http://10.0.2.2:3000/api'
  // HP Fisik: 'http://192.168.1.XX:3000/api' (Cek IP Laptop)
  static const String baseUrl = 'http://10.0.2.2:3000'; 

  // --- HELPER: Ambil Header dengan Token ---
  Future<Map<String, String>> _getHeaders({bool isMultipart = false}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token'); // Asumsi token disimpan dengan key 'token'
    
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
    };

    // Kalau bukan upload file, kita pakai JSON
    if (!isMultipart) {
      headers['Content-Type'] = 'application/json';
    }
    return headers;
  }

  // ===========================================================================
  // 1. AUTHENTICATION (Sesuai authRoutes.js)
  // ===========================================================================

  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/auth/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    return _processResponse(response);
  }

  Future<Map<String, dynamic>> register(String name, String email, String password) async {
    final url = Uri.parse('$baseUrl/auth/register');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );

    return _processResponse(response);
  }

  Future<void> logout() async {
    final url = Uri.parse('$baseUrl/auth/logout');
    final headers = await _getHeaders();
    await http.post(url, headers: headers);
  }

  // ===========================================================================
  // 2. INVENTORY (Sesuai inventoryRoutes.js + Upload Gambar)
  // ===========================================================================

  // ⚠️ INI BAGIAN PALING TRICKY (Multipart Request)
  Future<dynamic> createInventory(Map<String, String> fields, File imageFile) async {
    final url = Uri.parse('$baseUrl/inventory');
    final headers = await _getHeaders(isMultipart: true);

    // Membuat Request Multipart
    var request = http.MultipartRequest('POST', url);
    request.headers.addAll(headers);

    // Masukkan data teks (nama buah, jumlah, dll)
    request.fields.addAll(fields);

    // Masukkan file gambar
    // 'image' harus sama persis dengan upload.single('image') di backend Node.js
    var pic = await http.MultipartFile.fromPath('image', imageFile.path);
    request.files.add(pic);

    // Kirim request
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    return _processResponse(response);
  }

  Future<dynamic> getInventories() async {
    final url = Uri.parse('$baseUrl/inventory');
    final headers = await _getHeaders();
    final response = await http.get(url, headers: headers);

    return _processResponse(response);
  }

  Future<dynamic> deleteInventory(String id) async {
    final url = Uri.parse('$baseUrl/inventory/$id');
    final headers = await _getHeaders();
    final response = await http.delete(url, headers: headers);

    return _processResponse(response);
  }

  // ===========================================================================
  // 3. HISTORY (Sesuai historyRoutes.js)
  // ===========================================================================

  Future<dynamic> getHistory() async {
    final url = Uri.parse('$baseUrl/history');
    final headers = await _getHeaders();
    final response = await http.get(url, headers: headers);

    return _processResponse(response);
  }

  Future<dynamic> addHistory(Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/history');
    final headers = await _getHeaders();
    final response = await http.post(
      url, 
      headers: headers,
      body: jsonEncode(data)
    );

    return _processResponse(response);
  }

  // ===========================================================================
  // 4. USER & FCM (Sesuai userRoutes.js)
  // ===========================================================================
  
  Future<void> updateFcmToken(String fcmToken) async {
    final url = Uri.parse('$baseUrl/user/fcm-token');
    final headers = await _getHeaders();
    await http.put(
      url,
      headers: headers,
      body: jsonEncode({'fcmToken': fcmToken}),
    );
  }

  // --- HELPER: Cek Error Code ---
  dynamic _processResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      // Jika sukses, kembalikan body JSON
      return jsonDecode(response.body);
    } else {
      // Jika error (400, 401, 500), lempar exception biar UI tau
      throw Exception('Error ${response.statusCode}: ${response.body}');
    }
  }
}