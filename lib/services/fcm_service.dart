// ignore_for_file: avoid_print

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../core/utils/notification_helper.dart';
import '../data/local/user_preferences.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // Tampilkan notifikasi lokal jika diperlukan saat background
  print("Handling a background message: ${message.messageId}");
}

class FcmService {
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;
  static final NotificationHelper _notificationHelper = NotificationHelper();

  // Inisialisasi FCM
  static Future<void> initialize() async {
    // 1. Request Permission (Khusus iOS & Android 13+)
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');

      // 2. Ambil Token FCM
      String? token = await _firebaseMessaging.getToken();
      if (token != null) {
        print("FCM Token: $token");
        // Simpan token ke lokal & NANTI kirim ke API Backend Anda disini
        await UserPreferences().saveFcmToken(token);
      }

      // 3. Setup Handler Foreground (Saat aplikasi dibuka)
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('Got a message whilst in the foreground!');
        print('Message data: ${message.data}');

        if (message.notification != null) {
          print(
            'Message also contained a notification: ${message.notification}',
          );

          // Tampilkan notifikasi lokal custom
          _notificationHelper.showExpiryNotification(
            message.notification!.title ?? "FruitSense",
            0,
          );
        }
      });

      // 4. Setup Handler Background
      FirebaseMessaging.onBackgroundMessage(
        _firebaseMessagingBackgroundHandler,
      );
    } else {
      print('User declined or has not accepted permission');
    }
  }

  static Future<String?> getCurrentToken() async {
    return await _firebaseMessaging.getToken();
  }
}
