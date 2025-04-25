import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:bookyo_flutter/viewmodels/books_vm.dart';
import 'package:bookyo_flutter/viewmodels/user_library_vm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

import 'models/ModelProvider.dart';
import 'viewmodels/auth_vm.dart';
import 'viewmodels/user_vm.dart';
import 'views/splash_view.dart';

Future<void> configureAmplify() async {
  try {
    print("⚡ Iniciando configuración de Amplify...");

    if (!Amplify.isConfigured) {
      final String configString = await rootBundle.loadString('lib/amplify_outputs.json');
      final Map<String, dynamic> config = json.decode(configString);

      await Amplify.addPlugin(AmplifyDataStore(modelProvider: ModelProvider.instance));
      await Amplify.addPlugin(AmplifyAuthCognito());
      await Amplify.addPlugin(AmplifyAPI(options: APIPluginOptions(modelProvider: ModelProvider.instance)));
      await Amplify.addPlugin(AmplifyStorageS3());

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

  // 🔍 Verificar conectividad a internet (sin usar connectivity_plus)
  bool hasInternet = true;
  try {
    final session = await Amplify.Auth.fetchAuthSession();
    hasInternet = session.isSignedIn || true; // Solo verifica si responde sin lanzar excepción
  } catch (e) {
    hasInternet = false;
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => UserViewModel()),
        ChangeNotifierProvider(create: (_) => BooksViewModel()),
        ChangeNotifierProvider(create: (_) => UserLibraryViewModel()),
      ],
      child: MyApp(showNoInternetToast: !hasInternet),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool showNoInternetToast;
  const MyApp({super.key, required this.showNoInternetToast});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter AWS Amplify Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Builder(
        builder: (context) {
          if (showNoInternetToast) {
            Future.delayed(Duration.zero, () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('❌ Verifica tu conexión a internet.'),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            });
          }
          return SplashView();
        },
      ),
    );
  }
}
