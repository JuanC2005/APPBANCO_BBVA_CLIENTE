import 'package:flutter/material.dart';
import '../model/user.dart';

class AuthViewModel extends ChangeNotifier {
  // Credenciales hardcodeadas para S9
  final User _hardcodedUser = User(
    dni: "12345678",
    password: "bbva123",
    name: "Juan Pérez",
  );

  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = "";

  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;

  Future<bool> login(String dni, String password) async {
    _isLoading = true;
    _hasError = false;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1)); // Simular loading

    _isLoading = false;
    if (dni == _hardcodedUser.dni && password == _hardcodedUser.password) {
      notifyListeners();
      return true;
    } else {
      _hasError = true;
      _errorMessage = "Credenciales incorrectas";
      notifyListeners();
      return false;
    }
  }
}
