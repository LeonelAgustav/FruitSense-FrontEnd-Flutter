import '../core/utils/notification_helper.dart';

class BackgroundWorker {
  // Tambahkan method static ini
  static Future<bool> executeTask(
    String task,
    Map<String, dynamic>? inputData,
  ) async {
    switch (task) {
      case "FruitExpiryCheckTask":
        // Simulasi background task
        final notificationHelper = NotificationHelper();
        // Init ulang plugin notifikasi di background isolate
        // (Di real app, pastikan plugin support background isolate)
        await notificationHelper.showExpiryNotification("Cek Buah Anda", 1);
        return Future.value(true);
      default:
        return Future.value(true);
    }
  }
}
