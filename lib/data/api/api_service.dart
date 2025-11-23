import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart'; // Untuk debugPrint
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_config.dart';

class ApiService {
  Future<Map<String, String>> _getHeaders({bool isMultipart = false}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('user_token');

    Map<String, String> headers = {'Authorization': 'Bearer $token'};

    if (!isMultipart) {
      headers['Content-Type'] = 'application/json';
    }
    return headers;
  }

  // --- Helper Response ---
  dynamic _processResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      String msg = 'Error ${response.statusCode}';
      try {
        final body = jsonDecode(response.body);
        msg = body['error'] ?? body['message'] ?? msg;
      } catch (_) {}
      throw Exception(msg);
    }
  }

  // --- Auth ---
  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/auth/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    return _processResponse(response);
  }

  Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
  ) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/auth/register');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );
    return _processResponse(response);
  }

  Future<void> logout() async {
    final url = Uri.parse('${ApiConfig.baseUrl}/auth/logout');
    final headers = await _getHeaders();
    await http.post(url, headers: headers);
  }

  // --- Inventory ---
  Future<dynamic> getInventories() async {
    final url = Uri.parse('${ApiConfig.baseUrl}/inventory');
    final headers = await _getHeaders();
    final response = await http.get(url, headers: headers);
    return _processResponse(response);
  }

  Future<dynamic> createInventory(
    Map<String, String> fields,
    File imageFile,
  ) async {
    // Logic Create Manual (jika ada)
    // ... implementasi sama seperti analyzeAndSave tapi endpoint beda jika perlu
    return analyzeAndSave(
      imageFile,
      int.parse(fields['stock_quantity'] ?? '1'),
    );
  }

  Future<dynamic> deleteInventory(String id) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/inventory/$id');
    final headers = await _getHeaders();
    final response = await http.delete(url, headers: headers);
    return _processResponse(response); // Biasanya null atau success message
  }

  // --- History ---
  Future<dynamic> getHistory() async {
    final url = Uri.parse('${ApiConfig.baseUrl}/history');
    final headers = await _getHeaders();
    final response = await http.get(url, headers: headers);
    return _processResponse(response);
  }

  // --- Analysis ---
  Future<dynamic> analyzeAndSave(File imageFile, int stockQty) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/analyze');
    final headers = await _getHeaders(isMultipart: true);

    var request = http.MultipartRequest('POST', url);
    request.headers.addAll(headers);
    request.fields['stock_quantity'] = stockQty.toString();

    var pic = await http.MultipartFile.fromPath('image', imageFile.path);
    request.files.add(pic);

    debugPrint("Mengirim gambar ke $url ...");
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    return _processResponse(response);
  }

  // --- Profile ---
  Future<dynamic> getProfile() async {
    final url = Uri.parse('${ApiConfig.baseUrl}/user-profile');
    final headers = await _getHeaders();
    final response = await http.get(url, headers: headers);
    return _processResponse(response);
  }
}
