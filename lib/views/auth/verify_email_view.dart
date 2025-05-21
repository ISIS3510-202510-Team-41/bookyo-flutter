import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth_vm.dart';
import 'login_view.dart';
import '../home_view.dart'; // ✅ Importa tu HomeView para navegar luego
import '../../services/connectivity_service.dart';
import 'dart:async';

class VerifyEmailView extends StatefulWidget {
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String phone;
  final String address;

  VerifyEmailView({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.address,
  });

  @override
  _VerifyEmailViewState createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController codeController = TextEditingController();
  bool isLoading = false;
  Timer? _debounce;

  @override
  void dispose() {
    codeController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onCodeChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      setState(() {});
    });
  }

  /// 🔹 Show Toast message
  void _showToast(BuildContext context, String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 3),
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
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 📝 Title
                  const Text(
                    "Verify Email",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Enter the verification code sent to:",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    widget.email,
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),

                  // 🔢 Verification Code Field
                  TextFormField(
                    controller: codeController,
                    onChanged: _onCodeChanged,
                    decoration: InputDecoration(
                      labelText: "Verification Code",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                      prefixIcon: const Icon(Icons.verified),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) return "The code is required";
                      if (value.length != 6) return "Must be a 6-digit code";
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),

                  // 🟢 Verify Button
                  isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              if (!await ConnectivityService.hasInternet()) {
                                _showToast(context, "No internet connection. Please try again.", isError: true);
                                return;
                              }
                              setState(() => isLoading = true);

                              final verifyResult = await authViewModel.verifyEmailWithResult(widget.email, codeController.text);

                              if (verifyResult.success) {
                                final loggedIn = await authViewModel.login(widget.email, widget.password);

                                if (loggedIn.success) {
                                  // Create the full profile
                                  bool profileCreated = await authViewModel.createUserProfile(
                                    firstName: widget.firstName,
                                    lastName: widget.lastName,
                                    phone: widget.phone,
                                    address: widget.address,
                                  );

                                  setState(() => isLoading = false);

                                  if (profileCreated) {
                                    _showToast(context, "✅ Account verified and profile created successfully.");
                                    Future.delayed(const Duration(seconds: 2), () {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(builder: (_) => HomeView()),
                                      );
                                    });
                                  } else {
                                    _showToast(context, "⚠️ Account verified but failed to create profile.", isError: true);
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (_) => HomeView()),
                                    );
                                  }
                                } else {
                                  setState(() => isLoading = false);
                                  if (verifyResult.errorType == 'network') {
                                    _showToast(context, "❌ No internet connection. Please try again.", isError: true);
                                  } else {
                                    _showToast(context, "❌ Incorrect or expired verification code.", isError: true);
                                  }
                                }
                              } else {
                                setState(() => isLoading = false);
                                if (verifyResult.errorType == 'network') {
                                  _showToast(context, "❌ No internet connection. Please try again.", isError: true);
                                } else {
                                  _showToast(context, "❌ Incorrect or expired verification code.", isError: true);
                                }
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFB6EB7A),
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text(
                            "Verify",
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                        ),
                  const SizedBox(height: 20),

                  // 🔄 Resend Code
                  TextButton(
                    onPressed: () async {
                      setState(() => isLoading = true);
                      bool resent = await authViewModel.resendVerificationCode(widget.email);
                      setState(() => isLoading = false);

                      if (resent) {
                        _showToast(context, "Code resent to your email.");
                      } else {
                        _showToast(context, "Failed to resend the code.", isError: true);
                      }
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.green[800],
                    ),
                    child: const Text("Didn't receive the code? Resend"),
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
