import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/ModelProvider.dart';

class PublishViewModel extends ChangeNotifier {
  final TextEditingController isbnController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController authorController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  XFile? selectedImage;
  bool isLoading = false;
  String? errorMessage;

  void selectImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      selectedImage = picked;
      debugPrint("✅ Imagen seleccionada: ${picked.path}");
      notifyListeners();
    } else {
      debugPrint("⚠️ Selección de imagen cancelada.");
    }
  }

  Future<void> publishBook(BuildContext context) async {
    final isbn = isbnController.text.trim();
    final title = titleController.text.trim();
    final authorName = authorController.text.trim();
    final priceText = priceController.text.trim();

    if ([isbn, title, authorName, priceText].any((e) => e.isEmpty) || selectedImage == null) {
      errorMessage = "Todos los campos son obligatorios.";
      notifyListeners();
      return;
    }

    final double? price = double.tryParse(priceText);
    if (price == null || price <= 0) {
      errorMessage = "Precio inválido";
      notifyListeners();
      return;
    }

    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      // 1. Subir imagen a S3
      final imageKey = "images/${const Uuid().v4()}.jpg";
      final imageFile = File(selectedImage!.path);
      debugPrint("☁️ Subiendo imagen con key: $imageKey");

      await Amplify.Storage.uploadFile(
        path: StoragePath.fromString(imageKey),
        localFile: AWSFile.fromPath(imageFile.path),
      );
      debugPrint("✅ Imagen subida");

      // 2. Buscar o crear autor
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

      // 3. Buscar o crear libro por ISBN
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

      // 4. Crear Listing
      final listing = Listing(
        book: book,
        price: price,
        photos: [imageKey],
      );
      await Amplify.DataStore.save(listing);
      debugPrint("✅ Listing creado");

      // 5. Asociar el libro a la UserLibrary
      try {
        final attributes = await Amplify.Auth.fetchUserAttributes();
        final emailAttr = attributes.firstWhere((a) => a.userAttributeKey.key == 'email');
        final email = emailAttr.value;
        debugPrint("📧 Email obtenido para asociación de UserLibrary: $email");

        final users = await Amplify.DataStore.query(
          User.classType,
          where: User.EMAIL.eq(email),
        );

        late final User user;

        if (users.isNotEmpty) {
          user = users.first;
          debugPrint("👤 Usuario encontrado: ${user.email}");
        } else {
          user = User(email: email);
          await Amplify.DataStore.save(user);
          debugPrint("✅ Usuario creado: ${user.email}");
        }

        final userLibraries = await Amplify.DataStore.query(
          UserLibrary.classType,
          where: UserLibrary.USER.eq(user),
        );

        late final UserLibrary userLibrary;

        if (userLibraries.isNotEmpty) {
          userLibrary = userLibraries.first;
          debugPrint("📚 Biblioteca encontrada: ${userLibrary.id}");
        } else {
          userLibrary = UserLibrary(user: user);
          await Amplify.DataStore.save(userLibrary);
          debugPrint("📚 Biblioteca creada: ${userLibrary.id}");
        }

        final existingLinks = await Amplify.DataStore.query(
          BookLibrary.classType,
          where: BookLibrary.USERLIBRARYREF.eq(userLibrary).and(BookLibrary.BOOK.eq(book)),
        );

        if (existingLinks.isEmpty) {
          final bookLibrary = BookLibrary(
            book: book,
            userLibraryRef: userLibrary,
          );
          await Amplify.DataStore.save(bookLibrary);
          debugPrint("✅ Libro agregado a la biblioteca del usuario");
        } else {
          debugPrint("⚠️ El libro ya estaba en la biblioteca del usuario");
        }
      } catch (e, st) {
        debugPrint("❌ Error al asociar libro con UserLibrary: $e");
        debugPrint("📄 Stacktrace: $st");
      }

      _reset();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("📚 Libro publicado con éxito")),
      );
    } catch (e, st) {
      debugPrint("❌ Error al publicar: $e");
      debugPrint("📄 Stacktrace:\n$st");
      errorMessage = "Error al publicar el libro.";
    } finally {
      isLoading = false;
      notifyListeners();
    }
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
