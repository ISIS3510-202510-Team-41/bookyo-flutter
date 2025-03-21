import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_api/amplify_api.dart';      // <-- Para usar AmplifyAPI
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

import 'models/ModelProvider.dart';                // <-- Modelos generados
import 'viewmodels/auth_vm.dart';
import 'views/splash_view.dart';

Future<void> configureAmplify() async {
  try {
    print("⚡ Iniciando configuración de Amplify...");

    // Sólo configuramos Amplify si no lo estaba antes
    if (!Amplify.isConfigured) {
      // 1. Cargar tu amplify_outputs.json
      print("🛠️ Cargando configuración desde amplify_outputs.json...");
      final String configString =
          await rootBundle.loadString('lib/amplify_outputs.json');
      final Map<String, dynamic> config = json.decode(configString);

      // 2. Agregar plugin de Auth (Cognito)
      print("🔌 Agregando plugin de autenticación...");
      await Amplify.addPlugin(AmplifyAuthCognito());

      // 3. Agregar plugin de API (GraphQL / REST), con modelProvider para las clases generadas
      // print("🔌 Agregando plugin de API...");
      // final apiPlugin = AmplifyAPI(
      //   options: APIPluginOptions(
      //     modelProvider: ModelProvider.instance,
      //   ),
      // );
      // await Amplify.addPlugin(apiPlugin);

      // 4. Configurar Amplify con el JSON
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
  // Asegura que los widgets (y el binding) estén inicializados
  WidgetsFlutterBinding.ensureInitialized();

  // Configurar Amplify antes de iniciar la app
  await configureAmplify();

  // Iniciar la app con Provider para AuthViewModel
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
      title: 'Flutter AWS Cognito + API',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SplashView(),
    );
  }
}
