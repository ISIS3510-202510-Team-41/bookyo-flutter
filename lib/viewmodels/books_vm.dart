import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import '../models/Book.dart';
import '../models/Listing.dart';
import '../models/User.dart';
import '../models/UserLibrary.dart';
import '../models/BookLibrary.dart';

class BooksViewModel extends ChangeNotifier {
  /// Lista completa de libros (todos los registrados en el DataStore)
  List<Book> _allBooks = [];

  /// Lista de publicaciones visibles en el marketplace (Listings)
  List<Listing> _publishedListings = [];

  /// Lista de libros asociados al usuario actual (UserLibrary → BookLibrary)
  List<Book> _userLibraryBooks = [];

  /// Estado de carga
  bool _isLoading = false;

  /// Mensaje de error si ocurre algo durante el fetch
  String? _errorMessage;

  // Getters públicos para UI
  List<Book> get allBooks => _allBooks;
  List<Listing> get publishedListings => _publishedListings;
  List<Book> get userLibraryBooks => _userLibraryBooks;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// 🔍 Fetch de TODOS los libros registrados (sin filtrar)
  /// Usado en pruebas o vistas de administración
  Future<void> fetchBooks() async {
    _setLoading(true);

    try {
      final books = await Amplify.DataStore.query(Book.classType);
      _allBooks = books;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Error fetching books: $e';
      _allBooks = [];
    } finally {
      _setLoading(false);
    }
  }

  /// 🛍️ Fetch de libros publicados (listados en el marketplace)
  /// Se basa en el modelo Listing, que enlaza con Book
  Future<void> fetchPublishedListings() async {
    _setLoading(true);

    try {
      final listings = await Amplify.DataStore.query(Listing.classType);
      _publishedListings = listings;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Error fetching published listings: $e';
      _publishedListings = [];
    } finally {
      _setLoading(false);
    }
  }

  /// 👤 Fetch de libros publicados o guardados por el usuario actual
  /// Se obtiene desde UserLibrary → BookLibrary → Book
  Future<void> fetchUserLibraryBooks() async {
    _setLoading(true);

    try {
      final currentUser = await Amplify.Auth.getCurrentUser();

      final users = await Amplify.DataStore.query(
        User.classType,
        where: User.EMAIL.eq(currentUser.username),
      );
      final user = users.first;

      final libraries = await Amplify.DataStore.query(
        UserLibrary.classType,
        where: UserLibrary.USER.eq(user),
      );

      if (libraries.isNotEmpty) {
        final library = libraries.first;

        final bookEntries = await Amplify.DataStore.query(
          BookLibrary.classType,
          where: BookLibrary.USERLIBRARYREF.eq(library),
        );

        _userLibraryBooks = bookEntries
            .where((entry) => entry.book != null)
            .map((entry) => entry.book!)
            .toList();
      } else {
        _userLibraryBooks = [];
      }

      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Error fetching user library books: $e';
      _userLibraryBooks = [];
    } finally {
      _setLoading(false);
    }
  }

    /// 📚 Fetch de listings publicados por el usuario autenticado
  Future<void> fetchUserListings() async {
    _setLoading(true);

    try {
      final attributes = await Amplify.Auth.fetchUserAttributes();
      final email = attributes
          .firstWhere((a) => a.userAttributeKey.key == 'email')
          .value;
      debugPrint("📧 Email autenticado: $email");

      final listings = await Amplify.DataStore.query(Listing.classType);

      _publishedListings = listings.where((listing) {
        final user = listing.user;
        return user != null && user.email == email;
      }).toList();

      _errorMessage = null;
      debugPrint("✅ Listings del usuario cargados: ${_publishedListings.length}");
    } catch (e) {
      _errorMessage = 'Error fetching user listings: $e';
      _publishedListings = [];
    } finally {
      _setLoading(false);
    }
  }

  /// 🔎 Búsqueda en la lista completa de libros registrados
  List<Book> searchBooks(String query) {
    final normalizedQuery = query.trim().toLowerCase();

    return _allBooks.where((book) {
      final title = book.title.toLowerCase();
      final authorName = (book.author?.name ?? '').toLowerCase();
      return title.contains(normalizedQuery) || authorName.contains(normalizedQuery);
    }).toList();
  }

  /// 🔄 Control interno de estado de carga y notificación
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
