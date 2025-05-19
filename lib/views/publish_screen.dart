import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../viewmodels/publish_view_model.dart';
import '../services/connectivity_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

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

class _PublishScreenBody extends StatefulWidget {
  const _PublishScreenBody({Key? key}) : super(key: key);

  @override
  State<_PublishScreenBody> createState() => _PublishScreenBodyState();
}

class _PublishScreenBodyState extends State<_PublishScreenBody> {
  late PublishViewModel viewModel;
  StreamSubscription? _connectivitySub;
  bool _hasInternet = true;

  @override
  void initState() {
    super.initState();
    viewModel = Provider.of<PublishViewModel>(context, listen: false);
    viewModel.loadDraft(); // ← Cargar el borrador local si existe
    _monitorConnectivity();
  }

  void _monitorConnectivity() {
    _connectivitySub = ConnectivityService.onConnectivityChanged.listen((status) {
      final connected = status == ConnectivityResult.mobile || status == ConnectivityResult.wifi;
      if (!connected && _hasInternet) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("⚠️ Conexión perdida"), backgroundColor: Colors.red),
        );
      } else if (connected && !_hasInternet) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Conexión restablecida"), backgroundColor: Colors.green),
        );
      }
      setState(() {
        _hasInternet = connected;
      });
    });
  }

  @override
  void dispose() {
    _connectivitySub?.cancel();
    super.dispose();
  }

  void _showImageSourceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Choose Image Source"),
        content: const Text("Select an image from gallery or take a photo with camera."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              viewModel.selectImage(ImageSource.gallery);
            },
            child: const Text("Gallery"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              viewModel.selectImage(ImageSource.camera);
            },
            child: const Text("Camera"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    viewModel = Provider.of<PublishViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Publish")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => _showImageSourceDialog(context),
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
                onPressed: () => _showImageSourceDialog(context),
                child: const Text("Upload your image"),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: viewModel.isbnController,
                maxLength: 13,
                onChanged: (_) => viewModel.saveDraft(),
                decoration: const InputDecoration(
                  labelText: "ISBN",
                  border: OutlineInputBorder(),
                  counterText: "",
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: viewModel.titleController,
                maxLength: 50,
                onChanged: (_) => viewModel.saveDraft(),
                decoration: const InputDecoration(
                  labelText: "Title",
                  border: OutlineInputBorder(),
                  counterText: "",
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: viewModel.authorController,
                maxLength: 50,
                onChanged: (_) => viewModel.saveDraft(),
                decoration: const InputDecoration(
                  labelText: "Author",
                  border: OutlineInputBorder(),
                  counterText: "",
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: viewModel.priceController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                onChanged: (_) => viewModel.saveDraft(),
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
                onPressed: viewModel.isLoading ? null : () => viewModel.publishBook(context),
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
