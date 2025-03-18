import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_vm.dart';
import 'login_view.dart';

class UserProfileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: Text("User Profile")),
      body: Center(
        child: Column(
          children: [
            CircleAvatar(radius: 50, backgroundColor: Colors.grey[300]),
            SizedBox(height: 20),
            Text("Usuario: ${authViewModel.user?.email ?? 'No disponible'}"),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await authViewModel.logout();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginView()));
              },
              child: Text("Logout"),
            ),
          ],
        ),
      ),
    );
  }
}
