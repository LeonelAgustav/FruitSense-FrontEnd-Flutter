import 'dart:io';
import '../api/api_service.dart';
import '../models/inventory_models.dart'; // Pastikan model ini ada (FruitItem)

class FruitRepository {
  final ApiService _apiService = ApiService();

  // 1. Ambil semua data buah (Inventory)
  Future<List<dynamic>> getFruits() async {
    try {
      final response = await _apiService.getInventories();
      // Asumsi response backend: { "data": [ ...list buah... ] }
      // Nanti kita mapping ke Model di sini
      return response['data']; 
    } catch (e) {
      throw Exception('Gagal mengambil data buah: $e');
    }
  }

  // 2. Tambah buah baru + Upload Gambar
  Future<bool> addFruit(String name, String stock, String price, File imageFile) async {
    try {
      // Siapkan data text yang dibutuhkan backend
      Map<String, String> textData = {
        'name': name,
        'stock': stock,
        'price': price,
        // Tambahkan field lain sesuai database Anda (misal: category, dll)
      };

      await _apiService.createInventory(textData, imageFile);
      return true; // Berhasil
    } catch (e) {
      print("Repository Error: $e");
      return false; // Gagal
    }
  }

  // 3. Hapus buah
  Future<bool> deleteFruit(String id) async {
    try {
      await _apiService.deleteInventory(id);
      return true;
    } catch (e) {
      print("Gagal hapus: $e");
      return false;
    }
  }
}