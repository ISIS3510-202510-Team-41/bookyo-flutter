import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/user_library_vm.dart';
import '../../models/Listing.dart';
import '../../views/Book/userbook_detail_view.dart';
import '../../viewmodels/books_vm.dart';
import '../../main.dart'; // Importa el routeObserver
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import '../../models/Author.dart';
import 'package:intl/intl.dart';

class UserLibraryView extends StatefulWidget {
  const UserLibraryView({Key? key}) : super(key: key);

  @override
  State<UserLibraryView> createState() => _UserLibraryViewState();
}

class _UserLibraryViewState extends State<UserLibraryView> with RouteAware {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BooksViewModel>().fetchUserListings();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)! as PageRoute);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<BooksViewModel>().fetchUserListings();
      }
    });
  }

  @override
  void didPush() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<BooksViewModel>().fetchUserListings();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.select<BooksViewModel, bool>((vm) => vm.isLoading);
    final userListingsWithImages = context.select<BooksViewModel, List<ListingWithImage>>((vm) => vm.userListingsWithImages);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("My Library", style: TextStyle(color: Colors.black)),
        automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0.5,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : userListingsWithImages.isEmpty
              ? const Center(child: Text('You have not listed any books yet.'))
              : _UserListingsList(userListingsWithImages: userListingsWithImages),
    );
  }
}

class _UserListingsList extends StatelessWidget {
  final List<ListingWithImage> userListingsWithImages;
  const _UserListingsList({Key? key, required this.userListingsWithImages}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: userListingsWithImages.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = userListingsWithImages[index];
        final listing = item.listing;
        final book = listing.book!;
        if (book == null) return const SizedBox.shrink();
        debugPrint('USER LIBRARY CARD: book.title=[200m${book.title}[0m, author=[200m${book.author}[0m, authorName=[200m${book.author?.name}[0m');
        return _BookListingCard(listing: listing, imageUrl: item.imageUrl);
      },
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

    return GestureDetector(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => UserBookDetailView(listing: listing),
          ),
        );

        if (result == 'deleted' && context.mounted) {
          await context.read<BooksViewModel>().fetchUserListings();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Listing successfully deleted")),
          );
        }
      },
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          contentPadding: const EdgeInsets.all(12),
          leading: _buildThumbnail(imageUrl),
          title: Text(book.title, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              book.author?.name != null
                // ignore: unnecessary_type_check
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
      ),
    );
  }

  Widget _buildThumbnail(String? url) {
    if (url != null && url.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          url,
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
