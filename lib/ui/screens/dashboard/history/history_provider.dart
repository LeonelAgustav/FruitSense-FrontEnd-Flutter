import 'package:flutter/material.dart';
import '../../../../data/models/inventory_models.dart';

class HistoryProvider extends ChangeNotifier {
  List<FruitItem> _historyList = [];
  List<FruitItem> get historyList => _historyList;

  HistoryProvider() {
    loadMockHistory();
  }

  void loadMockHistory() {
    final currentTime = DateTime.now().millisecondsSinceEpoch;
    const dayInMillis = 86400000;

    // Data Dummy History (mirip Inventory tapi expiredDate 0 atau masa lampau)
    _historyList = [
      FruitItem(
        id: "1", 
        name: "Pisang Cavendish", 
        dateAdded: currentTime, 
        expiryDate: 0, 
        freshness: 40, 
        grade: "B"
      ),
      FruitItem(
        id: "2", 
        name: "Apel Fuji", 
        dateAdded: currentTime - (1 * dayInMillis), 
        expiryDate: 0, 
        freshness: 85, 
        grade: "A"
      ),
      FruitItem(
        id: "3", 
        name: "Jeruk Mandarin", 
        dateAdded: currentTime - (2 * dayInMillis), 
        expiryDate: 0, 
        freshness: 60, 
        grade: "B"
      ),
    ];
    notifyListeners();
  }
  
  void addToHistory(FruitItem item) {
    _historyList.insert(0, item);
    notifyListeners();
  }
}