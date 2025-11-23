// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import '../../../../data/models/inventory_models.dart';
import '../../../../data/repositories/fruit_repository.dart';

class HistoryProvider extends ChangeNotifier {
  final FruitRepository _repository = FruitRepository();

  List<FruitItem> _historyList = [];
  List<FruitItem> get historyList => _historyList;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  HistoryProvider() {
    loadHistory();
  }

  Future<void> loadHistory() async {
    _isLoading = true;
    notifyListeners();

    try {
      _historyList = await _repository.getHistoryList();
    } catch (e) {
      print("Gagal load history: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> refresh() async {
    await loadHistory();
  }
}
