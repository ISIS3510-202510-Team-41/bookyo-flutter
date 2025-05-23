import 'package:bookyo_flutter/viewmodels/books_vm.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import 'publish_screen.dart';
import 'notifications_screen.dart';
import 'user_profile_view.dart';
import 'search/search_view.dart';
import 'user_library/user_library_view.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_api/amplify_api.dart';
import '../models/Author.dart';
import 'package:intl/intl.dart';
import '../services/database_helper.dart';

class HomeView extends StatefulWidget {
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Limpia la base de datos local de listings corruptos (solo la primera vez)
    DatabaseHelper().clearListings();
    // 👉 Esto asegura que se carguen los libros y listings al iniciar la app
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final booksVM = Provider.of<BooksViewModel>(context, listen: false);
      booksVM.fetchBooks();
      booksVM.fetchPublishedListings();
      booksVM.startAutoSync();
    });
  }

  void _goToProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => UserProfileView()),
    );
  }

  void _onItemTapped(int index) {
    final booksVM = Provider.of<BooksViewModel>(context, listen: false);

    if (index == 1) {
      booksVM.fetchBooks();
      booksVM.fetchPublishedListings();
    } else if (index == 4) {
      booksVM.fetchUserListings();
    }

    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.person),
          onPressed: _goToProfile,
        ),
        title: const Text("Bookyo", style: TextStyle(color: Colors.black)),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => _onItemTapped(1),
          ),
        ],
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0.5,
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          const _HomeScreen(),
          const SearchView(),
          const PublishScreen(),
          const NotificationsScreen(),
          const UserLibraryView(),
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Divider(color: Colors.grey, height: 1),
            BottomNavigationBar(
              backgroundColor: Colors.white,
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: const Color(0xFFDB995A),
              unselectedItemColor: Colors.grey,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
                BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),
                BottomNavigationBarItem(icon: Icon(Icons.add_box), label: ''),
                BottomNavigationBarItem(icon: Icon(Icons.notifications), label: ''),
                BottomNavigationBarItem(icon: Icon(Icons.menu), label: ''),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ----------------------------------------------
// 🔹 Pantalla principal (Home)
class _HomeScreen extends StatelessWidget {
  const _HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final listings = context.select<BooksViewModel, List<ListingWithImage>>((vm) => vm.publishedListingsWithImages);
    return SizedBox(
      height: MediaQuery.of(context).size.height - kToolbarHeight - 100,
      child: Container(
        color: Colors.white,
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _OptionCard(
                  title: "Browse Books",
                  onTap: () => _onItemTapped(context, 1),
                  imageContent: _ListingCarousel(listings: listings),
                ),
                const SizedBox(height: 20),
                _OptionCard(
                  title: "Publish Book",
                  onTap: () => _onItemTapped(context, 2),
                  imageContent: const Icon(Icons.local_library, size: 80, color: Colors.blueAccent),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onItemTapped(BuildContext context, int index) {
    final state = context.findAncestorStateOfType<_HomeViewState>();
    state?._onItemTapped(index);
  }
}

// ----------------------------------------------
// 🔹 Tarjeta de opción
class _OptionCard extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final Widget? imageContent;

  const _OptionCard({Key? key, required this.title, required this.onTap, this.imageContent})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double imageHeight = 250;
    if (title == "Publish Book") {
      imageHeight = 120; // Más pequeño para Publish Book
    }
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 1,
        child: Column(
          children: [
            Container(
              height: imageHeight,
              width: double.infinity,
              color: Colors.white,
              child: imageContent ?? const Icon(Icons.image, size: 80, color: Colors.black26),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: Text(title),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

// ----------------------------------------------
// 🔹 Carrusel de listings igual que la tarjeta de Listing
class _ListingCarousel extends StatelessWidget {
  final List<ListingWithImage> listings;

  const _ListingCarousel({Key? key, required this.listings}) : super(key: key);

  Widget _buildThumbnail(String? imageUrl) {
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          width: double.infinity,
          errorBuilder: (_, __, ___) => _fallbackThumbnail(),
        ),
      );
    } else {
      return _fallbackThumbnail();
    }
  }

  Widget _fallbackThumbnail() {
    return Container(
      color: Colors.grey[300],
      child: const Center(
        child: Icon(Icons.book, size: 40, color: Colors.black38),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: CarouselSlider(
        options: CarouselOptions(
          height: 230,
          autoPlay: true,
          enlargeCenterPage: true,
          viewportFraction: 0.55,
        ),
        items: listings
            .where((item) {
              final url = item.imageUrl ?? '';
              return url.isNotEmpty && (url.startsWith('http://') || url.startsWith('https://'));
            })
            .map((item) {
              final listing = item.listing;
              final book = listing.book;
              final imageUrl = item.imageUrl;
              if (book == null) return const SizedBox.shrink();
              return SizedBox(
                width: 180,
                child: Card(
                  color: Colors.white,
                  elevation: 3,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: _buildThumbnail(imageUrl),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              book.title,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            book.author?.name != null
                              ? Text(
                                  // ignore: unnecessary_type_check
                                  book.author!.name is String ? book.author!.name : book.author!.name.toString(),
                                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                )
                              : AuthorNameFetcher(
                                  authorId: book.author?.id?.toString(),
                                ),
                            const SizedBox(height: 2),
                            Text(
                              '\$ ${NumberFormat('#,##0', 'es_CO').format(listing.price)}',
                              style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w500, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
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
    return Text(_authorName ?? 'Unknown author', style: const TextStyle(fontSize: 13, color: Colors.black54), maxLines: 1, overflow: TextOverflow.ellipsis);
  }
}
