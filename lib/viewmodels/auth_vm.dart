import 'package:amplify_api/amplify_api.dart';
import 'package:bookyo_flutter/models/User.dart';
import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/connectivity_service.dart';

class RegisterResult {
  final bool success;
  final bool needsConfirmation;
  final String? errorType; // 'network', 'credentials', 'unknown'
  final String? message;

  RegisterResult({required this.success, required this.needsConfirmation, this.errorType, this.message});
}

class LoginResult {
  final bool success;
  final String? errorType; // 'network', 'credentials', 'unknown'
  final String? message;

  LoginResult({required this.success, this.errorType, this.message});
}

class AuthViewModel with ChangeNotifier {
  bool isLoggedIn = false;
  String? userEmail;
  User? currentUser; // ✅ Aquí guardamos el perfil completo

  User? get user => currentUser; // ✅ Getter limpio para el User

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

  /// 🔹 Método para auto-login al abrir la app
  Future<bool> autoLogin() async {
    try {
       final session = await Amplify.Auth.fetchAuthSession();

      if (session.isSignedIn) {
        final userAttributes = await Amplify.Auth.fetchUserAttributes();
        final emailAttribute = userAttributes.firstWhere(
          (attr) => attr.userAttributeKey == AuthUserAttributeKey.email,
          orElse: () => throw Exception('Email attribute not found'),
        );

        userEmail = emailAttribute.value;
        isLoggedIn = true;

        print("✅ Auto-login exitoso con email: $userEmail");

        // Ahora fetchUserProfile aquí mismo
        await fetchUserProfile();

        notifyListeners();
        return true;
      } else {
        print("🔒 Usuario no autenticado.");
        isLoggedIn = false;
        userEmail = null;
        currentUser = null;
        notifyListeners();
        return false;
      }
    } catch (e) {
      print("❌ Error en auto-login: $e");
      isLoggedIn = false;
      userEmail = null;
      currentUser = null;
      notifyListeners();
      return false;
    }
  }

  /// 🔹 Registro de usuario
  Future<RegisterResult> register(String email, String password) async {
    if (!await ConnectivityService.hasInternet()) {
      print("❌ No internet connection for register.");
      return RegisterResult(success: false, needsConfirmation: false, errorType: 'network', message: 'No internet connection.');
    }
    try {
      await _ensureAmplifyConfigured();
      print("📝 Registrando usuario con email: $email");

      SignUpResult result = await Amplify.Auth.signUp(
        username: email,
        password: password,
        options: SignUpOptions(userAttributes: {AuthUserAttributeKey.email: email}),
      );

      if (result.isSignUpComplete) {
        print("✅ Usuario registrado y confirmado.");
        return RegisterResult(success: true, needsConfirmation: false);
      } else {
        print("✅ Usuario registrado pero necesita verificación de email.");
        return RegisterResult(success: true, needsConfirmation: true);
      }
    } on AuthException catch (e) {
      print("❌ Error específico de autenticación:");
      print("🔎 Código: ${e.runtimeType}");
      print("🔎 Mensaje: ${e.message}");
      final msg = e.toString().toLowerCase();
      if (msg.contains('network') || msg.contains('host lookup')) {
        return RegisterResult(success: false, needsConfirmation: false, errorType: 'network', message: e.message);
      }
      return RegisterResult(success: false, needsConfirmation: false, errorType: 'credentials', message: e.message);
    } catch (e) {
      print("❌ Error general en el registro: $e");
      return RegisterResult(success: false, needsConfirmation: false, errorType: 'unknown', message: e.toString());
    }
  }

  /// 🔹 Login de usuario
  Future<LoginResult> login(String email, String password) async {
    try {
      if (!Amplify.isConfigured) {
        await _ensureAmplifyConfigured();
      }

      AuthSession session = await Amplify.Auth.fetchAuthSession();
      if (session.isSignedIn) {
        print("�� Un usuario ya está autenticado. Cerrando sesión...");
        await Amplify.Auth.signOut();
        await Future.delayed(Duration(seconds: 1));
      }

      print("🔐 Intentando iniciar sesión con: $email");

      SignInResult result = await Amplify.Auth.signIn(username: email, password: password);

      if (result.isSignedIn) {
        isLoggedIn = true;
        userEmail = email;
        await fetchUserProfile(); // ✅ Cargar automáticamente el perfil
        notifyListeners();
        print("✅ Usuario autenticado correctamente.");
        return LoginResult(success: true);
      } else {
        print("⚠️ Usuario NO autenticado.");
        return LoginResult(success: false, errorType: 'credentials', message: 'Credenciales incorrectas');
      }
    } on AuthException catch (e) {
      final msg = e.toString().toLowerCase();
      if (msg.contains('network') || msg.contains('host lookup')) {
        print("❌ Error de red en login: $e");
        return LoginResult(success: false, errorType: 'network', message: e.message);
      }
      print("❌ Error de autenticación en login: $e");
      return LoginResult(success: false, errorType: 'credentials', message: e.message);
    } catch (e) {
      print("❌ Error desconocido en login: $e");
      return LoginResult(success: false, errorType: 'unknown', message: e.toString());
    }
  }

