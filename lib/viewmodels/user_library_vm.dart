import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import '../models/ModelProvider.dart';

class UserLibraryViewModel extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;
  List<Book> userBooks = [];

  Future<void> loadUserLibrary() async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final attributes = await Amplify.Auth.fetchUserAttributes();
      final email = attributes.firstWhere((a) => a.userAttributeKey.key == 'email').value;
      debugPrint("📧 Email del usuario autenticado: $email");

      // Buscar al User por email (clave primaria)
      final users = await Amplify.DataStore.query(
        User.classType,
        where: User.EMAIL.eq(email),
      );

      if (users.isEmpty) {
        debugPrint("🚫 No se encontró ningún User con ese email");
        userBooks = [];
        return;
      }

      final currentUser = users.first;

      final userLibraries = await Amplify.DataStore.query(
        UserLibrary.classType,
        where: UserLibrary.USER.eq(currentUser),
      );

      if (userLibraries.isEmpty) {
        debugPrint("📭 No se encontró UserLibrary para el usuario: ${currentUser.email}");
        userBooks = [];
      } else {
        final lib = userLibraries.first;
        final bookLibraries = lib.books ?? [];
        debugPrint("📚 Biblioteca encontrada: ${lib.id}, con ${bookLibraries.length} BookLibrary");

        userBooks = bookLibraries
            .map((entry) => entry.book)
            .whereType<Book>()
            .toList();

        debugPrint("✅ Libros cargados en userBooks: ${userBooks.length}");
      }
    } catch (e, st) {
      errorMessage = "Failed to load your library.";
      debugPrint("❌ Error en loadUserLibrary(): $e");
      debugPrint("📄 Stacktrace: $st");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
