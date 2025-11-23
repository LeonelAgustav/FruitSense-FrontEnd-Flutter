class ApiConfig {
  // GANTI IP SESUAI DEVICE:
  // Emulator Android: 'http://10.0.2.2:8080' (Port Backend Anda 8080)
  // HP Fisik: 'http://192.168.1.XX:8080' (Cek IP Laptop Anda)
  static const String baseUrl = 'http://10.0.2.2:8080/api/v1';
  // static const String baseUrl = 'http://192.168.1.XX:8080/api/v1';

  static const int receiveTimeout = 15000;
  static const int connectionTimeout = 15000;
}
