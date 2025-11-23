import 'package:flutter/material.dart';

class ScanProvider extends ChangeNotifier {
  // State untuk menyimpan hasil sementara
  bool _isProcessing = false;
  bool get isProcessing => _isProcessing;

  void startProcessing() {
    _isProcessing = true;
    notifyListeners();
  }

  void stopProcessing() {
    _isProcessing = false;
    notifyListeners();
  }
  
  // Tambahkan fungsi ML Kit disini jika ingin logic terpisah dari UI
}