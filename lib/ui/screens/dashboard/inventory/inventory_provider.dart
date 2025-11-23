import 'package:flutter/material.dart';
import '../../../../data/models/inventory_models.dart';
import '../../../../data/repositories/fruit_repository.dart';
import '../../../../core/utils/notification_helper.dart';

class InventoryProvider extends ChangeNotifier {
  final FruitRepository _repository = FruitRepository();
  final NotificationHelper _notificationHelper = NotificationHelper();

  List<FruitItem> _inventoryList = [];
  List<FruitItem> get inventoryList => _inventoryList;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  InventoryProvider() {
    loadInventory();
  }

  Future<void> loadInventory() async {
    _isLoading = true;
    notifyListeners();
    try {
      _inventoryList = await _repository.getInventoryList();
      checkFruitFreshnessAndNotify(); // Cek notifikasi setelah load data
    } catch (e) {
      debugPrint("Gagal load inventory: $e");
    }
    _isLoading = false;
    notifyListeners();
  }

  // Method yang sebelumnya hilang
  void checkFruitFreshnessAndNotify() {
    final currentTime = DateTime.now().millisecondsSinceEpoch;
    for (var fruit in _inventoryList) {
      final diff = fruit.expiryDate - currentTime;
      final daysLeft = (diff / (1000 * 60 * 60 * 24)).ceil();
      if (daysLeft <= 2 && daysLeft >= 0) {
        _notificationHelper.showExpiryNotification(fruit.name, daysLeft);
      }
    }
  }

  Future<void> refresh() async {
    await loadInventory();
  }
}
