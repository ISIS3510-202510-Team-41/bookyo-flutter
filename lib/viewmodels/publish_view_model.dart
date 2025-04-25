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
      debugPrint("✅ Image selected: ${picked.path}");
      notifyListeners();
    } else {
      debugPrint("⚠️ Image selection canceled.");
    }
  }

  Future<void> publishBook(BuildContext context) async {
    final isbn = isbnController.text.trim();
    final title = titleController.text.trim();
    final authorName = authorController.text.trim();
    final priceText = priceController.text.trim();

    if ([isbn, title, authorName, priceText].any((e) => e.isEmpty) || selectedImage == null) {
      errorMessage = "All fields are required.";
      notifyListeners();
      return;
    }

    final double? price = double.tryParse(priceText);
    if (price == null || price <= 0) {
      errorMessage = "Invalid price.";
      notifyListeners();
      return;
    }

    // 🔍 Check connection
    try {
      await Amplify.Auth.fetchAuthSession(); // this will throw if there's no connection
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("❌ Could not publish. Check your internet connection."),
          backgroundColor: Colors.redAccent,
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
        debugPrint("👤 User found: ${user.email}");
      } else {
        user = User(email: email);
        await Amplify.DataStore.save(user);
        debugPrint("✅ User created: ${user.email}");
      }

      final imageKey = "images/${const Uuid().v4()}.jpg";
      final imageFile = File(selectedImage!.path);
      debugPrint("☁️ Uploading image with key: $imageKey");

      await Amplify.Storage.uploadFile(
        path: StoragePath.fromString(imageKey),
        localFile: AWSFile.fromPath(imageFile.path),
      );
      debugPrint("✅ Image uploaded");

      final existingAuthors = await Amplify.DataStore.query(
        Author.classType,
        where: Author.NAME.eq(authorName),
      );

      Author author;
      if (existingAuthors.isNotEmpty) {
        author = existingAuthors.first;
        debugPrint("✅ Author found: ${author.id}");
      } else {
        author = Author(name: authorName);
        await Amplify.DataStore.save(author);
        debugPrint("✅ Author created: ${author.id}");
      }

      final existingBooks = await Amplify.DataStore.query(
        Book.classType,
        where: Book.ISBN.eq(isbn),
      );

      Book book;
      if (existingBooks.isNotEmpty) {
        book = existingBooks.first;
        debugPrint("⚠️ A book with this ISBN already exists: ${book.id}");
      } else {
        book = Book(
          title: title,
          isbn: isbn,
          thumbnail: imageKey,
          author: author,
        );
        await Amplify.DataStore.save(book);
        debugPrint("✅ Book created: ${book.id}");
      }

      final listing = Listing(
        book: book,
        price: price,
        photos: [imageKey],
        user: user,
      );
      await Amplify.DataStore.save(listing);
      debugPrint("✅ Listing created with user");

      _reset();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("📚 Book published successfully")),
      );
    } catch (e, st) {
      debugPrint("❌ Error publishing: $e");
      debugPrint("📄 Stacktrace:\n$st");
      errorMessage = "Error publishing the book.";
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
