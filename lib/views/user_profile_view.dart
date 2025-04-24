import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../viewmodels/auth_vm.dart';
import 'auth/login_view.dart';

class UserProfileView extends StatefulWidget {
  @override
  _UserProfileViewState createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileView> {
  bool isLoading = true;

  String _cachedName = '';
  String _cachedEmail = '';
  String _cachedPhone = '';
  String _cachedAddress = '';

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final prefs = await SharedPreferences.getInstance();

    // 🧠 Cargar datos locales desde SharedPreferences
    setState(() {
      _cachedName =
          '${prefs.getString('firstName') ?? ''} ${prefs.getString('lastName') ?? ''}';
      _cachedEmail = prefs.getString('email') ?? '';
      _cachedPhone = prefs.getString('phone') ?? 'No phone registered';
      _cachedAddress = prefs.getString('address') ?? 'No address registered';
    });

    // 🔄 Luego intenta obtener los datos reales desde backend
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    await authViewModel.fetchUserProfile();

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final userProfile = authViewModel.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            if (isLoading)
              Column(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey[300],
                    child: const Icon(Icons.person, size: 60, color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _cachedName,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _cachedEmail,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 30),
                  _buildInfoTile(Icons.phone, "Phone", _cachedPhone),
                  const SizedBox(height: 10),
                  _buildInfoTile(Icons.home, "Address", _cachedAddress),
                  const SizedBox(height: 30),
                ],
              )
            else if (userProfile == null)
              const Text(
                "No user information available.",
                style: TextStyle(fontSize: 18),
              )
            else
              Column(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey[300],
                    child: const Icon(Icons.person, size: 60, color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "${userProfile.firstName ?? ''} ${userProfile.lastName ?? ''}",
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    userProfile.email,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 30),
                  _buildInfoTile(Icons.phone, "Phone", userProfile.phone ?? "No phone registered"),
                  const SizedBox(height: 10),
                  _buildInfoTile(Icons.home, "Address", userProfile.address ?? "No address registered"),
                  const SizedBox(height: 30),
                ],
              ),
            // 🔥 Logout button SIEMPRE disponible
            ElevatedButton.icon(
              onPressed: () async {
                await authViewModel.logout();
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => LoginView()));
              },
              icon: const Icon(Icons.logout, color: Colors.black),
              label: const Text(
                "Logout",
                style: TextStyle(fontSize: 18, color: Colors.black, fontFamily: 'Parkinsans'),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB6EB7A),
                fixedSize: Size(MediaQuery.of(context).size.width / 2, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String title, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 14, color: Colors.black54)),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
