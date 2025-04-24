import 'package:flutter/material.dart';
import '../../models/Listing.dart';
import '../../views/Book/book_detail_view.dart'; // 👈 Asegúrate de tener este import

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
        if (listing.book == null) return const SizedBox.shrink();
        return _BookListingCard(listing: listing);
      },
    );
  }
}

class _BookListingCard extends StatelessWidget {
  final Listing listing;

  const _BookListingCard({Key? key, required this.listing}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final book = listing.book!;
    final imageUrl = book.thumbnail;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BookDetailView(listing: listing),
            ),
          );
        },
        contentPadding: const EdgeInsets.all(12),
        leading: _buildThumbnail(imageUrl),
        title: Text(book.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(book.author?.name ?? 'Unknown author'),
            const SizedBox(height: 4),
            Text('\$${listing.price.toStringAsFixed(2)}',
                style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _buildThumbnail(String? imageUrl) {
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          imageUrl,
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
