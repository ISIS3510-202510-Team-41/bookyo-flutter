import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bookyo_flutter/models/Listing.dart';
import 'package:bookyo_flutter/viewmodels/books_vm.dart';
import 'package:bookyo_flutter/views/publish_screen.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:intl/intl.dart';

class UserBookDetailView extends StatefulWidget {
  final Listing listing;

  const UserBookDetailView({super.key, required this.listing});

  @override
  State<UserBookDetailView> createState() => _UserBookDetailViewState();
}

class _UserBookDetailViewState extends State<UserBookDetailView>
    with SingleTickerProviderStateMixin {
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
    final book = widget.listing.book!;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Book"),
        centerTitle: true,
      ),
      body: Center(
        child: SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (loadingImage)
                    const SizedBox(
                      width: 160,
                      height: 220,
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (imageUrl != null && imageUrl!.isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        imageUrl!,
                        width: 160,
                        height: 220,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.broken_image, size: 100),
                      ),
                    )
                  else
                    Container(
                      width: 160,
                      height: 220,
                      color: Colors.grey[200],
                      child: const Icon(Icons.book, size: 60),
                    ),
                  const SizedBox(height: 16),
                  Text(book.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text("by ${book.author?.name ?? 'Unknown author'}",
                      style: const TextStyle(fontSize: 16, color: Colors.black54)),
                  const SizedBox(height: 8),
                  Text(
                    '\$ ${NumberFormat('#,##0', 'es_CO').format(widget.listing.price)}',
                    style: const TextStyle(fontSize: 18, color: Colors.green),
                  ),
                  const SizedBox(height: 8),
                  Text("ISBN: ${book.isbn}",
                      style: const TextStyle(fontSize: 14, color: Colors.black87)),

                  const SizedBox(height: 20),
                  // 🆕 BOTONES EN FILA
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2.5,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.edit, color: Colors.black),
                          label: const Text("Edit", style: TextStyle(color: Colors.black)),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PublishScreen(
                                  listingToEdit: widget.listing,
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFB6EB7A),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2.5,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.delete, color: Colors.black),
                          label: const Text("Delete", style: TextStyle(color: Colors.black)),
                          onPressed: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text("Confirm Deletion"),
                                content: const Text("Are you sure you want to delete this listing?"),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, false),
                                    child: const Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, true),
                                    child: const Text("Delete", style: TextStyle(color: Colors.red)),
                                  ),
                                ],
                              ),
                            );

                            if (confirm == true) {
                              final booksVM = context.read<BooksViewModel>();
                              await booksVM.deleteListing(widget.listing);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Listing deleted")),
                                );
                                Navigator.pop(context, 'deleted');
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFB6EB7A),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
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
