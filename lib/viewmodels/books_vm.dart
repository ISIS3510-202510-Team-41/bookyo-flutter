import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import '../models/Book.dart';
import '../models/Listing.dart';
import '../models/User.dart';
import '../models/UserLibrary.dart';
import '../models/BookLibrary.dart';

class BooksViewModel extends ChangeNotifier {
  // 📚 Estado
  List<Book> _allBooks = [];
  List<Listing> _publishedListings = [];     // Todos los listings públicos
  List<Listing> _userListings = [];          // Solo los listings del usuario actual
  List<Book> _userLibraryBooks = [];

  bool _isLoading = false;
  String? _errorMessage;

  // 📤 Getters públicos
  List<Book> get allBooks => _allBooks;
  List<Listing> get publishedListings => _publishedListings;
  List<Listing> get userListings => _userListings;
  List<Book> get userLibraryBooks => _userLibraryBooks;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// 🔍 Fetch de todos los libros del DataStore
  Future<void> fetchBooks() async {
    _setLoading(true);
    try {
      _allBooks = await Amplify.DataStore.query(Book.classType);
      _errorMessage = null;
    } catch (e) {
      _allBooks = [];
      _errorMessage = 'Error fetching books: $e';
    } finally {
      _setLoading(false);
    }
  }

  /// 🛍️ Fetch de todos los listings públicos
  Future<void> fetchPublishedListings() async {
    _setLoading(true);
    try {
      _publishedListings = await Amplify.DataStore.query(Listing.classType);
      _errorMessage = null;
    } catch (e) {
      _publishedListings = [];
      _errorMessage = 'Error fetching published listings: $e';
    } finally {
      _setLoading(false);
    }
  }

  /// 👤 Fetch de listings publicados por el usuario autenticado
  Future<void> fetchUserListings() async {
    _setLoading(true);
    try {
      final attributes = await Amplify.Auth.fetchUserAttributes();
      final email = attributes
          .firstWhere((a) => a.userAttributeKey.key == 'email')
          .value;

      final listings = await Amplify.DataStore.query(Listing.classType);
      _userListings = listings.where((listing) {
        final user = listing.user;
        return user != null && user.email == email;
      }).toList();

      _errorMessage = null;
      debugPrint("✅ Listings del usuario cargados: ${_userListings.length}");
    } catch (e) {
      _userListings = [];
      _errorMessage = 'Error fetching user listings: $e';
    } finally {
      _setLoading(false);
    }
  }

  /// 📚 Fetch de libros guardados en la UserLibrary
  Future<void> fetchUserLibraryBooks() async {
    _setLoading(true);
    try {
      final currentUser = await Amplify.Auth.getCurrentUser();
      final users = await Amplify.DataStore.query(
        User.classType,
        where: User.EMAIL.eq(currentUser.username),
      );

      if (users.isEmpty) {
        _userLibraryBooks = [];
        return;
      }

      final user = users.first;
      final libraries = await Amplify.DataStore.query(
        UserLibrary.classType,
        where: UserLibrary.USER.eq(user),
      );

      if (libraries.isEmpty) {
        _userLibraryBooks = [];
        return;
      }

      final library = libraries.first;
      final bookEntries = await Amplify.DataStore.query(
        BookLibrary.classType,
        where: BookLibrary.USERLIBRARYREF.eq(library),
      );

      _userLibraryBooks = bookEntries
          .where((entry) => entry.book != null)
          .map((entry) => entry.book!)
          .toList();

      _errorMessage = null;
    } catch (e) {
      _userLibraryBooks = [];
      _errorMessage = 'Error fetching user library books: $e';
    } finally {
      _setLoading(false);
    }
  }

  /// 🔎 Buscar en todos los libros por título o autor
  List<Book> searchBooks(String query) {
    final normalized = query.trim().toLowerCase();
    return _allBooks.where((book) {
      final title = book.title.toLowerCase();
      final author = (book.author?.name ?? '').toLowerCase();
      return title.contains(normalized) || author.contains(normalized);
    }).toList();
  }

  /// 🔄 Control interno de carga
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
