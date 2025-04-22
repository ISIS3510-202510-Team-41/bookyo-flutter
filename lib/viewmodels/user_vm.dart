import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

class UserViewModel with ChangeNotifier {
  AuthUser? _user;                  // Información básica del usuario (username, sub, etc.)
  Map<String, String>? _attributes; // Atributos extra como email, nombre, etc.
  bool _isLoading = false;

  // Getters públicos
  AuthUser? get user => _user;
  Map<String, String>? get attributes => _attributes;
  bool get isLoading => _isLoading;

  /// 🔹 Método para esperar hasta que Amplify esté configurado antes de buscar usuario
  Future<void> _ensureAmplifyConfigured() async {
    int retries = 5;
    while (!Amplify.isConfigured && retries > 0) {
      print("⏳ Esperando configuración de Amplify (UserVM)...");
      await Future.delayed(const Duration(seconds: 1));
      retries--;
    }
    if (!Amplify.isConfigured) {
      print("❌ Error: Amplify no está configurado (UserVM).");
      throw Exception("Amplify no se configuró correctamente (UserVM).");
    }
  }

  /// 🔹 Cargar información del usuario actualmente autenticado
  Future<void> fetchUser() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _ensureAmplifyConfigured();

      // Obtener usuario actual
      _user = await Amplify.Auth.getCurrentUser();

      // Obtener atributos del usuario
      final res = await Amplify.Auth.fetchUserAttributes();
      _attributes = {
        for (var attr in res) attr.userAttributeKey.key: attr.value,
      };

      print("✅ Usuario cargado: ${_user?.username}");
    } on AuthException catch (e) {
      print("❌ Error al obtener usuario: ${e.message}");
      _user = null;
      _attributes = null;
    } catch (e) {
      print("❌ Error inesperado en fetchUser: $e");
      _user = null;
      _attributes = null;
    }

    _isLoading = false;
    notifyListeners();
  }

  /// 🔹 Borrar datos locales del usuario (cuando hace logout)
  void clearUser() {
    _user = null;
    _attributes = null;
    notifyListeners();
  }
}
