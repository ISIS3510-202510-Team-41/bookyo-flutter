import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth_vm.dart';
import 'verify_email_view.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    nameController.dispose();
    lastnameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return "Email is required";
    final emailRegex = RegExp(r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$");
    if (!emailRegex.hasMatch(value)) return "Invalid email address";
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return "Password is required";
    if (value.length < 8) return "Password must be at least 8 characters";
    if (!RegExp(r'[A-Z]').hasMatch(value)) return "Must contain at least one uppercase letter";
    if (!RegExp(r'[a-z]').hasMatch(value)) return "Must contain at least one lowercase letter";
    if (!RegExp(r'[0-9]').hasMatch(value)) return "Must contain at least one number";
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) return "Must contain at least one symbol";
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) return "Please confirm your password";
    if (value != passwordController.text) return "Passwords do not match";
    return null;
  }

  void _showToast(BuildContext context, String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white, fontFamily: 'Parkinsans')),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _handleRegister(AuthViewModel authViewModel) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    final result = await authViewModel.register(
      emailController.text.trim(),
      passwordController.text.trim(),
    );

    if (result.success) {
      if (result.needsConfirmation) {
        _showToast(context, "✅ Registration successful. Check your email to verify your account.");

        await Future.delayed(const Duration(seconds: 2));

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => VerifyEmailView(
              email: emailController.text.trim(),
              password: passwordController.text.trim(),
              firstName: nameController.text.trim(),
              lastName: lastnameController.text.trim(),
              phone: phoneController.text.trim(),
              address: addressController.text.trim(),
            ),
          ),
        );
      } else {
        _showToast(context, "✅ Account created and verified. You can now sign in.");
        await Future.delayed(const Duration(seconds: 2));
        Navigator.pop(context);
      }
    } else {
      _showToast(context, "❌ Registration failed. Please try again.", isError: true);
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/BOOKYO_LOGO.png',
                    height: 160,
                    errorBuilder: (context, error, stackTrace) {
                      return const Text("Error loading logo", style: TextStyle(color: Colors.red));
                    },
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Welcome to Bookyo!",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, fontFamily: 'Parkinsans'),
                  ),
                  const SizedBox(height: 20),

                  _buildTextField(controller: nameController, label: "First Name", icon: Icons.person, validator: (v) => v == null || v.isEmpty ? "First name is required" : null),
                  _buildTextField(controller: lastnameController, label: "Last Name", icon: Icons.person_outline, validator: (v) => v == null || v.isEmpty ? "Last name is required" : null),
                  _buildTextField(controller: emailController, label: "Email", icon: Icons.email, keyboardType: TextInputType.emailAddress, validator: _validateEmail),
                  _buildTextField(controller: phoneController, label: "Phone Number", icon: Icons.phone, keyboardType: TextInputType.phone, validator: (v) => v == null || v.isEmpty ? "Phone number is required" : null),
                  _buildTextField(controller: addressController, label: "Address", icon: Icons.home, validator: (v) => v == null || v.isEmpty ? "Address is required" : null),
                  _buildPasswordField(controller: passwordController, label: "Password", validator: _validatePassword),
                  _buildPasswordField(controller: confirmPasswordController, label: "Confirm Password", validator: _validateConfirmPassword),

                  const SizedBox(height: 20),

                  isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: () => _handleRegister(authViewModel),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            backgroundColor: const Color(0xFFB6EB7A),
                            fixedSize: Size(MediaQuery.of(context).size.width / 2, 50),
                          ),
                          child: const Text(
                            "Register",
                            style: TextStyle(fontSize: 18, color: Colors.black, fontFamily: 'Parkinsans'),
                          ),
                        ),
                  const SizedBox(height: 5),

                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(foregroundColor: const Color.fromARGB(255, 16, 134, 55)),
                    child: const Text(
                      "Already have an account? Sign in",
                      style: TextStyle(fontSize: 16, fontFamily: 'Parkinsans'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.black54, fontFamily: 'Parkinsans'),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
          prefixIcon: Icon(icon),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        keyboardType: keyboardType,
        validator: validator,
        style: const TextStyle(fontFamily: 'Parkinsans'),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required String? Function(String?) validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.black54, fontFamily: 'Parkinsans'),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
          prefixIcon: const Icon(Icons.lock),
          suffixIcon: IconButton(
            icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        obscureText: _obscurePassword,
        validator: validator,
        style: const TextStyle(fontFamily: 'Parkinsans'),
      ),
    );
  }
}
