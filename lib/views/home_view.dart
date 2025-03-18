import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_vm.dart';
import 'login_view.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Inicio"),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () async {
              await authViewModel.logout();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginView()));
            },
          ),
        ],
      ),
      body: Center(
        child: Text("Bienvenido, ${authViewModel.user?.email ?? 'Usuario'}!", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
