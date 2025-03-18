import 'package:amplify_flutter/amplify_flutter.dart';
import '../models/user.dart';

class AuthService {
  Future<bool> signUp(String email, String password) async {
    try {
      await Amplify.Auth.signUp(
        username: email,
        password: password,
      );
      return true;
    } catch (e) {
      print('Error en el registro: $e');
      return false;
    }
  }

  Future<bool> confirmSignUp(String email, String code) async {
    try {
      await Amplify.Auth.confirmSignUp(username: email, confirmationCode: code);
      return true;
    } catch (e) {
      print('Error en confirmación: $e');
      return false;
    }
  }

  Future<User?> signIn(String email, String password) async {
    try {
      await Amplify.Auth.signIn(username: email, password: password);
      return getCurrentUser();
    } catch (e) {
      print('Error al iniciar sesión: $e');
      return null;
    }
  }

  Future<User?> getCurrentUser() async {
    try {
      AuthUser authUser = await Amplify.Auth.getCurrentUser();
      return User(email: authUser.username);
    } catch (e) {
      print('No hay usuario autenticado: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      await Amplify.Auth.signOut();
    } catch (e) {
      print('Error al cerrar sesión: $e');
    }
  }
}
