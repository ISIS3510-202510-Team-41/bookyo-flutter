import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:hive/hive.dart';
import '../models/Book.dart';
import '../models/Listing.dart';
import '../models/User.dart';
import '../models/UserLibrary.dart';
import '../models/BookLibrary.dart';
import '../models/cached_image.dart';

class BooksViewModel extends ChangeNotifier {
  List<Book> _allBooks = [];
  List<Listing> _publishedListings = [];
  List<Listing> _userListings = [];
  List<Book> _userLibraryBooks = [];
  List<BookWithImage> _booksWithImages = [];

  bool _isLoading = false;
  String? _errorMessage;

  List<Book> get allBooks => _allBooks;
  List<Listing> get publishedListings => _publishedListings;
  List<Listing> get userListings => _userListings;
  List<Book> get userLibraryBooks => _userLibraryBooks;
  List<BookWithImage> get booksWithImages => _booksWithImages;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// 🔍 Cargar libros y sus imágenes desde S3 o Hive (caché)
  Future<void> fetchBooks() async {
    _setLoading(true);
    try {
      _allBooks = await Amplify.DataStore.query(Book.classType);

      _booksWithImages = await Future.wait(_allBooks.map((book) async {
        Uri? imageUrl;

        if (book.thumbnail != null) {
          try {
            // Primero intentar desde S3
            final result = await Amplify.Storage.getUrl(
              path: StoragePath.fromString(book.thumbnail!),
            ).result;
            imageUrl = result.url;
          } catch (e) {
            // Si falla, intentar desde Hive (modo offline)
            debugPrint("⚠️ Error al cargar desde S3, intentando Hive: ${book.thumbnail}");
            final cacheBox = await Hive.openBox<CachedImage>('cached_images');
            final cached = cacheBox.get(book.thumbnail!);
            if (cached != null) {
              imageUrl = Uri.dataFromBytes(cached.bytes, mimeType: 'image/jpeg');
              debugPrint("📦 Imagen cargada desde caché local");
            } else {
              debugPrint("❌ Imagen no encontrada en Hive: ${book.thumbnail}");
            }
          }
        }

        return BookWithImage(book: book, imageUrl: imageUrl);
      }).toList());

      _errorMessage = null;
    } catch (e) {
      _allBooks = [];
      _booksWithImages = [];
      _errorMessage = 'Error fetching books: $e';
    } finally {
      _setLoading(false);
    }
  }

  /// 🛍️ Cargar todos los listings públicos
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

  /// 👤 Cargar listings del usuario autenticado
  Future<void> fetchUserListings() async {
    _setLoading(true);
    try {
      final attributes = await Amplify.Auth.fetchUserAttributes();
      final email = attributes.firstWhere((a) => a.userAttributeKey.key == 'email').value;

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

  /// 📚 Cargar libros guardados por el usuario
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

  /// 🗑️ Eliminar listing
  Future<void> deleteListing(Listing listing) async {
    _setLoading(true);
    try {
      await Amplify.DataStore.delete(listing);
      _userListings.removeWhere((l) => l.id == listing.id);
      _publishedListings.removeWhere((l) => l.id == listing.id);
      notifyListeners();
      debugPrint("🗑️ Listing eliminado: ${listing.id}");
    } catch (e) {
      _errorMessage = 'Error deleting listing: $e';
      debugPrint("❌ Error deleting listing: $e");
    } finally {
      _setLoading(false);
    }
  }

  /// 🔎 Buscar libros por título o autor
  List<Book> searchBooks(String query) {
    final normalized = query.trim().toLowerCase();
    return _allBooks.where((book) {
      final title = book.title.toLowerCase();
      final author = (book.author?.name ?? '').toLowerCase();
      return title.contains(normalized) || author.contains(normalized);
    }).toList();
  }

  /// 🔄 Estado de carga
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}

/// 📘 Clase auxiliar para manejar libros con imagen
class BookWithImage {
  final Book book;
  final Uri? imageUrl;

  BookWithImage({required this.book, required this.imageUrl});
}
