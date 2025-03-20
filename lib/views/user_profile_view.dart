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
          mainAxisAlignment: MainAxisAlignment.center,
            children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: authViewModel.user?.photoUrl != null
                ? NetworkImage(authViewModel.user!.photoUrl!)
                : null,
              backgroundColor: Colors.grey[300],
              child: authViewModel.user?.photoUrl == null
                ? Icon(Icons.person, size: 50, color: Colors.white)
                : null,
            ),
            SizedBox(height: 20),
            Text(
              "Nombre: ${authViewModel.user?.displayName ?? 'No disponible'}",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              "Email: ${authViewModel.user?.email ?? 'No disponible'}",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
              await authViewModel.logout();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginView()));
              },
              style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              backgroundColor: Color(0xFFB6EB7A),
              fixedSize: Size(MediaQuery.of(context).size.width / 2, 50),
              ),
              child: Text(
              "Logout",
              style: TextStyle(fontSize: 18, color: Colors.black, fontFamily: 'Parkinsans'),
              ),
            ),
            SizedBox(height: 20),
            ],
        ),
      ),
    );
  }
}
