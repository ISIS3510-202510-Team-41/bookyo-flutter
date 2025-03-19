import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_vm.dart';
import 'verify_email_view.dart'; // ✅ Nueva pantalla de verificación

class RegisterView extends StatefulWidget {
  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  /// 🔹 Validar email
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return "El correo es obligatorio";
    final emailRegex = RegExp(r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$");
    if (!emailRegex.hasMatch(value)) return "Correo electrónico no válido";
    return null;
  }

  /// 🔹 Validar contraseña según AWS Cognito
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return "La contraseña es obligatoria";
    if (value.length < 8) return "Debe tener al menos 8 caracteres";
    if (!RegExp(r'[A-Z]').hasMatch(value)) return "Debe contener al menos una mayúscula";
    if (!RegExp(r'[a-z]').hasMatch(value)) return "Debe contener al menos una minúscula";
    if (!RegExp(r'[0-9]').hasMatch(value)) return "Debe contener al menos un número";
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) return "Debe contener al menos un símbolo";
    return null;
  }

  /// 🔹 Mostrar mensaje Toast
  void _showToast(BuildContext context, String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(color: Colors.white)),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: Duration(seconds: 3),
      ),
    );
  }

  /// 🔹 Manejar el Registro
  Future<void> _handleRegister(AuthViewModel authViewModel) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    await authViewModel.register(emailController.text, passwordController.text);

    // ✅ Enviar Toast de éxito directamente sin manejar error
    _showToast(context, "✅ Registro exitoso. Revisa tu correo para verificar tu cuenta.");

    // 🔹 Redirigir a la pantalla de verificación del email después de 2 segundos
    await Future.delayed(Duration(seconds: 2));

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => VerifyEmailView(email: emailController.text),
      ),
    );

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 📝 Título
                  Text(
                    "Crear Cuenta",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 30),

                  // 📧 Campo de Email
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: "Correo Electrónico",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      prefixIcon: Icon(Icons.email),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: _validateEmail,
                  ),
                  SizedBox(height: 16),

                  // 🔒 Campo de Contraseña
                  TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: "Contraseña",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                        onPressed: () {
                          setState(() => _obscurePassword = !_obscurePassword);
                        },
                      ),
                    ),
                    obscureText: _obscurePassword,
                    validator: _validatePassword,
                  ),
                  SizedBox(height: 30),

                  // 🟢 Botón de Registro
                  isLoading
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: () => _handleRegister(authViewModel),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text("Registrarse", style: TextStyle(fontSize: 18)),
                        ),
                  SizedBox(height: 20),

                  // 🔄 Volver al Login
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("¿Ya tienes una cuenta? Inicia sesión"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
