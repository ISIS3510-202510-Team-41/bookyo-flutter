import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

class AuthViewModel with ChangeNotifier {
  bool isLoggedIn = false;
  String? userEmail;

  get user => null;

  /// 🔹 Método para esperar hasta que Amplify esté configurado antes de hacer login o registro
  Future<void> _ensureAmplifyConfigured() async {
    int retries = 5;
    while (!Amplify.isConfigured && retries > 0) {
      print("⏳ Esperando configuración de Amplify...");
      await Future.delayed(Duration(seconds: 1));
      retries--;
    }
    if (!Amplify.isConfigured) {
      print("❌ Error: Amplify no está configurado después de varios intentos.");
      throw Exception("Amplify no se configuró correctamente.");
    }
  }

  Future<bool> register(String email, String password) async {
    try {
      await _ensureAmplifyConfigured(); // 🔹 Esperar hasta que Amplify esté listo

      print("📝 Registrando usuario con email: $email");

      SignUpResult result = await Amplify.Auth.signUp(
        username: email, // ✅ Usando `email` como username
        password: password,
        options: SignUpOptions(userAttributes: {AuthUserAttributeKey.email: email}),
      );

      if (result.isSignUpComplete) {
        print("✅ Usuario registrado con éxito.");
        return true;
      }
      return false;
    } catch (e) {
      print("❌ Error en el registro: $e");
      return false;
    }
  }

Future<bool> login(String email, String password) async {
  try {
    // 🔹 Configurar Amplify solo si es necesario
    if (!Amplify.isConfigured) {
      await _ensureAmplifyConfigured();
    }

    // 🔹 Cerrar sesión si hay una sesión activa
    try {
      await Amplify.Auth.signOut();
      print("🔄 Sesión cerrada antes de iniciar sesión.");
    } catch (e) {
      print("⚠️ No se pudo cerrar sesión antes de iniciar sesión: $e");
    }

    print("🔐 Intentando iniciar sesión con: $email");

    SignInResult result = await Amplify.Auth.signIn(username: email, password: password);

    if (result.isSignedIn) {
      isLoggedIn = true;
      userEmail = email;
      notifyListeners(); // 🔹 Asegurar que la UI se actualice
      print("✅ Usuario autenticado correctamente.");
      return true;
    } else {
      print("⚠️ Usuario NO autenticado.");
      return false;
    }
  } catch (e) {
    print("❌ Error en login: $e");
    return false;
  }
}


  Future<void> logout() async {
    try {
      await _ensureAmplifyConfigured();
      await Amplify.Auth.signOut();
      isLoggedIn = false;
      notifyListeners();
      print("✅ Usuario cerró sesión correctamente.");
    } catch (e) {
      print("❌ Error al cerrar sesión: $e");
    }
  }

  /// 🔹 Método para verificar el código enviado por AWS Cognito
  Future<bool> verifyEmail(String email, String code) async {
    try {
      print("🔹 Verificando código para: $email");

      SignUpResult result = await Amplify.Auth.confirmSignUp(
        username: email,
        confirmationCode: code,
      );

      if (result.isSignUpComplete) {
        print("✅ Cuenta verificada correctamente.");
        return true;
      }
      return false;
    } catch (e) {
      print("❌ Error en la verificación: $e");
      return false;
    }
  }

  /// 🔹 Método para reenviar el código de verificación
  Future<bool> resendVerificationCode(String email) async {
    try {
      print("🔄 Reenviando código a: $email");

      await Amplify.Auth.resendSignUpCode(username: email);
      return true;
    } catch (e) {
      print("❌ Error al reenviar código: $e");
      return false;
    }
  }
}
