import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_vm.dart';
import 'login_view.dart';

class VerifyEmailView extends StatefulWidget {
  final String email; // ✅ Se pasa el email del usuario registrado

  VerifyEmailView({required this.email});

  @override
  _VerifyEmailViewState createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController codeController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    codeController.dispose();
    super.dispose();
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
                    "Verificar Correo",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Introduce el código de verificación enviado a:",
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 5),
                  Text(
                    widget.email, // ✅ Muestra el email registrado
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 30),

                  // 🔢 Campo de Código de Verificación
                  TextFormField(
                    controller: codeController,
                    decoration: InputDecoration(
                      labelText: "Código de Verificación",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                      prefixIcon: Icon(Icons.verified),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) return "El código es obligatorio";
                      if (value.length != 6) return "Debe ser un código de 6 dígitos";
                      return null;
                    },
                  ),
                  SizedBox(height: 30),

                  // 🟢 Botón de Verificar
                    isLoading
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                        onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() => isLoading = true);
                          bool success = await authViewModel.verifyEmail(widget.email, codeController.text);
                          setState(() => isLoading = false);

                          if (success) {
                          _showToast(context, "Cuenta verificada con éxito.");
                          Future.delayed(Duration(seconds: 2), () {
                            Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => LoginView()),
                            );
                          });
                          } else {
                          _showToast(context, "Código incorrecto o expirado.", isError: true);
                          }
                        }
                        },
                        style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFB6EB7A), // Added color
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text("Verificar", style: TextStyle(fontSize: 18)),
                      ),
                    SizedBox(height: 20),

                  // 🔄 Reenviar Código
                  TextButton(
                    onPressed: () async {
                      setState(() => isLoading = true);
                      bool resent = await authViewModel.resendVerificationCode(widget.email);
                      setState(() => isLoading = false);

                      if (resent) {
                        _showToast(context, "Código reenviado a tu correo.");
                      } else {
                        _showToast(context, "No se pudo reenviar el código.", isError: true);
                      }
                    },
                    child: Text("¿No recibiste el código? Reenviar"),
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
