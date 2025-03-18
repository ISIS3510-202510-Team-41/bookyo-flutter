import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_vm.dart';
import 'home_view.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose(); // Liberar memoria
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Iniciar Sesión")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: emailController, decoration: const InputDecoration(labelText: "Email")),
            TextField(controller: passwordController, decoration: const InputDecoration(labelText: "Contraseña"), obscureText: true),
            const SizedBox(height: 20),
            authViewModel.isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () async {
                      bool success = await authViewModel.login(
                        emailController.text,
                        passwordController.text,
                      );
                      if (success) {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeView()));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error al iniciar sesión")));
                      }
                    },
                    child: Text("Ingresar"),
                  ),
          ],
        ),
      ),
    );
  }
}
