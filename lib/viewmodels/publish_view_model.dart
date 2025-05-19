import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/ModelProvider.dart';
import '../models/cached_image.dart';
import '../services/connectivity_service.dart';

class PublishViewModel extends ChangeNotifier {
  final TextEditingController isbnController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController authorController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  XFile? selectedImage;
  bool isLoading = false;
  String? errorMessage;

  Future<void> selectImage(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source);
    if (picked != null) {
      selectedImage = picked;
      debugPrint("✅ Image selected: ${picked.path}");
      notifyListeners();
    } else {
      debugPrint("⚠️ Image selection cancelled.");
    }
  }

  Future<void> publishBook(BuildContext context) async {
    final isbn = isbnController.text.trim();
    final title = titleController.text.trim();
    final authorName = authorController.text.trim();
    final priceText = priceController.text.trim();

    if ([isbn, title, authorName, priceText].any((e) => e.isEmpty) || selectedImage == null) {
      errorMessage = "All fields are required and an image must be uploaded.";
      notifyListeners();
      return;
    }

    if (isbn.length > 13) {
      errorMessage = "ISBN must be at most 13 characters.";
      notifyListeners();
      return;
    }

    if (title.length > 50) {
      errorMessage = "Title must be at most 50 characters.";
      notifyListeners();
      return;
    }

    if (authorName.length > 50) {
      errorMessage = "Author name must be at most 50 characters.";
      notifyListeners();
      return;
    }

    final double? price = double.tryParse(priceText);
    if (price == null || price <= 0 || price > 100000000) {
      errorMessage = "Price must be greater than 0 and less than 100,000,000.";
      notifyListeners();
      return;
    }

    final hasInternet = await ConnectivityService.hasInternet();
    if (!hasInternet) {
      errorMessage = "No internet connection. Please try again later.";
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('❌ No internet connection.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final attributes = await Amplify.Auth.fetchUserAttributes();
      final email = attributes.firstWhere((a) => a.userAttributeKey.key == 'email').value;
      final users = await Amplify.DataStore.query(User.classType, where: User.EMAIL.eq(email));

      late final User user;
      if (users.isNotEmpty) {
        user = users.first;
        debugPrint("👤 Usuario encontrado: ${user.email}");
      } else {
        user = User(email: email);
        await Amplify.DataStore.save(user);
        debugPrint("✅ Usuario creado: ${user.email}");
      }

      final imageKey = "images/${const Uuid().v4()}.jpg";
      final imageFile = File(selectedImage!.path);
      debugPrint("☁️ Subiendo imagen con key: $imageKey");

      await Amplify.Storage.uploadFile(
        path: StoragePath.fromString(imageKey),
        localFile: AWSFile.fromPath(imageFile.path),
      );
      debugPrint("✅ Imagen subida a S3");

      final imageBytes = await imageFile.readAsBytes();
      final cacheBox = await Hive.openBox<CachedImage>('cached_images');
      await cacheBox.put(imageKey, CachedImage(key: imageKey, bytes: imageBytes));
      debugPrint("📦 Imagen guardada en caché local");

      final existingAuthors = await Amplify.DataStore.query(
        Author.classType,
        where: Author.NAME.eq(authorName),
      );

      Author author;
      if (existingAuthors.isNotEmpty) {
        author = existingAuthors.first;
        debugPrint("✅ Autor encontrado: ${author.id}");
      } else {
        author = Author(name: authorName);
        await Amplify.DataStore.save(author);
        debugPrint("✅ Autor creado: ${author.id}");
      }

      final existingBooks = await Amplify.DataStore.query(
        Book.classType,
        where: Book.ISBN.eq(isbn),
      );

      Book book;
      if (existingBooks.isNotEmpty) {
        book = existingBooks.first;
        debugPrint("⚠️ Ya existe un libro con este ISBN: ${book.id}");
      } else {
        book = Book(
          title: title,
          isbn: isbn,
          thumbnail: imageKey,
          author: author,
        );
        await Amplify.DataStore.save(book);
        debugPrint("✅ Libro creado: ${book.id}");
      }

      final listing = Listing(
        book: book,
        price: price,
        photos: [imageKey],
        user: user,
      );
      await Amplify.DataStore.save(listing);
      debugPrint("✅ Listing creado con usuario");

      await clearDraft();
      _reset();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("📚 Book published successfully")),
      );
    } catch (e, st) {
      debugPrint("❌ Error al publicar: $e");
      debugPrint("📄 Stacktrace:\n$st");
      errorMessage = "An error occurred while publishing the book.";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveDraft() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('draft_isbn', isbnController.text);
    await prefs.setString('draft_title', titleController.text);
    await prefs.setString('draft_author', authorController.text);
    await prefs.setString('draft_price', priceController.text);
    debugPrint("📝 Borrador guardado");
  }

  Future<void> loadDraft() async {
    final prefs = await SharedPreferences.getInstance();
    isbnController.text = prefs.getString('draft_isbn') ?? '';
    titleController.text = prefs.getString('draft_title') ?? '';
    authorController.text = prefs.getString('draft_author') ?? '';
    priceController.text = prefs.getString('draft_price') ?? '';
    debugPrint("📂 Borrador cargado");
    notifyListeners();
  }

  Future<void> clearDraft() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('draft_isbn');
    await prefs.remove('draft_title');
    await prefs.remove('draft_author');
    await prefs.remove('draft_price');
    debugPrint("🧹 Borrador limpiado");
  }

  void _reset() {
    isbnController.clear();
    titleController.clear();
    authorController.clear();
    priceController.clear();
    selectedImage = null;
    errorMessage = null;
    notifyListeners();
  }
}
