import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_api/amplify_api.dart';
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

      final authUser = await Amplify.Auth.getCurrentUser();
      final request = ModelQueries.list(
        UserLibrary.classType,
        where: UserLibrary.USER.eq(authUser.userId),
      );

      final response = await Amplify.API.query(request: request).response;
      final libraries = response.data?.items.whereType<UserLibrary>().toList() ?? [];

      if (libraries.isEmpty) {
        userBooks = [];
      } else {
        userBooks = libraries
            .expand((lib) => lib.books ?? [])
            .map((entry) => entry.book)
            .whereType<Book>()
            .toList();
      }
    } catch (e) {
      errorMessage = "Failed to load your library.";
      debugPrint("❌ Error in UserLibraryViewModel: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
