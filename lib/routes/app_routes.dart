abstract class AppRoutes {
  // --- Auth ---
  static const LOGIN = '/login';
  static const REGISTER = '/register';
  static const FORGOT_PASSWORD = '/forgot-password';
  static const RESET_PASSWORD = '/reset-password';
  static const EMAIL_VERIFICATION = '/email-verification';
  static const AUTH_SUCCESS = '/auth-success';

  // --- Dashboard (Main) ---
  // Halaman ini memuat BottomNavigationBar
  static const DASHBOARD = '/dashboard';

  // --- Detail & Analysis ---
  static const FRUIT_DETAIL = '/fruit-detail';
  static const FRUIT_ANALYSIS = '/fruit-analysis';

  // --- Scan Flow ---
  static const SCAN_HUB = '/scan-hub';
  static const SCAN_CAMERA = '/scan-camera';
  static const SCAN_PREVIEW = '/scan-preview';
  static const SCAN_RESULT = '/scan-result';

  // --- Profile Flow ---
  static const PROFILE_SETTINGS = '/profile-settings';
  static const PROFILE_NOTIFICATIONS = '/profile-notifications';
}