import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../routes/app_routes.dart';
import '../../../../core/utils/permission_helper.dart';

class ScanHubScreen extends StatelessWidget {
  const ScanHubScreen({super.key});

  Future<void> _handleCameraClick(BuildContext context) async {
    // Cek Izin dulu
    await PermissionHelper.requestPermissions(context);
    if (await PermissionHelper.isCameraGranted()) {
      if (context.mounted) {
        Navigator.pushNamed(context, AppRoutes.SCAN_CAMERA);
      }
    }
  }

  Future<void> _handleGalleryClick(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null && context.mounted) {
      // Kirim path gambar ke Preview Screen
      Navigator.pushNamed(
        context,
        AppRoutes.SCAN_PREVIEW,
        arguments: image.path,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon Besar
            Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                color: AppColors.greenDark.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(32),
              ),
              child: const Icon(
                Icons.camera_alt,
                size: 64,
                color: AppColors.greenDark,
              ),
            ),
            const SizedBox(height: 32),

            Text(
              "Deteksi Kesegaran Buah",
              style: AppTextStyles.headlineBold,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              "Scan buahmu sekarang untuk mengetahui kualitas dan kesegarannya secara instan.",
              style: AppTextStyles.bodyLarge.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),

            // Tombol Kamera
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () => _handleCameraClick(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.greenDark,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.camera_alt, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      "Mulai Scan Kamera",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Tombol Galeri
            SizedBox(
              width: double.infinity,
              height: 56,
              child: OutlinedButton(
                onPressed: () => _handleGalleryClick(context),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(
                    color: AppColors.greenDark,
                    width: 1.5,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.image, color: AppColors.greenDark),
                    SizedBox(width: 8),
                    Text(
                      "Pilih dari Galeri",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.greenDark,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
