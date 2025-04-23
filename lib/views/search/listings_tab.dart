import 'package:flutter/material.dart';
import '../../models/Listing.dart';
import '../../models/Book.dart';

class ListingsTab extends StatelessWidget {
  final List<Listing> listings;

  const ListingsTab({Key? key, required this.listings}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (listings.isEmpty) {
      return const Center(child: Text('No listings available yet.'));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: listings.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final listing = listings[index];
        final book = listing.book;
        if (book == null) return const SizedBox.shrink();
        return _BookListingCard(book: book, price: listing.price, imageUrl: book.thumbnail);
      },
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
      elevation: 3,
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
            Text('\$${price.toStringAsFixed(2)}',
                style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w500)),
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
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.book, size: 40, color: Colors.black38),
    );
  }
}
