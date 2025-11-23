import 'package:flutter/material.dart';
import '../../../../data/models/inventory_models.dart';
import '../../../../core/utils/notification_helper.dart';

class InventoryProvider extends ChangeNotifier {
  List<FruitItem> _inventoryList = [];
  List<FruitItem> get inventoryList => _inventoryList;

  final NotificationHelper _notificationHelper = NotificationHelper();

  InventoryProvider() {
    loadMockData();
  }

  void loadMockData() {
    final currentTime = DateTime.now().millisecondsSinceEpoch;
    const dayInMillis = 86400000; // 24 * 60 * 60 * 1000

    _inventoryList = [
      FruitItem(
        id: "1",
        name: "Pisang Cavendish",
        dateAdded: currentTime,
        expiryDate: currentTime + (1 * dayInMillis),
        freshness: 40,
        grade: "B",
        aiDescription: "Terdeteksi bintik coklat merata. Tekstur mulai melunak.",
        storageAdvice: "Segera konsumsi dalam 24 jam. Jangan simpan di kulkas.",
      ),
      FruitItem(
        id: "2",
        name: "Apel Fuji",
        dateAdded: currentTime,
        expiryDate: currentTime + (5 * dayInMillis),
        freshness: 85,
        grade: "A",
        aiDescription: "Kulit mulus tanpa memar. Warna merah merata.",
        storageAdvice: "Bisa bertahan 5-7 hari di suhu ruang.",
      ),
      FruitItem(
        id: "3",
        name: "Jeruk Mandarin",
        dateAdded: currentTime,
        expiryDate: currentTime + (2 * dayInMillis),
        freshness: 60,
        grade: "B",
        aiDescription: "Kulit sedikit keriput. Kadar air mulai berkurang.",
        storageAdvice: "Simpan di kulkas (chiller).",
      ),
      FruitItem(
        id: "4",
        name: "Mangga Harum Manis",
        dateAdded: currentTime,
        expiryDate: currentTime - (1 * dayInMillis), // Sudah lewat 1 hari
        freshness: 10,
        grade: "C",
        aiDescription: "Terdeteksi area lunak luas. Indikasi pembusukan.",
        storageAdvice: "Tidak disarankan konsumsi segar. Cek bagian dalam.",
      ),
    ];
    notifyListeners();
  }

  // Fungsi cek notifikasi (dipanggil saat screen dibuka)
  void checkFruitFreshnessAndNotify() {
    final currentTime = DateTime.now().millisecondsSinceEpoch;
    
    for (var fruit in _inventoryList) {
      final diff = fruit.expiryDate - currentTime;
      final daysLeft = (diff / (1000 * 60 * 60 * 24)).ceil();

      if (daysLeft <= 2) {
        _notificationHelper.showExpiryNotification(fruit.name, daysLeft);
      }
    }
  }
}