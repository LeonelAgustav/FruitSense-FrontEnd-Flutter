import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../routes/app_routes.dart';
import 'auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthProvider>().clearLoginErrors();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final theme = Theme.of(context);

    // FIX: Menggunakan PopScope pengganti WillPopScope
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await SystemNavigator.pop();
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  AppConstants.fruitsense,
                  width: 220,
                  height: 220,
                  errorBuilder: (ctx, err, stack) =>
                      const Icon(Icons.eco, size: 100),
                ),
                const SizedBox(height: 20),

                // Card Login
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
                          "Masuk",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.greenDark,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Email Input
                        TextField(
                          onChanged: (value) =>
                              authProvider.setLoginEmail(value),
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
                            errorText: authProvider.loginEmailError,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Password Input
                        TextField(
                          onChanged: (value) =>
                              authProvider.setLoginPassword(value),
                          obscureText: !authProvider.isLoginPasswordVisible,
                          decoration: InputDecoration(
                            labelText: "Password",
                            prefixIcon: Icon(
                              Icons.lock,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                authProvider.isLoginPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                              onPressed: () =>
                                  authProvider.toggleLoginPasswordVisibility(),
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
                            errorText: authProvider.loginPasswordError,
                          ),
                        ),

                        // Global Error
                        if (authProvider.loginGlobalError != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            authProvider.loginGlobalError!,
                            style: TextStyle(
                              color: theme.colorScheme.error,
                              fontSize: 14,
                            ),
                          ),
                        ],

                        // Lupa Password Button
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.FORGOT_PASSWORD,
                              );
                            },
                            child: const Text(
                              "Lupa Password?",
                              style: TextStyle(
                                color: AppColors.greenOlive,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        // Tombol Masuk
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: authProvider.isLoading
                                ? null
                                : () async {
                                    bool success = await context
                                        .read<AuthProvider>()
                                        .login();
                                    if (success && context.mounted) {
                                      Navigator.pushReplacementNamed(
                                        context,
                                        AppRoutes.DASHBOARD,
                                      );
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.greenDark,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: authProvider.isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : const Text(
                                    "Masuk",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Link Daftar
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Belum punya akun? ",
                              style: TextStyle(
                                color: theme.colorScheme.onSurfaceVariant,
                                fontSize: 16,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.REGISTER,
                                );
                              },
                              child: const Text(
                                "Daftar",
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
      ),
    );
  }
}
