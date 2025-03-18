import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/auth_vm.dart';
import 'views/home_view.dart';
import 'views/login_view.dart';


void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AuthViewModel(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authViewModel = context.watch<AuthViewModel>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: authViewModel.user != null ? HomeView() : LoginView(),
    );
  }
}
