import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import '../models/Book.dart';

class BooksViewModel extends ChangeNotifier {
  List<Book> _books = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Book> get books => _books;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchBooks() async {
    _setLoading(true);

    try {
      final books = await Amplify.DataStore.query(Book.classType);
      _books = books;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Error fetching books: $e';
      _books = [];
    } finally {
      _setLoading(false);
    }
  }

  List<Book> searchBooks(String query) {
    final normalizedQuery = query.trim().toLowerCase();

    return _books.where((book) {
      final title = book.title.toLowerCase();
      final authorName = (book.author?.name ?? '').toLowerCase();
      return title.contains(normalizedQuery) || authorName.contains(normalizedQuery);
    }).toList();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
