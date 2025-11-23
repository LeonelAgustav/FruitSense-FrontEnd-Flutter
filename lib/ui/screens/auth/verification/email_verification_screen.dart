import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../routes/app_routes.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  // State OTP
  final TextEditingController _otpController = TextEditingController();
  bool _isError = false;

  // State Timer
  Timer? _timer;
  int _timeLeft = 60;
  bool _isTimerRunning = true;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _timeLeft = 60;
    _isTimerRunning = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() {
          _timeLeft--;
        });
      } else {
        setState(() {
          _isTimerRunning = false;
        });
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    super.dispose();
  }

  void _verifyOtp() {
    final code = _otpController.text;
    if (code.length < 6) {
      setState(() => _isError = true);
    } else {
      // Simulasi Validasi (Hardcode 123456)
      if (code == "123456") {
        // Sukses -> Arahkan ke Reset Password (jika dari flow lupa password)
        // Atau ke AuthSuccess (jika dari register)
        // Disini kita asumsikan flow Lupa Password -> Reset Password
        Navigator.pushNamed(context, AppRoutes.RESET_PASSWORD);
      } else {
        setState(() => _isError = true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                AppConstants.fruitsense,
                width: 150,
                height: 150,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.eco, size: 100, color: AppColors.greenDark),
              ),
              const SizedBox(height: 32),

              Text(
                "Verifikasi Email",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.greenDark,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Masukkan 6 digit kode yang telah kami kirimkan ke email Anda.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),

              // --- CUSTOM OTP INPUT ---
              // Menggunakan Stack: TextField transparan di atas Row kotak-kotak
              SizedBox(
                height: 60,
                width: double.infinity,
                child: Stack(
                  children: [
                    // Tampilan Kotak-Kotak
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(6, (index) {
                        String char = "";
                        if (index < _otpController.text.length) {
                          char = _otpController.text[index];
                        }
                        
                        // Style logic
                        bool isFocused = index == _otpController.text.length;
                        bool isFilled = index < _otpController.text.length;
                        Color borderColor = _isError 
                            ? theme.colorScheme.error 
                            : (isFocused || isFilled ? AppColors.greenDark : theme.colorScheme.outline);
                        
                        return Container(
                          width: 45,
                          height: 56,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surface,
                            border: Border.all(color: borderColor, width: isFocused ? 2 : 1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            char,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: _isError ? theme.colorScheme.error : theme.colorScheme.onSurface,
                            ),
                          ),
                        );
                      }),
                    ),
                    // Invisible TextField
                    TextField(
                      controller: _otpController,
                      autofocus: true,
                      maxLength: 6,
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        if (_isError) setState(() => _isError = false);
                        setState(() {}); // Rebuild untuk update kotak
                      },
                      style: const TextStyle(color: Colors.transparent),
                      cursorColor: Colors.transparent,
                      decoration: const InputDecoration(
                        counterText: "", // Sembunyikan counter
                        border: InputBorder.none,
                        fillColor: Colors.transparent,
                        filled: true,
                      ),
                    ),
                  ],
                ),
              ),

              if (_isError) ...[
                const SizedBox(height: 8),
                Text(
                  "Kode verifikasi salah",
                  style: TextStyle(color: theme.colorScheme.error, fontSize: 14),
                ),
              ],

              const SizedBox(height: 24),

              // Timer & Kirim Ulang
              if (_timeLeft > 0)
                Text(
                  "Kirim ulang kode dalam 00:${_timeLeft.toString().padLeft(2, '0')}",
                  style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 14),
                )
              else
                TextButton(
                  onPressed: () {
                    startTimer();
                    // Logic kirim ulang email disini
                  },
                  child: const Text(
                    "Kirim Ulang Kode",
                    style: TextStyle(
                      color: AppColors.greenOlive,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

              const SizedBox(height: 32),

              // Tombol Verifikasi
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _verifyOtp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.greenDark,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Verifikasi",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
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