import 'package:flutter/material.dart';
import '../../models/Listing.dart';
import '../../viewmodels/books_vm.dart';
import '../../views/Book/book_detail_view.dart'; // 👈 Asegúrate de tener este import
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_api/amplify_api.dart';
import '../../models/Author.dart';
import 'package:intl/intl.dart';

class ListingsTab extends StatefulWidget {
  final List<ListingWithImage> listingsWithImages;

  const ListingsTab({Key? key, required this.listingsWithImages}) : super(key: key);

  @override
  State<ListingsTab> createState() => _ListingsTabState();
}

class _ListingsTabState extends State<ListingsTab> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Filtrado flexible por título o autor
    final filteredListings = widget.listingsWithImages.where((item) {
      final book = item.listing.book;
      if (book == null) return false;
      final title = book.title.toLowerCase();
      final author = (book.author?.name ?? '').toLowerCase();
      final query = _searchText.trim().toLowerCase();
      return title.contains(query) || author.contains(query);
    }).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: TextField(
            controller: _searchController,
            onChanged: (value) {
              setState(() {
                _searchText = value;
              });
            },
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: 'Search by title or author',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey[100],
              contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
            ),
          ),
        ),
        Expanded(
          child: filteredListings.isEmpty
              ? const Center(child: Text('No results found.'))
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredListings.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = filteredListings[index];
                    final listing = item.listing;
                    if (listing.book == null) return const SizedBox.shrink();
                    return _BookListingCard(listing: listing, imageUrl: item.imageUrl);
                  },
                ),
        ),
      ],
    );
  }
}

class _BookListingCard extends StatelessWidget {
  final Listing listing;
  final String? imageUrl;

  const _BookListingCard({Key? key, required this.listing, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final book = listing.book!;
    // DEBUG: Log para ver el valor del autor
    debugPrint('LISTINGS CARD: book.title=${book.title}, author=${book.author}, authorName=${book.author?.name}');

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
            book.author?.name != null
              ? Text(book.author!.name is String ? book.author!.name : book.author!.name.toString())
              : AuthorNameFetcher(authorId: book.author?.id?.toString()),
            const SizedBox(height: 4),
            Text(
              '\$ ${NumberFormat('#,##0', 'es_CO').format(listing.price)}',
              style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThumbnail(String? imageUrl) {
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
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
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: Icon(Icons.book, size: 40, color: Colors.black38),
      ),
    );
  }
}

// Widget para obtener el nombre del autor si no está presente
class AuthorNameFetcher extends StatefulWidget {
  final String? authorId;
  const AuthorNameFetcher({Key? key, required this.authorId}) : super(key: key);

  @override
  State<AuthorNameFetcher> createState() => _AuthorNameFetcherState();
}

class _AuthorNameFetcherState extends State<AuthorNameFetcher> {
  static final Map<String, String> _authorNameCache = {};
  String? _authorName;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _fetchAuthorName();
  }

  Future<void> _fetchAuthorName() async {
    if (widget.authorId == null) return;
    if (_authorNameCache.containsKey(widget.authorId)) {
      setState(() => _authorName = _authorNameCache[widget.authorId]);
      return;
    }
    setState(() => _loading = true);
    try {
      final request = ModelQueries.get(Author.classType, AuthorModelIdentifier(id: widget.authorId!));
      final response = await Amplify.API.query(request: request).response;
      final author = response.data as Author?;
      if (author != null) {
        _authorNameCache[widget.authorId!] = author.name;
        setState(() => _authorName = author.name);
      } else {
        setState(() => _authorName = 'Unknown author');
      }
    } catch (e) {
      setState(() => _authorName = 'Unknown author');
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Text('Cargando autor...', style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey));
    return Text(_authorName ?? 'Unknown author');
  }
}
