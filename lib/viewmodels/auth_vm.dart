import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _user;

  User? get user => _user; // Exponer el usuario

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners(); // 🔥 Notifica cambios a la UI
  }

  Future<bool> login(String email, String password) async {
    setLoading(true);
    _user = await _authService.signIn(email, password);
    setLoading(false);
    notifyListeners(); // 🔥 Dispara reconstrucción en los widgets dependientes
    return _user != null;
  }

  Future<void> logout() async {
    await _authService.signOut();
    _user = null;
    notifyListeners(); // 🔥 Notifica a la UI que ya no hay usuario autenticado
  }
}
