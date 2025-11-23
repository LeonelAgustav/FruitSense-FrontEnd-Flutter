// ignore_for_file: avoid_print

import 'dart:io';
import '../api/api_service.dart';
import '../models/inventory_models.dart';

class FruitRepository {
  final ApiService _apiService = ApiService();

  // 1. GET INVENTORY
  Future<List<FruitItem>> getInventoryList() async {
    try {
      final List<dynamic> responseData = await _apiService.getInventories();
      // Pastikan mapping tipe datanya eksplisit
      return responseData
          .map<FruitItem>((json) => FruitItem.fromJson(json))
          .toList();
    } catch (e) {
      print("Repo GetInventory Error: $e");
      return [];
    }
  }

  // 2. GET HISTORY
  Future<List<FruitItem>> getHistoryList() async {
    try {
      final response = await _apiService.getHistory();
      final List<dynamic> data = response['data'];

      // FIX ERROR 1 & 2: Tambahkan <FruitItem> dan parameter dateAdded
      return data.map<FruitItem>((json) {
        return FruitItem(
          id: json['id'].toString(),
          name: json['fruit_name'] ?? 'Unknown',
          imageUri: json['image_url'],
          grade: json['grade'] ?? '-',
          stock: 0,
          aiDescription: json['result_summary'] ?? '',
          storageAdvice: '',
          // Konversi created_at ke timestamp untuk expiryDate (sebagai placeholder)
          expiryDate: DateTime.parse(json['created_at']).millisecondsSinceEpoch,
          // FIX: Parameter dateAdded wajib diisi (ambil dari created_at)
          dateAdded: DateTime.parse(json['created_at']).millisecondsSinceEpoch,
          freshness: (json['grade'] == 'A')
              ? 90
              : (json['grade'] == 'B' ? 70 : 40),
          recipes: [],
        );
      }).toList();
    } catch (e) {
      print("Repo GetHistory Error: $e");
      return [];
    }
  }

  // 3. UPLOAD & ANALYZE
  Future<bool> uploadAndAnalyze(File image, int stock) async {
    try {
      await _apiService.analyzeAndSave(image, stock);
      return true;
    } catch (e) {
      return false;
    }
  }
}
