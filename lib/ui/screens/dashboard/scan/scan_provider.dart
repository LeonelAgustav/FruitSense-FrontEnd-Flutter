import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../data/repositories/fruit_repository.dart';

class ScanProvider extends ChangeNotifier {
  final FruitRepository _repository = FruitRepository();

  bool _isUploading = false;
  bool get isUploading => _isUploading;

  String? _uploadError;
  String? get uploadError => _uploadError;

  // Fungsi Upload ke Backend
  Future<bool> uploadAnalysisResult(String imagePath, int stock) async {
    _isUploading = true;
    _uploadError = null;
    notifyListeners();

    try {
      File imageFile = File(imagePath);

      // Panggil Repository
      final bool success = await _repository.uploadAndAnalyze(imageFile, stock);

      if (!success) {
        _uploadError = "Gagal mengupload. Coba lagi.";
      }

      _isUploading = false;
      notifyListeners();
      return success;
    } catch (e) {
      _uploadError = "Error: $e";
      _isUploading = false;
      notifyListeners();
      return false;
    }
  }
}
