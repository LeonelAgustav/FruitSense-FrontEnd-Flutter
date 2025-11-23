import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:math';

class NotificationHelper {
  // Singleton Pattern agar instance-nya tunggal 
  static final NotificationHelper _instance = NotificationHelper._internal();
  factory NotificationHelper() => _instance;
  NotificationHelper._internal();

  static const String _channelId = 'fruit_expiry_channel';
  static const String _channelName = 'Notifikasi Kesegaran Buah';
  static const String _channelDesc = 'Memberi tahu jika buah akan segera busuk';

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // 1. Inisialisasi (Panggil di main.dart)
  static Future<void> initialize() async {
    final NotificationHelper helper = NotificationHelper();
    
    // Setup Android
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher'); // Pastikan icon ada

    // Setup iOS
    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await helper.flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
    
    // Create Channel (Penting untuk Android 8.0+)
    // FlutterLocalNotificationsPlugin handle ini saat show(), 
    // tapi kita definisikan detailnya di method show.
  }

  // 2. Menampilkan Notifikasi
  Future<void> showExpiryNotification(String fruitName, int daysLeft) async {
    String message;
    if (daysLeft <= 0) {
      message = "Peringatan! $fruitName mungkin sudah busuk. Cek sekarang!";
    } else if (daysLeft == 1) {
      message = "Perhatian! $fruitName akan busuk besok.";
    } else {
      message = "$fruitName akan busuk dalam $daysLeft hari lagi. Segera konsumsi!";
    }

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDesc,
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      Random().nextInt(100000), // ID Random
      'Update Inventaris Buah',
      message,
      platformChannelSpecifics,
    );
  }
}