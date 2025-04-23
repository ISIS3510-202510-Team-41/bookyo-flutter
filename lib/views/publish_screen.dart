import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/publish_view_model.dart';

class PublishScreen extends StatelessWidget {
  const PublishScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PublishViewModel(),
      child: const _PublishScreenBody(),
    );
  }
}

class _PublishScreenBody extends StatelessWidget {
  const _PublishScreenBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<PublishViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Publish")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: viewModel.selectImage,
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    image: viewModel.selectedImage != null
                        ? DecorationImage(
                            image: FileImage(File(viewModel.selectedImage!.path)),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: viewModel.selectedImage == null
                      ? const Icon(Icons.image, size: 80, color: Colors.black26)
                      : null,
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: viewModel.selectImage,
                child: const Text("Upload your image"),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: viewModel.isbnController,
                decoration: const InputDecoration(
                  labelText: "ISBN",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: viewModel.titleController,
                decoration: const InputDecoration(
                  labelText: "Title",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: viewModel.authorController,
                decoration: const InputDecoration(
                  labelText: "Author",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: viewModel.priceController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: "Price",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              if (viewModel.errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    viewModel.errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ElevatedButton(
                onPressed: viewModel.isLoading
                    ? null
                    : () => viewModel.publishBook(context, () {
                        Navigator.pop(context);
                      }),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 50),
                ),
                child: viewModel.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Publish"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
