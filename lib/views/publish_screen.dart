import 'package:flutter/material.dart';
import 'home_view.dart'; 

class PublishScreen extends StatefulWidget {
  const PublishScreen({Key? key}) : super(key: key);

  @override
  _PublishScreenState createState() => _PublishScreenState();
}

class _PublishScreenState extends State<PublishScreen> {
  final TextEditingController _isbnController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Publish")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(height: 150, width: double.infinity, color: Colors.grey[300], child: const Icon(Icons.image, size: 80, color: Colors.black26)),
            const SizedBox(height: 10),
            TextButton(onPressed: () {}, child: const Text("Upload your images")),
            const SizedBox(height: 20),
            TextField(controller: _isbnController, decoration: const InputDecoration(labelText: "ISBN", border: OutlineInputBorder())),
            const SizedBox(height: 10),
            TextField(controller: _titleController, decoration: const InputDecoration(labelText: "Title", border: OutlineInputBorder())),
            const SizedBox(height: 10),
            TextField(controller: _authorController, decoration: const InputDecoration(labelText: "Author", border: OutlineInputBorder())),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final isbn = _isbnController.text;
                final title = _titleController.text;
                final author = _authorController.text;
                if (isbn.isEmpty || title.isEmpty || author.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Por favor completa todos los campos')));
                  return;
                }
                publishedBooks.add({"isbn": isbn, "title": title, "author": author});
                _isbnController.clear();
                _titleController.clear();
                _authorController.clear();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Libro publicado con éxito')));
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 50)),
              child: const Text("Publish"),
            ),
          ],
        ),
      ),
    );
  }
}
