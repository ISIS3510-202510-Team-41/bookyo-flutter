import 'package:shared_preferences/shared_preferences.dart';

class PublishLocalStorageService {
  static Future<void> saveDraft({
    required String isbn,
    required String title,
    required String author,
    required String price,
    required String? imagePath,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('isbn', isbn);
    await prefs.setString('title', title);
    await prefs.setString('author', author);
    await prefs.setString('price', price);
    if (imagePath != null) {
      await prefs.setString('imagePath', imagePath);
    }
  }

  static Future<Map<String, String?>> loadDraft() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'isbn': prefs.getString('isbn'),
      'title': prefs.getString('title'),
      'author': prefs.getString('author'),
      'price': prefs.getString('price'),
      'imagePath': prefs.getString('imagePath'),
    };
  }

  static Future<void> clearDraft() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isbn');
    await prefs.remove('title');
    await prefs.remove('author');
    await prefs.remove('price');
    await prefs.remove('imagePath');
  }
}
