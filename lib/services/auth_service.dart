import 'package:amplify_flutter/amplify_flutter.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/user.dart';

class AuthService {
  Future<bool> signUp(String email, String password) async {
    return await compute(_signUpBackground, {'email': email, 'password': password});
  }

  Future<bool> confirmSignUp(String email, String code) async {
    return await compute(_confirmSignUpBackground, {'email': email, 'code': code});
  }

  Future<User?> signIn(String email, String password) async {
    return await compute(_signInBackground, {'email': email, 'password': password});
  }

  Future<User?> getCurrentUser() async {
    try {
      AuthUser authUser = await Amplify.Auth.getCurrentUser();
      return User(email: authUser.username);
    } catch (e) {
      return null;
    }
  }

  Future<void> signOut() async {
    await Amplify.Auth.signOut();
  }
}

// 🛠️ Métodos en segundo plano (Isolates)
Future<bool> _signUpBackground(Map<String, String> args) async {
  try {
    await Amplify.Auth.signUp(
      username: args['email']!,
      password: args['password']!,
    );
    return true;
  } catch (e) {
    return false;
  }
}

Future<bool> _confirmSignUpBackground(Map<String, String> args) async {
  try {
    await Amplify.Auth.confirmSignUp(
      username: args['email']!,
      confirmationCode: args['code']!,
    );
    return true;
  } catch (e) {
    return false;
  }
}

Future<User?> _signInBackground(Map<String, String> args) async {
  try {
    await Amplify.Auth.signIn(
      username: args['email']!,
      password: args['password']!,
    );
    return User(email: args['email']!);
  } catch (e) {
    return null;
  }
}