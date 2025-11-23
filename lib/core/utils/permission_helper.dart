import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';

// Migrasi dari PermissionHelper.kt
class PermissionHelper {
  
  // Meminta izin Kamera & Notifikasi sekaligus
  static Future<void> requestPermissions(BuildContext context) async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.notification, // Otomatis handle Android 13+
    ].request();

    final cameraStatus = statuses[Permission.camera];
    final notificationStatus = statuses[Permission.notification];

    // Cek apakah izin ditolak secara permanen
    if (cameraStatus == PermissionStatus.permanentlyDenied || 
        notificationStatus == PermissionStatus.permanentlyDenied) {
      if (context.mounted) {
        _showSettingsDialog(context);
      }
    }
  }

  static Future<bool> isCameraGranted() async {
    return await Permission.camera.isGranted;
  }

  static void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text("Izin Diperlukan"),
        content: const Text(
          "Aplikasi ini membutuhkan izin Kamera dan Notifikasi agar dapat berfungsi dengan baik. Mohon aktifkan di Pengaturan."
        ),
        actions: <Widget>[
          TextButton(
            child: const Text("Batal"),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text("Buka Pengaturan"),
            onPressed: () {
              openAppSettings();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}