  /// 🔹 Logout de usuario
  Future<void> logout() async {
    try {
      await _ensureAmplifyConfigured();
      await Amplify.Auth.signOut();
      isLoggedIn = false;
      userEmail = null;
      currentUser = null;
      notifyListeners();
      print("✅ Usuario cerró sesión correctamente.");
    } catch (e) {
      print("❌ Error al cerrar sesión: $e");
    }
  }

  /// 🔹 Verificar email con código
  Future<LoginResult> verifyEmailWithResult(String email, String code) async {
    if (!await ConnectivityService.hasInternet()) {
      print("❌ No internet connection for verify.");
      return LoginResult(success: false, errorType: 'network', message: 'No internet connection.');
    }
    try {
      print("🔹 Verificando código para: $email");
      SignUpResult result = await Amplify.Auth.confirmSignUp(
        username: email,
        confirmationCode: code,
      );
      if (result.isSignUpComplete) {
        print("✅ Cuenta verificada correctamente.");
        return LoginResult(success: true);
      }
      return LoginResult(success: false, errorType: 'credentials', message: 'Verification failed.');
    } on AuthException catch (e) {
      final msg = e.toString().toLowerCase();
      if (msg.contains('network') || msg.contains('host lookup')) {
        return LoginResult(success: false, errorType: 'network', message: e.message);
      }
      return LoginResult(success: false, errorType: 'credentials', message: e.message);
    } catch (e) {
      print("❌ Error en la verificación: $e");
      return LoginResult(success: false, errorType: 'unknown', message: e.toString());
    }
  }

  /// 🔹 Reenviar código de verificación
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

  /// 🔹 Crear el perfil del usuario en la base de datos
  Future<bool> createUserProfile({
    required String firstName,
    required String lastName,
    required String phone,
    required String address,
  }) async {
    try {
      if (userEmail == null) {
        print("❌ No email, cannot create profile");
        return false;
      }

      // 1. Check if user already exists
      final existing = await Amplify.API.query(
        request: ModelQueries.get(User.classType, UserModelIdentifier(email: userEmail!))
      ).response;

      if (existing.data != null) {
        print("⚠️ User already exists in the database: "+existing.data!.email);
        currentUser = existing.data;
        return true;
      }

      final user = User(
        email: userEmail!,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        address: address,
      );

      final request = ModelMutations.create(user);
      final response = await Amplify.API.mutate(request: request).response;

      if (response.data != null) {
        print("✅ User profile saved successfully: "+response.data!.email);
        currentUser = response.data;
        notifyListeners();
        return true;
      } else {
        print("⚠️ Error saving user profile: "+response.errors.toString());
        return false;
      }
    } catch (e, st) {
      print("❌ Error creating user profile: $e");
      print("�� Stacktrace: $st");
      return false;
    }
  }

  /// 🔹 Traer el perfil completo del usuario
  Future<User?> fetchUserProfile() async {
    if (userEmail == null) {
      print("❌ Cannot fetch user profile: userEmail is null");
      return null;
    }

    try {
      final request = ModelQueries.get(User.classType, UserModelIdentifier(email: userEmail!));
      final response = await Amplify.API.query(request: request).response;

      if (response.data != null) {
        print("✅ User profile fetched: ${response.data!.email}");
        currentUser = response.data;

        // 🧠 Guardar en SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('firstName', response.data?.firstName ?? '');
        await prefs.setString('lastName', response.data?.lastName ?? '');
        await prefs.setString('email', response.data?.email ?? '');
        await prefs.setString('phone', response.data?.phone ?? '');
        await prefs.setString('address', response.data?.address ?? '');

        notifyListeners();
        return currentUser;
      } else {
        print("⚠️ No existe perfil en base de datos, creando usuario básico...");

        final user = User(email: userEmail!);
        await Amplify.DataStore.save(user);

        currentUser = user;
        notifyListeners();
        return currentUser;
      }
    } catch (e) {
      print("❌ Error fetching or creating user profile: $e");
      return null;
    }
  }

}
