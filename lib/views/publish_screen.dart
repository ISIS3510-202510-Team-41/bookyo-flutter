import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../viewmodels/publish_view_model.dart';
import '../services/connectivity_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../models/Listing.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

class PublishScreen extends StatelessWidget {
  final Listing? listingToEdit;
  const PublishScreen({Key? key, this.listingToEdit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PublishViewModel(),
      child: _PublishScreenBody(listingToEdit: listingToEdit),
    );
  }
}

class _PublishScreenBody extends StatefulWidget {
  final Listing? listingToEdit;
  const _PublishScreenBody({Key? key, this.listingToEdit}) : super(key: key);

  @override
  State<_PublishScreenBody> createState() => _PublishScreenBodyState();
}

class _PublishScreenBodyState extends State<_PublishScreenBody> {
  late PublishViewModel viewModel;
  StreamSubscription? _connectivitySub;
  bool _hasInternet = true;
  Timer? _debounce;
  String? remoteImageUrl;
  bool loadingRemoteImage = false;

  @override
  void initState() {
    super.initState();
    viewModel = Provider.of<PublishViewModel>(context, listen: false);
    if (widget.listingToEdit != null) {
      final book = widget.listingToEdit!.book;
      viewModel.isbnController.text = book?.isbn ?? '';
      viewModel.titleController.text = book?.title ?? '';
      viewModel.authorController.text = book?.author?.name ?? '';
      viewModel.priceController.text = widget.listingToEdit!.price.toString();
      // Precargar imagen remota
      final thumbnail = book?.thumbnail;
      if (thumbnail != null && thumbnail.isNotEmpty) {
        loadingRemoteImage = true;
        Amplify.Storage.getUrl(path: StoragePath.fromString(thumbnail)).result.then((result) {
          if (mounted) {
            setState(() {
              remoteImageUrl = result.url.toString();
              loadingRemoteImage = false;
            });
          }
        }).catchError((_) {
          if (mounted) {
            setState(() {
              remoteImageUrl = null;
              loadingRemoteImage = false;
            });
          }
        });
      }
    } else {
      viewModel.loadDraft();
    }
    _monitorConnectivity();
  }

  void _monitorConnectivity() {
    _connectivitySub = ConnectivityService.onConnectivityChanged.listen((status) {
      final connected = status == ConnectivityResult.mobile || status == ConnectivityResult.wifi;
      if (!connected && _hasInternet) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("⚠️ Connection lost"), backgroundColor: Colors.red),
        );
      } else if (connected && !_hasInternet) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Connection restored"), backgroundColor: Colors.green),
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
    _debounce?.cancel();
    super.dispose();
  }

  void _onFieldChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      setState(() {}); // Solo para validación visual
    });
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Publish", style: TextStyle(color: Colors.black)),
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0.5,
      ),
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
                  child: viewModel.selectedImage != null
                      ? null
                      : loadingRemoteImage
                          ? const Center(child: CircularProgressIndicator())
                          : (remoteImageUrl != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    remoteImageUrl!,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: 150,
                                    errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 80),
                                  ),
                                )
                              : const Icon(Icons.image, size: 80, color: Colors.black26)),
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
                onChanged: _onFieldChanged,
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
                onChanged: _onFieldChanged,
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
                onChanged: _onFieldChanged,
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
                onChanged: _onFieldChanged,
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
                    : () async {
                        await viewModel.publishBook(context, listingToEdit: widget.listingToEdit);
                        if (widget.listingToEdit != null && context.mounted) {
                          Navigator.pop(context, true);
                        }
                      },
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
