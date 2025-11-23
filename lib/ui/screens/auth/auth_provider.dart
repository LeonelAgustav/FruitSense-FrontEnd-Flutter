import 'package:flutter/material.dart';
import '../../../../data/repositories/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _globalError;
  String? get globalError => _globalError;
  String? get loginGlobalError => _globalError; // Alias

  // ==========================
  // LOGIN SECTION
  // ==========================
  String _loginEmail = "";
  String _loginPassword = "";
  bool _isLoginPasswordVisible = false;
  String? _loginEmailError;
  String? _loginPasswordError;

  String get loginEmail => _loginEmail;
  String get loginPassword => _loginPassword;
  bool get isLoginPasswordVisible => _isLoginPasswordVisible;
  String? get loginEmailError => _loginEmailError;
  String? get loginPasswordError => _loginPasswordError;

  void setLoginEmail(String value) {
    _loginEmail = value;
    notifyListeners();
  }

  void setLoginPassword(String value) {
    _loginPassword = value;
    notifyListeners();
  }

  void toggleLoginPasswordVisibility() {
    _isLoginPasswordVisible = !_isLoginPasswordVisible;
    notifyListeners();
  }

  void clearLoginErrors() {
    _loginEmailError = null;
    _loginPasswordError = null;
    _globalError = null;
    notifyListeners();
  }

  Future<bool> login() async {
    bool isValid = true;
    if (_loginEmail.isEmpty) {
      _loginEmailError = "Wajib diisi";
      isValid = false;
    }
    if (_loginPassword.isEmpty) {
      _loginPasswordError = "Wajib diisi";
      isValid = false;
    }
    if (!isValid) {
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _globalError = null;
    notifyListeners();

    try {
      final String? error = await _authRepository.login(
        _loginEmail,
        _loginPassword,
      );
      _isLoading = false;
      if (error == null) return true;
      _globalError = error;
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      _globalError = e.toString();
      notifyListeners();
      return false;
    }
  }

  // ==========================
  // REGISTER SECTION
  // ==========================
  String _regFullName = "";
  String _regEmail = "";
  String _regPassword = "";
  String _regConfirmPassword = "";
  bool _isRegPasswordVisible = false;
  bool _isRegConfirmPasswordVisible = false;

  String? _regFullNameError;
  String? _regEmailError;
  String? _regPasswordError;
  String? _regConfirmPasswordError;

  String get regFullName => _regFullName;
  String get regEmail => _regEmail;
  String get regPassword => _regPassword;
  String get regConfirmPassword => _regConfirmPassword;
  bool get isRegPasswordVisible => _isRegPasswordVisible;
  bool get isRegConfirmPasswordVisible => _isRegConfirmPasswordVisible;
  String? get regFullNameError => _regFullNameError;
  String? get regEmailError => _regEmailError;
  String? get regPasswordError => _regPasswordError;
  String? get regConfirmPasswordError => _regConfirmPasswordError;

  void setRegFullName(String value) {
    _regFullName = value;
    notifyListeners();
  }

  void setRegEmail(String value) {
    _regEmail = value;
    notifyListeners();
  }

  void setRegPassword(String value) {
    _regPassword = value;
    notifyListeners();
  }

  void setRegConfirmPassword(String value) {
    _regConfirmPassword = value;
    notifyListeners();
  }

  void toggleRegPasswordVisibility() {
    _isRegPasswordVisible = !_isRegPasswordVisible;
    notifyListeners();
  }

  void toggleRegConfirmPasswordVisibility() {
    _isRegConfirmPasswordVisible = !_isRegConfirmPasswordVisible;
    notifyListeners();
  }

  void clearRegisterErrors() {
    _regFullNameError = null;
    _regEmailError = null;
    _regPasswordError = null;
    _regConfirmPasswordError = null;
    _globalError = null;
    notifyListeners();
  }

  bool validateRegister() {
    bool isValid = true;
    if (_regFullName.isEmpty) {
      _regFullNameError = "Wajib diisi";
      isValid = false;
    }
    if (_regEmail.isEmpty) {
      _regEmailError = "Wajib diisi";
      isValid = false;
    }
    if (_regPassword.isEmpty) {
      _regPasswordError = "Wajib diisi";
      isValid = false;
    }
    if (_regConfirmPassword != _regPassword) {
      _regConfirmPasswordError = "Password tidak sama";
      isValid = false;
    }
    notifyListeners();
    return isValid;
  }

  Future<bool> register() async {
    if (!validateRegister()) return false;
    _isLoading = true;
    _globalError = null;
    notifyListeners();
    try {
      final error = await _authRepository.register(
        _regFullName,
        _regEmail,
        _regPassword,
      );
      _isLoading = false;
      if (error == null) return true;
      _globalError = error;
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      _globalError = e.toString();
      notifyListeners();
      return false;
    }
  }

  // ==========================
  // FORGOT & RESET PASSWORD (YANG HILANG SEBELUMNYA)
  // ==========================

  // State Forgot Password
  String _forgotEmail = "";
  String? _forgotEmailError;
  String get forgotEmail => _forgotEmail;
  String? get forgotEmailError => _forgotEmailError;

  void setForgotEmail(String v) {
    _forgotEmail = v;
    notifyListeners();
  }

  void clearForgotErrors() {
    _forgotEmailError = null;
    notifyListeners();
  }

  bool validateForgotPassword() => _forgotEmail.isNotEmpty;

  // State Reset Password (FIX UNTUK ERROR UI)
  String _resetPassword = "";
  String _resetConfirmPassword = "";
  bool _isResetPasswordVisible = false;
  bool _isResetConfirmPasswordVisible = false;
  String? _resetPasswordError;
  String? _resetConfirmPasswordError;

  String get resetPassword => _resetPassword;
  String get resetConfirmPassword => _resetConfirmPassword;
  bool get isResetPasswordVisible => _isResetPasswordVisible;
  bool get isResetConfirmPasswordVisible => _isResetConfirmPasswordVisible;
  String? get resetPasswordError => _resetPasswordError;
  String? get resetConfirmPasswordError => _resetConfirmPasswordError;

  void setResetPassword(String v) {
    _resetPassword = v;
    notifyListeners();
  }

  void setResetConfirmPassword(String v) {
    _resetConfirmPassword = v;
    notifyListeners();
  }

  void toggleResetPasswordVisibility() {
    _isResetPasswordVisible = !_isResetPasswordVisible;
    notifyListeners();
  }

  void toggleResetConfirmPasswordVisibility() {
    _isResetConfirmPasswordVisible = !_isResetConfirmPasswordVisible;
    notifyListeners();
  }

  void clearResetErrors() {
    _resetPasswordError = null;
    _resetConfirmPasswordError = null;
    notifyListeners();
  }

  bool validateResetPassword() {
    bool isValid = true;
    if (_resetPassword.isEmpty) {
      _resetPasswordError = "Password baru wajib diisi";
      isValid = false;
    } else if (_resetPassword.length < 6) {
      _resetPasswordError = "Minimal 6 karakter";
      isValid = false;
    }

    if (_resetConfirmPassword != _resetPassword) {
      _resetConfirmPasswordError = "Password tidak cocok";
      isValid = false;
    }

    notifyListeners();
    return isValid;
  }
}
