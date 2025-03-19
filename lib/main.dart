import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

import 'viewmodels/auth_vm.dart';
import 'views/splash_view.dart';

Future<void> configureAmplify() async {
  try {
    print("⚡ Iniciando configuración de Amplify...");

    if (!Amplify.isConfigured) {
      print("🛠️ Cargando configuración desde amplify_outputs.json...");
      final String configString =
          await rootBundle.loadString('lib/amplify_outputs.json');
      final Map<String, dynamic> config = json.decode(configString);

      print("🔌 Agregando plugin de autenticación...");
      await Amplify.addPlugin(AmplifyAuthCognito());

      print("⚙️ Configurando Amplify...");
      await Amplify.configure(jsonEncode(config));

      print("✅ AWS Amplify configurado correctamente.");
    } else {
      print("⚠️ AWS Amplify ya estaba configurado.");
    }
  } catch (e) {
    print("❌ Error al configurar AWS Amplify: $e");
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureAmplify(); // Se asegura que Amplify se configure antes de lanzar la app

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
      title: 'Flutter AWS Cognito',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SplashView(),
    );
  }
}
