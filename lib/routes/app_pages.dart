import 'package:flutter/material.dart';
import 'app_routes.dart';

import '../ui/screens/auth/login_screen.dart';
import '../ui/screens/auth/register_screen.dart';
import '../ui/screens/auth/forgot_password/forgot_password_screen.dart';
import '../ui/screens/auth/forgot_password/reset_password_screen.dart';
import '../ui/screens/auth/verification/email_verification_screen.dart';
import '../ui/screens/auth/auth_success_screen.dart';
import '../ui/screens/dashboard/dashboard_screen.dart';
import '../ui/screens/dashboard/detail/fruit_detail_screen.dart';
import '../ui/screens/dashboard/detail/fruit_analysis_screen.dart';
import '../ui/screens/dashboard/scan/scan_hub_screen.dart';
import '../ui/screens/dashboard/scan/camera_screen.dart';
import '../ui/screens/dashboard/scan/preview_screen.dart';
import '../ui/screens/dashboard/scan/result_screen.dart';
import '../ui/screens/dashboard/profile/settings_screen.dart';
import '../ui/screens/dashboard/profile/notification_screen.dart';
import '../data/models/inventory_models.dart';

class AppPages {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case AppRoutes.LOGIN:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      
      case AppRoutes.REGISTER:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      
      case AppRoutes.FORGOT_PASSWORD:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
      
      case AppRoutes.RESET_PASSWORD:
        return MaterialPageRoute(builder: (_) => const ResetPasswordScreen());
        
      case AppRoutes.EMAIL_VERIFICATION:
        return MaterialPageRoute(builder: (_) => const EmailVerificationScreen());
      
      case AppRoutes.AUTH_SUCCESS:
        if (args is Map<String, dynamic>) {
          return MaterialPageRoute(
            builder: (_) => AuthSuccessScreen(
              title: args['title'],
              subtitle: args['subtitle'],
              buttonText: args['buttonText'],
              onButtonClick: args['onButtonClick'], 
            ),
          );
        }
        return _errorRoute();

      case AppRoutes.DASHBOARD:
        // PERBAIKAN DISINI: Int -> int
        final initialTab = args is int ? args : 0; 
        return MaterialPageRoute(
          builder: (_) => DashboardScreen(initialTab: initialTab)
        );

      case AppRoutes.FRUIT_DETAIL:
        if (args is FruitItem) {
          return MaterialPageRoute(
            builder: (_) => FruitDetailScreen(fruitItem: args),
          );
        }
        return _errorRoute();

      case AppRoutes.FRUIT_ANALYSIS:
        if (args is FruitItem) {
          return MaterialPageRoute(
            builder: (_) => FruitAnalysisScreen(fruitItem: args),
          );
        }
        return _errorRoute();

      case AppRoutes.SCAN_HUB:
        return MaterialPageRoute(builder: (_) => const ScanHubScreen());

      case AppRoutes.SCAN_CAMERA:
        return MaterialPageRoute(builder: (_) => const CameraScreen());

      case AppRoutes.SCAN_PREVIEW:
        if (args is String) {
          return MaterialPageRoute(
            builder: (_) => PreviewScreen(imagePath: args),
          );
        }
        return _errorRoute();

      case AppRoutes.SCAN_RESULT:
        if (args is Map<String, dynamic>) {
          return MaterialPageRoute(
            builder: (_) => ResultScreen(
              imagePath: args['imagePath'],
              resultData: args['data'], 
            ),
          );
        }
        return _errorRoute();

      case AppRoutes.PROFILE_SETTINGS:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());

      case AppRoutes.PROFILE_NOTIFICATIONS:
        return MaterialPageRoute(builder: (_) => const NotificationScreen());

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('Halaman tidak ditemukan')),
      );
    });
  }
}