import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _user;
  bool _isLoading = false;

  User? get user => _user;
  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    if (_isLoading == value) return; // Evita renders innecesarios
    _isLoading = value;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    setLoading(true);
    final newUser = await _authService.signIn(email, password);
    if (newUser != _user) { // Solo notifica si hay un cambio real
      _user = newUser;
      notifyListeners();
    }
    setLoading(false);
    return _user != null;
  }

  Future<void> logout() async {
    await _authService.signOut();
    _user = null;
    notifyListeners(); // Solo notifica cuando realmente cambia el estado
  }
}
