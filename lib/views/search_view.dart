import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/books_vm.dart';
import '../models/Book.dart';

class SearchView extends StatelessWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final booksVM = context.watch<BooksViewModel>();

    if (booksVM.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (booksVM.errorMessage != null) {
      return Center(
        child: Text(
          booksVM.errorMessage!,
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    if (booksVM.books.isEmpty) {
      return const Center(child: Text('No books found.'));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: booksVM.books.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final book = booksVM.books[index];
        return BookCard(book: book);
      },
    );
  }
}

class BookCard extends StatelessWidget {
  final Book book;

  const BookCard({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: _buildThumbnail(),
        title: Text(
          book.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          book.author?.name ?? 'Unknown Author',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        onTap: () {
        },
      ),
    );
  }

  Widget _buildThumbnail() {
    if (book.thumbnail != null && book.thumbnail!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          book.thumbnail!,
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
