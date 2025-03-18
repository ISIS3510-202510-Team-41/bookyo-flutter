import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/auth_vm.dart';
import 'views/splash_view.dart';

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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter AWS Auth',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SplashView(), // Se inicia con la Splash Screen
    );
  }
}