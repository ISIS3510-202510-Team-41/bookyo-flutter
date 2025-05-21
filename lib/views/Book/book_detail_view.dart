import 'package:flutter/material.dart';
import 'package:bookyo_flutter/models/Listing.dart';
import 'package:bookyo_flutter/models/Book.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:intl/intl.dart';

class BookDetailView extends StatefulWidget {
  final Listing listing;

  const BookDetailView({Key? key, required this.listing}) : super(key: key);

  @override
  State<BookDetailView> createState() => _BookDetailViewState();
}

class _BookDetailViewState extends State<BookDetailView> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  String? imageUrl;
  bool loadingImage = true;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.forward();

    _loadImageUrl();
  }

  Future<void> _loadImageUrl() async {
    final book = widget.listing.book;
    if (book?.thumbnail != null && book!.thumbnail!.isNotEmpty) {
      try {
        final result = await Amplify.Storage.getUrl(path: StoragePath.fromString(book.thumbnail!)).result;
        setState(() {
          imageUrl = result.url.toString();
          loadingImage = false;
        });
      } catch (e) {
        setState(() {
          imageUrl = null;
          loadingImage = false;
        });
      }
    } else {
      setState(() {
        imageUrl = null;
        loadingImage = false;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Book book = widget.listing.book!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text("Book Details")),
      body: Center(
        child: SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _BookImageSection(loadingImage: loadingImage, imageUrl: imageUrl),
                  const SizedBox(height: 24),
                  _BookDetailsSection(book: book, listing: widget.listing),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2.5,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.add_shopping_cart, color: Colors.black),
                          label: const Text("Add to Cart", style: TextStyle(color: Colors.black)),
                          onPressed: () {
                            // TODO: lógica de carrito
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFB6EB7A),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2.5,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.arrow_back, color: Colors.black),
                          label: const Text("Back", style: TextStyle(color: Colors.black)),
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFB6EB7A),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BookImageSection extends StatelessWidget {
  final bool loadingImage;
  final String? imageUrl;
  const _BookImageSection({Key? key, required this.loadingImage, required this.imageUrl}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (loadingImage) {
      return const SizedBox(
        width: 160,
        height: 220,
        child: Center(child: CircularProgressIndicator()),
      );
    } else if (imageUrl != null && imageUrl!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          imageUrl!,
          width: 160,
          height: 220,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 100),
        ),
      );
    } else {
      return const Icon(Icons.book, size: 100, color: Colors.grey);
    }
  }
}

class _BookDetailsSection extends StatelessWidget {
  final Book book;
  final Listing listing;
  const _BookDetailsSection({Key? key, required this.book, required this.listing}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          book.title,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          "by ${book.author?.name ?? "Unknown author"}",
          style: const TextStyle(fontSize: 16, color: Colors.black54),
        ),
        const SizedBox(height: 16),
        Text(
          '\$ ${NumberFormat('#,##0', 'es_CO').format(listing.price)}',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
        ),
        const SizedBox(height: 8),
        Text(
          "ISBN: ${book.isbn}",
          style: const TextStyle(fontSize: 14, color: Colors.black87),
        ),
      ],
    );
  }
}
