import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  
  // --- LOGIN STATE ---
  String _loginEmail = "";
  String _loginPassword = "";
  bool _isLoginPasswordVisible = false;
  
  String? _loginEmailError;
  String? _loginPasswordError;
  String? _loginGlobalError; // Tambahkan ini jika belum ada
  
  // Getters
  String get loginEmail => _loginEmail;
  String get loginPassword => _loginPassword;
  bool get isLoginPasswordVisible => _isLoginPasswordVisible;
  String? get loginEmailError => _loginEmailError;
  String? get loginPasswordError => _loginPasswordError;
  String? get loginGlobalError => _loginGlobalError;

  // --- LOGIN ACTIONS ---
  void setLoginEmail(String value) {
    _loginEmail = value;
    _loginEmailError = null;
    notifyListeners();
  }

  void setLoginPassword(String value) {
    _loginPassword = value;
    _loginPasswordError = null;
    notifyListeners();
  }

  void toggleLoginPasswordVisibility() {
    _isLoginPasswordVisible = !_isLoginPasswordVisible;
    notifyListeners();
  }

  void clearLoginErrors() {
    _loginEmailError = null;
    _loginPasswordError = null;
    _loginGlobalError = null;
    notifyListeners();
  }

  bool validateLogin() {
    bool isValid = true;
    if (_loginEmail.isEmpty) {
      _loginEmailError = "Email tidak boleh kosong";
      isValid = false;
    }
    if (_loginPassword.isEmpty) {
      _loginPasswordError = "Password tidak boleh kosong";
      isValid = false;
    }
    // Validasi Mock
    if (isValid && (_loginEmail != "admin@gmail.com" || _loginPassword != "admin")) {
      _loginGlobalError = "Email atau password salah";
      isValid = false;
    }
    notifyListeners();
    return isValid;
  }

  // --- REGISTER STATE ---
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

  // Getters Register
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

  // --- REGISTER ACTIONS ---
  void setRegFullName(String value) { _regFullName = value; notifyListeners(); }
  void setRegEmail(String value) { _regEmail = value; notifyListeners(); }
  void setRegPassword(String value) { _regPassword = value; notifyListeners(); }
  void setRegConfirmPassword(String value) { _regConfirmPassword = value; notifyListeners(); }
  
  void toggleRegPasswordVisibility() { _isRegPasswordVisible = !_isRegPasswordVisible; notifyListeners(); }
  void toggleRegConfirmPasswordVisibility() { _isRegConfirmPasswordVisible = !_isRegConfirmPasswordVisible; notifyListeners(); }

  void clearRegisterErrors() {
    _regFullNameError = null;
    _regEmailError = null;
    _regPasswordError = null;
    _regConfirmPasswordError = null;
    notifyListeners();
  }

  bool validateRegister() {
    bool isValid = true;
    if (_regFullName.isEmpty) { _regFullNameError = "Wajib diisi"; isValid = false; }
    if (_regEmail.isEmpty) { _regEmailError = "Wajib diisi"; isValid = false; }
    if (_regPassword.isEmpty) { _regPasswordError = "Wajib diisi"; isValid = false; }
    if (_regConfirmPassword != _regPassword) { _regConfirmPasswordError = "Password tidak sama"; isValid = false; }
    notifyListeners();
    return isValid;
  }

  // --- FORGOT & RESET PASSWORD ---
  // (Tambahkan method kosong minimal agar tidak error di UI lain)
  String _forgotEmail = "";
  String? _forgotEmailError;
  String get forgotEmail => _forgotEmail;
  String? get forgotEmailError => _forgotEmailError;
  
  void setForgotEmail(String v) { _forgotEmail = v; notifyListeners(); }
  void clearForgotErrors() { _forgotEmailError = null; notifyListeners(); }
  bool validateForgotPassword() { return _forgotEmail.isNotEmpty; }

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

  void setResetPassword(String v) { _resetPassword = v; notifyListeners(); }
  void setResetConfirmPassword(String v) { _resetConfirmPassword = v; notifyListeners(); }
  void toggleResetPasswordVisibility() { _isResetPasswordVisible = !_isResetPasswordVisible; notifyListeners(); }
  void toggleResetConfirmPasswordVisibility() { _isResetConfirmPasswordVisible = !_isResetConfirmPasswordVisible; notifyListeners(); }
  void clearResetErrors() { _resetPasswordError = null; _resetConfirmPasswordError = null; notifyListeners(); }
  bool validateResetPassword() { return _resetPassword.isNotEmpty && _resetPassword == _resetConfirmPassword; }
}