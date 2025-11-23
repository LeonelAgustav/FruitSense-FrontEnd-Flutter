import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';
import 'package:permission_handler/permission_handler.dart';

import 'core/theme/app_theme.dart';
import 'core/utils/notification_helper.dart'; 
import 'ui/screens/auth/auth_provider.dart';
import 'ui/screens/dashboard/profile/profile_provider.dart';
import 'ui/screens/dashboard/history/history_provider.dart';
import 'ui/screens/dashboard/inventory/inventory_provider.dart';
import 'ui/screens/dashboard/scan/scan_provider.dart'; 

import 'routes/app_pages.dart';
import 'routes/app_routes.dart';
import 'services/background_worker.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    return await BackgroundWorker.executeTask(task, inputData);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // --- SETUP BACKGROUND SERVICE ---
  try {
    if (Platform.isAndroid || Platform.isIOS) {
      await Workmanager().initialize(
        callbackDispatcher,
        isInDebugMode: true 
      );
      
      await Workmanager().registerPeriodicTask(
        "FruitExpiryCheck",
        "FruitExpiryCheckTask",
        frequency: const Duration(hours: 12),
        existingWorkPolicy: ExistingPeriodicWorkPolicy.keep, 
      );
    }
  } catch (e) {
    print("Workmanager initialization failed (normal di Windows/Simulator): $e");
  }

  // --- SETUP NOTIFICATION ---
  try {
    await NotificationHelper.initialize(); 
  } catch (e) {
    print("Notification initialization failed: $e");
  }

  runApp(const FruitSenseApp());
}

class FruitSenseApp extends StatefulWidget {
  const FruitSenseApp({super.key});

  @override
  State<FruitSenseApp> createState() => _FruitSenseAppState();
}

class _FruitSenseAppState extends State<FruitSenseApp> {

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    if (Platform.isAndroid || Platform.isIOS) {
      await [
        Permission.notification,
        Permission.camera,
      ].request();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => HistoryProvider()),
        ChangeNotifierProvider(create: (_) => InventoryProvider()),
        ChangeNotifierProvider(create: (_) => ScanProvider()), 
        ChangeNotifierProvider(create: (_) => ProfileProvider()..loadTheme()), 
      ],
      child: Consumer<ProfileProvider>(
        builder: (context, profileProvider, child) {
          return MaterialApp(
            title: 'FruitSense',
            debugShowCheckedModeBanner: false,
            
            // Theme Configuration
            themeMode: profileProvider.themeMode, 
            theme: AppTheme.lightTheme, 
            darkTheme: AppTheme.darkTheme,

            // Navigation
            initialRoute: AppRoutes.LOGIN, 
            onGenerateRoute: AppPages.generateRoute, 
          );
        },
      ),
    );
  }
}