import 'dart:convert';
import 'dart:io';

void main() {
  // 1. Tentukan path file
  final envFile = File('.env');
  final targetFile = File('android/app/google-services.json');

  // 2. Cek apakah .env ada
  if (!envFile.existsSync()) {
    print('Error: File .env tidak ditemukan di root project.');
    exit(1);
  }

  // 3. Baca .env dan parsing menjadi Map
  final envLines = envFile.readAsLinesSync();
  final Map<String, String> envVars = {};

  for (var line in envLines) {
    // Abaikan komentar atau baris kosong
    if (line.trim().isEmpty || line.startsWith('#')) continue;

    final parts = line.split('=');
    if (parts.length >= 2) {
      final key = parts[0].trim();
      // Menggabungkan kembali value jika ada tanda '=' di dalamnya (misal base64)
      final value = parts.sublist(1).join('=').trim(); 
      envVars[key] = value;
    }
  }

  // 4. Ambil variabel yang dibutuhkan
  final apiKey = envVars['FIREBASE_API_KEY'];
  final projectId = envVars['FIREBASE_PROJECT_ID'];
  final appId = envVars['FIREBASE_APP_ID'];

  if (apiKey == null || projectId == null || appId == null) {
    print('Error: Pastikan FIREBASE_API_KEY, FIREBASE_PROJECT_ID, dan FIREBASE_APP_ID ada di .env');
    exit(1);
  }

  // 5. Buat struktur JSON sesuai template Anda
  // Note: package_name diset sesuai request Anda, bisa juga ditaruh di .env jika mau dinamis
  final Map<String, dynamic> googleServicesJson = {
    "project_info": {
      "project_number": "848546376772", // Bisa diambil dari .env jika perlu dinamis
      "project_id": projectId,
      "storage_bucket": "$projectId.firebasestorage.app"
    },
    "client": [
      {
        "client_info": {
          "mobilesdk_app_id": appId,
          "android_client_info": {
            "package_name": "com.example.fruitsense"
          }
        },
        "oauth_client": [],
        "api_key": [
          {
            "current_key": apiKey
          }
        ],
        "services": {
          "appinvite_service": {
            "other_platform_oauth_client": []
          }
        }
      }
    ],
    "configuration_version": "1"
  };

  // 6. Tulis ke file android/app/google-services.json
  const JsonEncoder encoder = JsonEncoder.withIndent('  ');
  final String prettyJson = encoder.convert(googleServicesJson);

  targetFile.writeAsStringSync(prettyJson);

  print('✅ Berhasil membuat android/app/google-services.json dari konfigurasi .env');
}