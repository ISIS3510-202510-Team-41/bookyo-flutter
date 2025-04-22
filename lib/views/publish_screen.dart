import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import '../models/Book.dart';
import '../models/Author.dart';
import '../models/Listing.dart';

class PublishScreen extends StatefulWidget {
  const PublishScreen({Key? key}) : super(key: key);

  @override
  _PublishScreenState createState() => _PublishScreenState();
}

class _PublishScreenState extends State<PublishScreen> {
  final TextEditingController _isbnController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  String? _localImagePath;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _localImagePath = pickedFile.path;
      });
    }
  }

  Future<void> _publishBook() async {
    final isbn = _isbnController.text.trim();
    final title = _titleController.text.trim();
    final authorName = _authorController.text.trim();
    final priceText = _priceController.text.trim();

    if (isbn.isEmpty || title.isEmpty || authorName.isEmpty || priceText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor completa todos los campos')),
      );
      return;
    }

    final double? price = double.tryParse(priceText);
    if (price == null || price <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Precio inválido')),
      );
      return;
    }

    try {
      final author = Author(name: authorName);
      await Amplify.DataStore.save(author);

      final newBook = Book(
        title: title,
        isbn: isbn,
        author: author,
        thumbnail: _localImagePath,
      );
      await Amplify.DataStore.save(newBook);

      final listing = Listing(
        book: newBook,
        price: price,
        photos: _localImagePath != null ? [_localImagePath!] : [],
      );
      await Amplify.DataStore.save(listing);

      _isbnController.clear();
      _titleController.clear();
      _authorController.clear();
      _priceController.clear();
      setState(() {
        _localImagePath = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('📚 Libro publicado con éxito')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Error al publicar: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Publish")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    image: _localImagePath != null
                        ? DecorationImage(
                            image: FileImage(File(_localImagePath!)),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: _localImagePath == null
                      ? const Icon(Icons.image, size: 80, color: Colors.black26)
                      : null,
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: _pickImage,
                child: const Text("Upload your image"),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _isbnController,
                decoration: const InputDecoration(
                  labelText: "ISBN",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: "Title",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _authorController,
                decoration: const InputDecoration(
                  labelText: "Author",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _priceController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: "Price",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _publishBook,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 50),
                ),
                child: const Text("Publish"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
