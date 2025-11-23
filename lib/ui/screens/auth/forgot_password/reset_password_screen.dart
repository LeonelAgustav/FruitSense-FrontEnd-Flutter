import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../routes/app_routes.dart';
import '../auth_provider.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthProvider>().clearResetErrors();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                AppConstants.fruitsense,
                width: 180,
                height: 180,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.eco,
                  size: 100,
                  color: AppColors.greenDark,
                ),
              ),
              const SizedBox(height: 24),

              Card(
                elevation: 8,
                shadowColor: Colors.black.withValues(alpha: 0.2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                color: theme.cardColor,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      const Text(
                        "Buat Password Baru",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.greenDark,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Masukkan kata sandi baru Anda. Pastikan berbeda dari yang sebelumnya untuk keamanan.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: theme.colorScheme.onSurfaceVariant,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Password Baru
                      TextField(
                        onChanged: (value) =>
                            authProvider.setResetPassword(value),
                        obscureText: !authProvider.isResetPasswordVisible,
                        decoration: InputDecoration(
                          labelText: "Password Baru",
                          prefixIcon: Icon(
                            Icons.lock,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              authProvider.isResetPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () =>
                                authProvider.toggleResetPasswordVisibility(),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: AppColors.greenDark,
                              width: 2,
                            ),
                          ),
                          errorText: authProvider.resetPasswordError,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Konfirmasi Password
                      TextField(
                        onChanged: (value) =>
                            authProvider.setResetConfirmPassword(value),
                        obscureText:
                            !authProvider.isResetConfirmPasswordVisible,
                        decoration: InputDecoration(
                          labelText: "Konfirmasi Password",
                          prefixIcon: Icon(
                            Icons.lock,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              authProvider.isResetConfirmPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () => authProvider
                                .toggleResetConfirmPasswordVisibility(),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: AppColors.greenDark,
                              width: 2,
                            ),
                          ),
                          errorText: authProvider.resetConfirmPasswordError,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Tombol Ubah Password
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
                            if (authProvider.validateResetPassword()) {
                              // Sukses, tampilkan halaman sukses
                              Navigator.pushNamed(
                                context,
                                AppRoutes.AUTH_SUCCESS,
                                arguments: {
                                  'title': 'Password Diubah!',
                                  'subtitle':
                                      'Kata sandi Anda telah berhasil diperbarui.',
                                  'buttonText': 'Masuk Sekarang',
                                  'onButtonClick': () {
                                    // Reset ke halaman Login (Hapus semua stack)
                                    Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      AppRoutes.LOGIN,
                                      (route) => false,
                                    );
                                  },
                                },
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.greenDark,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Ubah Password",
                            style: TextStyle(
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
            ],
          ),
        ),
      ),
    );
  }
}
