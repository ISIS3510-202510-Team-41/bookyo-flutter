import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_api/amplify_api.dart'; // Para usar GraphQL y REST
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

import 'models/ModelProvider.dart'; // Modelos generados automáticamente
import 'viewmodels/auth_vm.dart';
import 'viewmodels/user_vm.dart'; // 🚀 Importamos UserViewModel
import 'views/splash_view.dart';  // 🚀 Pantalla que decide entre Login y Home

Future<void> configureAmplify() async {
  try {
    print("⚡ Iniciando configuración de Amplify...");

    if (!Amplify.isConfigured) {
      print("🛠️ Cargando configuración desde amplify_outputs.json...");
      final String configString = await rootBundle.loadString('lib/amplify_outputs.json');
      final Map<String, dynamic> config = json.decode(configString);

      print("🔌 Agregando plugin de autenticación...");
      await Amplify.addPlugin(AmplifyAuthCognito());

      print("🔌 Agregando plugin de API (GraphQL / REST)...");
      final apiPlugin = AmplifyAPI(
        options: APIPluginOptions(
          modelProvider: ModelProvider.instance,
        ),
      );
      await Amplify.addPlugin(apiPlugin);

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
  await configureAmplify();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()), // 🔥 Login y registro
        ChangeNotifierProvider(create: (_) => UserViewModel()), // 🔥 Información del usuario logueado
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter AWS Amplify Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SplashView(), // ⏳ Pantalla de carga que decide navegación
    );
  }
}
