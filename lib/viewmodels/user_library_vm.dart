import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import '../models/ModelProvider.dart';

class UserLibraryViewModel extends ChangeNotifier {
  // Estado
  bool _isLoading = false;
  String? _errorMessage;
  List<Listing> _userListings = [];

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Listing> get userListings => _userListings;

  // Método principal: obtener listings del usuario autenticado
  Future<void> loadUserListings() async {
    _setLoading(true);
    try {
      // Obtener email autenticado
      final attributes = await Amplify.Auth.fetchUserAttributes();
      final email = attributes
          .firstWhere((a) => a.userAttributeKey.key == 'email')
          .value;
      debugPrint("📧 Email autenticado: $email");

      // Cargar todos los listings
      final allListings = await Amplify.DataStore.query(Listing.classType);

      // Filtrar por user.email localmente
      _userListings = allListings.where((listing) {
        final user = listing.user;
        return user != null && user.email == email;
      }).toList();

      _errorMessage = null;
      debugPrint("📦 Listings filtrados por email: ${_userListings.length}");
    } catch (e, st) {
      _errorMessage = "Failed to load your listings.";
      _userListings = [];
      debugPrint("❌ Error en loadUserListings: $e");
      debugPrint("📄 Stacktrace:\n$st");
    } finally {
      _setLoading(false);
    }
  }

  // Control interno de carga
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
