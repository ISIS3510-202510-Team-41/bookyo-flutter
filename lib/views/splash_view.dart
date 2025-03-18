import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_vm.dart';
import 'login_view.dart';
import 'home_view.dart';

class SplashView extends StatefulWidget {
  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      final authViewModel = context.read<AuthViewModel>();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => (authViewModel.isLoggedIn ?? false) ? HomeView() : LoginView(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset('assets/logo.png', width: 200), // Logo en Splash Screen
      ),
    );
  }
}
