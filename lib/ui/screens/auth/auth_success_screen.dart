import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class AuthSuccessScreen extends StatelessWidget {
  final String title;
  final String subtitle;
  final String buttonText;
  final VoidCallback onButtonClick;

  const AuthSuccessScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.onButtonClick,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Ikon Sukses Besar
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.greenDark,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.check,
                  size: 60,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 40),

              // Judul
              Text(
                title,
                style: AppTextStyles.headlineBold.copyWith(
                  color: AppColors.greenDark,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // Deskripsi
              Text(
                subtitle,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),

              // Tombol Lanjut
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: onButtonClick,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.greenDark,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    buttonText,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}