import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../routes/app_routes.dart';
import 'auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthProvider>().clearRegisterErrors();
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
              Image.asset(AppConstants.fruitsense, width: 220, height: 220),

              const SizedBox(height: 20),

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
                        "Daftar",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.greenDark,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Full Name Input
                      TextField(
                        onChanged: (value) =>
                            authProvider.setRegFullName(value),
                        decoration: InputDecoration(
                          labelText: "Nama Lengkap",
                          prefixIcon: Icon(
                            Icons.person,
                            color: theme.colorScheme.onSurfaceVariant,
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
                          errorText: authProvider.regFullNameError,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Email Input
                      TextField(
                        onChanged: (value) => authProvider.setRegEmail(value),
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: "Email",
                          prefixIcon: Icon(
                            Icons.email,
                            color: theme.colorScheme.onSurfaceVariant,
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
                          errorText: authProvider.regEmailError,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Password Input
                      TextField(
                        onChanged: (value) =>
                            authProvider.setRegPassword(value),
                        obscureText: !authProvider.isRegPasswordVisible,
                        decoration: InputDecoration(
                          labelText: "Password",
                          prefixIcon: Icon(
                            Icons.lock,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              authProvider.isRegPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () =>
                                authProvider.toggleRegPasswordVisibility(),
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
                          errorText: authProvider.regPasswordError,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Confirm Password Input
                      TextField(
                        onChanged: (value) =>
                            authProvider.setRegConfirmPassword(value),
                        obscureText: !authProvider.isRegConfirmPasswordVisible,
                        decoration: InputDecoration(
                          labelText: "Konfirmasi Password",
                          prefixIcon: Icon(
                            Icons.lock,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              authProvider.isRegConfirmPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () => authProvider
                                .toggleRegConfirmPasswordVisibility(),
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
                          errorText: authProvider.regConfirmPasswordError,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Tombol Daftar
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
                            if (authProvider.validateRegister()) {
                              // Navigasi ke Email Verification
                              Navigator.pushNamed(
                                context,
                                AppRoutes.EMAIL_VERIFICATION,
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
                            "Daftar",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Link Masuk
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Sudah punya akun? ",
                            style: TextStyle(
                              color: theme.colorScheme.onSurfaceVariant,
                              fontSize: 16,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // Kembali ke halaman Login (pop)
                              Navigator.pop(context);
                            },
                            child: const Text(
                              "Masuk",
                              style: TextStyle(
                                color: AppColors.greenOlive,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
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
