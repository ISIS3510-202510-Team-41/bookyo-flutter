import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/books_vm.dart';
import '../../models/Book.dart';

class UserLibraryView extends StatefulWidget {
  const UserLibraryView({Key? key}) : super(key: key);

  @override
  State<UserLibraryView> createState() => _UserLibraryViewState();
}

class _UserLibraryViewState extends State<UserLibraryView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<BooksViewModel>().fetchUserListings());
  }

  @override
  Widget build(BuildContext context) {
    final booksVM = context.watch<BooksViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text("My Library")),
      body: booksVM.isLoading
          ? const Center(child: CircularProgressIndicator())
          : booksVM.errorMessage != null
              ? Center(
                  child: Text(booksVM.errorMessage!,
                      style: const TextStyle(color: Colors.red)))
              : booksVM.userListings.isEmpty
                  ? const Center(child: Text('You have not listed any books yet.'))
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: booksVM.userListings.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final listing = booksVM.userListings[index];
                        final book = listing.book;
                        if (book == null) return const SizedBox.shrink();
                        return _BookListingCard(
                          book: book,
                          price: listing.price,
                          imageUrl: book.thumbnail,
                        );
                      },
                    ),
    );
  }
}

class _BookListingCard extends StatelessWidget {
  final Book book;
  final double price;
  final String? imageUrl;

  const _BookListingCard({
    Key? key,
    required this.book,
    required this.price,
    this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: _buildThumbnail(),
        title: Text(book.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(book.author?.name ?? 'Unknown author'),
            const SizedBox(height: 4),
            Text(
              '\$${price.toStringAsFixed(2)}',
              style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThumbnail() {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          imageUrl!,
          width: 60,
          height: 80,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _fallbackThumbnail(),
        ),
      );
    } else {
      return _fallbackThumbnail();
    }
  }

  Widget _fallbackThumbnail() {
    return Container(
      width: 60,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.book, size: 40, color: Colors.black38),
    );
  }
}
