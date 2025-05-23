import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:hive/hive.dart';
import '../models/Book.dart';
import '../models/Listing.dart';
import '../models/User.dart';
import '../models/UserLibrary.dart';
import '../models/BookLibrary.dart';
import '../models/cached_image.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'dart:isolate';
import 'package:flutter/services.dart';
import '../services/database_helper.dart';
import 'dart:async';
import 'package:flutter/widgets.dart';
import '../services/connectivity_service.dart';

class BooksViewModel extends ChangeNotifier with WidgetsBindingObserver {
  List<Book> _allBooks = [];
  List<Listing> _publishedListings = [];
  List<Listing> _userListings = [];
  List<Book> _userLibraryBooks = [];
  List<BookWithImage> _booksWithImages = [];
  List<ListingWithImage> _publishedListingsWithImages = [];
  List<ListingWithImage> _userListingsWithImages = [];

  bool _isLoading = false;
  String? _errorMessage;

  Timer? _syncTimer;

  List<Book> get allBooks => _allBooks;
  List<Listing> get publishedListings => _publishedListings;
  List<Listing> get userListings => _userListings;
  List<Book> get userLibraryBooks => _userLibraryBooks;
  List<BookWithImage> get booksWithImages => _booksWithImages;
  List<ListingWithImage> get publishedListingsWithImages => _publishedListingsWithImages;
  List<ListingWithImage> get userListingsWithImages => _userListingsWithImages;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// 🔍 Cargar libros y sus imágenes desde S3 o Hive (caché)
  Future<void> fetchBooks() async {
    _setLoading(true);
    // 1. Intenta cargar desde SQLite primero (si tienes persistencia local para books)
    // ... (tu lógica aquí, si aplica) ...
    // 2. Verifica conectividad antes de llamar a la API
    final isOnline = await ConnectivityService.hasInternet();
    if (!isOnline) {
      if (_allBooks.isEmpty) {
        _errorMessage = 'No internet connection and no saved data available.';
        notifyListeners();
      }
      _setLoading(false);
      return;
    }
    // 3. Si hay conexión, sincroniza con la API
    try {
      final request = ModelQueries.list(Book.classType);
      final response = await Amplify.API.query(request: request).response;
      _allBooks = (response.data?.items ?? []).whereType<Book>().toList();
      _booksWithImages = await Future.wait(_allBooks.map((book) async {
        Uri? imageUrl;
        if (book.thumbnail != null) {
          try {
            final result = await Amplify.Storage.getUrl(
              path: StoragePath.fromString(book.thumbnail!),
            ).result;
            imageUrl = result.url;
          } catch (e) {
            // Si falla, intentar desde Hive (modo offline)
            debugPrint("⚠️ Error al cargar desde S3, intentando Hive: "+book.thumbnail!);
            final cacheBox = await Hive.openBox<CachedImage>('cached_images');
            final cached = cacheBox.get(book.thumbnail!);
            if (cached != null) {
              imageUrl = Uri.dataFromBytes(cached.bytes, mimeType: 'image/jpeg');
              debugPrint("📦 Imagen cargada desde caché local");
            } else {
              debugPrint("❌ Imagen no encontrada en Hive: "+book.thumbnail!);
            }
          }
        }
        return BookWithImage(book: book, imageUrl: imageUrl);
      }).toList());
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _allBooks = [];
      _booksWithImages = [];
      _errorMessage = 'Error fetching books: $e';
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  /// 🛍️ Cargar todos los listings públicos
  Future<void> fetchPublishedListings() async {
    _setLoading(true);
    // 1. Siempre intenta cargar desde SQLite primero
    final cachedListingsJson = await DatabaseHelper().getListings();
    if (cachedListingsJson.isNotEmpty) {
      final cachedListings = cachedListingsJson.map((item) => Listing.fromJson(item)).toList();
      _publishedListings = cachedListings;
      _publishedListingsWithImages = await Future.wait(_publishedListings.map((listing) async {
        final url = await _getListingImageUrl(listing);
        return ListingWithImage(listing: listing, imageUrl: url);
      }));
      notifyListeners();
    }
    // 2. Verifica conectividad antes de llamar a la API
    final isOnline = await ConnectivityService.hasInternet();
    if (!isOnline) {
      if (_publishedListings.isEmpty) {
        _errorMessage = 'No internet connection and no saved data available.';
        notifyListeners();
      }
      _setLoading(false);
      return;
    }
    // 3. Si hay conexión, sincroniza con la API
    try {
      const String listPublishedListingsQuery = '''
        query ListPublishedListings {
          listListings {
            items {
              id
              price
              status
              photos
              book {
                id
                title
                isbn
                thumbnail
                author {
                  id
                  name
                }
              }
              user {
                email
              }
            }
          }
        }
      ''';
      final request = GraphQLRequest<String>(document: listPublishedListingsQuery);
      final response = await Amplify.API.query(request: request).response;
      final data = response.data;
      if (data == null) throw Exception('No data from API');
      final decoded = jsonDecode(data) as Map<String, dynamic>;
      final items = decoded['listListings']['items'] as List<dynamic>;
      final listings = await parseListingsInIsolate(items);
      _publishedListings = listings;
      _publishedListingsWithImages = await Future.wait(_publishedListings.map((listing) async {
        final url = await _getListingImageUrl(listing);
        return ListingWithImage(listing: listing, imageUrl: url);
      }));
      // Guardar en caché local (SQLite)
      final itemsAsMap = items.map((e) => e as Map<String, dynamic>).toList();
      await DatabaseHelper().clearListings();
      await DatabaseHelper().insertListings(itemsAsMap);
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      if (_publishedListings.isEmpty) {
        _publishedListings = [];
        _publishedListingsWithImages = [];
        _errorMessage = 'Error fetching published listings: $e';
        notifyListeners();
      }
    } finally {
      _setLoading(false);
    }
  }

  /// 👤 Cargar listings del usuario autenticado usando GraphQL custom para traer autor anidado
  Future<void> fetchUserListings() async {
    _setLoading(true);
    // 1. Siempre intenta cargar desde SQLite primero
    // Si tienes una función similar a getUserListings en DatabaseHelper, úsala aquí
    // final cachedUserListingsJson = await DatabaseHelper().getUserListings();
    // if (cachedUserListingsJson.isNotEmpty) {
    //   final cachedUserListings = cachedUserListingsJson.map((item) => Listing.fromJson(item)).toList();
    //   _userListings = cachedUserListings;
    //   _userListingsWithImages = await Future.wait(_userListings.map((listing) async {
    //     final url = await _getListingImageUrl(listing);
    //     return ListingWithImage(listing: listing, imageUrl: url);
    //   }));
    //   notifyListeners();
    // }
    // 2. Verifica conectividad antes de llamar a la API
    final isOnline = await ConnectivityService.hasInternet();
    if (!isOnline) {
      if (_userListings.isEmpty) {
        _errorMessage = 'No internet connection and no saved data available.';
        notifyListeners();
      }
      _setLoading(false);
      return;
    }
    // 3. Si hay conexión, sincroniza con la API
    try {
      final attributes = await Amplify.Auth.fetchUserAttributes();
      final email = attributes.firstWhere((a) => a.userAttributeKey.key == 'email').value;
      // Consulta GraphQL personalizada
      const String listUserListingsQuery = '''
        query ListUserListings {
          listListings {
            items {
              id
              price
              status
              photos
              book {
                id
                title
                isbn
                thumbnail
                author {
                  id
                  name
                }
              }
              user {
                email
              }
            }
          }
        }
      ''';
      final request = GraphQLRequest<String>(document: listUserListingsQuery);
      final response = await Amplify.API.query(request: request).response;
      final data = response.data;
      if (data == null) throw Exception('No data from API');
      final decoded = jsonDecode(data) as Map<String, dynamic>;
      final items = decoded['listListings']['items'] as List<dynamic>;
      final listings = items.map((item) => Listing.fromJson(item as Map<String, dynamic>)).toList();
      _userListings = listings.where((listing) {
        final user = listing.user;
        return user != null && user.email == email;
      }).toList();
      _userListingsWithImages = await Future.wait(_userListings.map((listing) async {
        final url = await _getListingImageUrl(listing);
        return ListingWithImage(listing: listing, imageUrl: url);
      }));
      _errorMessage = null;
      debugPrint("✅ Listings del usuario cargados (custom query): "+_userListings.length.toString());
      notifyListeners();
    } catch (e) {
      _userListings = [];
      _userListingsWithImages = [];
      _errorMessage = 'Error fetching user listings: $e';
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  /// 📚 Cargar libros guardados por el usuario
  Future<void> fetchUserLibraryBooks() async {
    _setLoading(true);
    // 1. Siempre intenta cargar desde SQLite primero
    final cachedBooksJson = await DatabaseHelper().getUserLibrary();
    if (cachedBooksJson.isNotEmpty) {
      final cachedBooks = cachedBooksJson.map((item) => Book.fromJson(item)).toList();
      _userLibraryBooks = cachedBooks;
      notifyListeners();
    }
    // 2. Verifica conectividad antes de llamar a la API
    final isOnline = await ConnectivityService.hasInternet();
    if (!isOnline) {
      if (_userLibraryBooks.isEmpty) {
        _errorMessage = 'No internet connection and no saved data available.';
        notifyListeners();
      }
      _setLoading(false);
      return;
    }
    // 3. Si hay conexión, sincroniza con la API
    try {
      final currentUser = await Amplify.Auth.getCurrentUser();
      final userRequest = ModelQueries.list(
        User.classType,
        where: User.EMAIL.eq(currentUser.username),
      );
      final userResponse = await Amplify.API.query(request: userRequest).response;
      final users = (userResponse.data?.items ?? []).whereType<User>().toList();

      if (users.isEmpty) {
        _userLibraryBooks = [];
        return;
      }

      final user = users.first;
      final libraryRequest = ModelQueries.list(
        UserLibrary.classType,
        where: UserLibrary.USER.eq(user),
      );
      final libraryResponse = await Amplify.API.query(request: libraryRequest).response;
      final libraries = (libraryResponse.data?.items ?? []).whereType<UserLibrary>().toList();

      if (libraries.isEmpty) {
        _userLibraryBooks = [];
        return;
      }

      final library = libraries.first;
      final bookEntryRequest = ModelQueries.list(
        BookLibrary.classType,
        where: BookLibrary.USERLIBRARYREF.eq(library),
      );
      final bookEntryResponse = await Amplify.API.query(request: bookEntryRequest).response;
      final bookEntries = (bookEntryResponse.data?.items ?? []).whereType<BookLibrary>().toList();

      _userLibraryBooks = bookEntries
          .where((entry) => entry.book != null)
          .map((entry) => entry.book!)
          .toList();
      // Guardar en caché local (SQLite)
      final booksAsMap = _userLibraryBooks.map((b) => b.toJson()).toList();
      await DatabaseHelper().clearUserLibrary();
      await DatabaseHelper().insertUserLibrary(booksAsMap);
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      if (_userLibraryBooks.isEmpty) {
        _userLibraryBooks = [];
        _errorMessage = 'Error fetching user library books: $e';
        notifyListeners();
      }
    } finally {
      _setLoading(false);
    }
  }

  /// 🗑️ Eliminar listing
  Future<void> deleteListing(Listing listing) async {
    _setLoading(true);
    try {
      final request = ModelMutations.delete(listing);
      final response = await Amplify.API.mutate(request: request).response;
      _userListings.removeWhere((l) => l.id == listing.id);
      _publishedListings.removeWhere((l) => l.id == listing.id);
      notifyListeners();
      debugPrint("🗑️ Listing eliminado: "+listing.id);
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

  Future<String?> _getListingImageUrl(Listing listing) async {
    final book = listing.book;
    if (book?.thumbnail != null && book!.thumbnail!.isNotEmpty) {
      try {
        final result = await Amplify.Storage.getUrl(path: StoragePath.fromString(book.thumbnail!)).result;
        return result.url.toString();
      } catch (e) {
        debugPrint('Error getting S3 url: $e');
      }
    }
    return null;
  }

  void startAutoSync() {
    // Sincroniza cada 5 minutos
    _syncTimer?.cancel();
    _syncTimer = Timer.periodic(const Duration(minutes: 5), (_) {
      fetchPublishedListings();
      fetchUserListings();
    });
    // Observa el ciclo de vida de la app
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      fetchPublishedListings();
      fetchUserListings();
    }
  }

  @override
  void dispose() {
    _syncTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}

/// 📘 Clase auxiliar para manejar libros con imagen
class BookWithImage {
  final Book book;
  final Uri? imageUrl;

  BookWithImage({required this.book, required this.imageUrl});
}

class ListingWithImage {
  final Listing listing;
  final String? imageUrl;
  ListingWithImage({required this.listing, required this.imageUrl});
}

// Función de entrada para el Isolate
void listingsIsolateEntry(Map<String, dynamic> args) async {
  final SendPort sendPort = args['sendPort'];
  final RootIsolateToken rootIsolateToken = args['rootIsolateToken'];
  final List<dynamic> items = args['items'];
  BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);
  // Parseo de los listings
  final parsed = items.map((item) => Listing.fromJson(item as Map<String, dynamic>)).toList();
  sendPort.send(parsed);
}

Future<List<Listing>> parseListingsInIsolate(List<dynamic> items) async {
  final receivePort = ReceivePort();
  final rootIsolateToken = RootIsolateToken.instance!;
  await Isolate.spawn(
    listingsIsolateEntry,
    {
      'sendPort': receivePort.sendPort,
      'rootIsolateToken': rootIsolateToken,
      'items': items,
    },
  );
  final result = await receivePort.first as List<dynamic>;
  return result.cast<Listing>();
}
