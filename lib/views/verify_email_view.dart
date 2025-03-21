import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_vm.dart';
import 'login_view.dart';

class VerifyEmailView extends StatefulWidget {
  final String email; // ✅ User's registered email

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

  /// 🔹 Show Toast message
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
                  // 📝 Title
                  Text(
                    "Verify Email",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Enter the verification code sent to:",
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 5),
                  Text(
                    widget.email, // ✅ Display registered email
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 30),

                  // 🔢 Verification Code Field
                  TextFormField(
                    controller: codeController,
                    decoration: InputDecoration(
                      labelText: "Verification Code",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                      prefixIcon: Icon(Icons.verified),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) return "The code is required";
                      if (value.length != 6) return "Must be a 6-digit code";
                      return null;
                    },
                  ),
                  SizedBox(height: 30),

                  // 🟢 Verify Button
                  isLoading
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() => isLoading = true);
                              bool success = await authViewModel.verifyEmail(widget.email, codeController.text);
                              setState(() => isLoading = false);

                              if (success) {
                                _showToast(context, "Account successfully verified.");
                                Future.delayed(Duration(seconds: 2), () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (_) => LoginView()),
                                  );
                                });
                              } else {
                                _showToast(context, "Incorrect or expired code.", isError: true);
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFB6EB7A), // Added color
                            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text("Verify", style: TextStyle(fontSize: 18, color: Colors.black)),
                        ),
                  SizedBox(height: 20),

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
                      foregroundColor: Colors.green[800], // Dark green color
                    ),
                    child: Text("Didn't receive the code? Resend"),
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
