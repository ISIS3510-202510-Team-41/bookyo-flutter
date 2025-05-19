import 'package:bookyo_flutter/viewmodels/books_vm.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import '../viewmodels/user_library_vm.dart';
import 'publish_screen.dart';
import 'notifications_screen.dart';
import 'user_profile_view.dart';
import 'search/search_view.dart';
import 'user_library/user_library_view.dart';

class HomeView extends StatefulWidget {
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // 👉 Esto asegura que se carguen los libros al iniciar la app
    Future.microtask(() {
      Provider.of<BooksViewModel>(context, listen: false).fetchBooks();
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
    final userLibraryVM = Provider.of<UserLibraryViewModel>(context, listen: false);

    if (index == 1) {
      booksVM.fetchBooks();
      booksVM.fetchPublishedListings();
    } else if (index == 4) {
      userLibraryVM.loadUserListings();
    }

    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.person),
          onPressed: _goToProfile,
        ),
        title: const Text("Bookyo"),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => _onItemTapped(1),
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _HomeScreen(onTabSelected: _onItemTapped),
          const SearchView(),
          const PublishScreen(),
          const NotificationsScreen(),
          const UserLibraryView(),
        ],
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(color: Colors.grey),
          BottomNavigationBar(
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
    );
  }
}

// ----------------------------------------------
// 🔹 Pantalla principal (Home)
class _HomeScreen extends StatelessWidget {
  final void Function(int) onTabSelected;

  const _HomeScreen({Key? key, required this.onTabSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final booksVM = Provider.of<BooksViewModel>(context);
    final books = booksVM.booksWithImages;

    return SizedBox(
      height: MediaQuery.of(context).size.height - kToolbarHeight - 100,
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _OptionCard(
                title: "Browse Books",
                onTap: () => onTabSelected(1),
                imageContent: _BookCarousel(books: books),
              ),
              const SizedBox(height: 20),
              _OptionCard(
                title: "Publish Book",
                onTap: () => onTabSelected(2),
              ),
            ],
          ),
        ),
      ),
    );
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
              color: Theme.of(context).scaffoldBackgroundColor,
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
// 🔹 Carrusel de libros con imágenes S3 o cache local
class _BookCarousel extends StatelessWidget {
  final List<BookWithImage> books;

  const _BookCarousel({Key? key, required this.books}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: CarouselSlider(
        options: CarouselOptions(
          height: 230,
          autoPlay: true,
          enlargeCenterPage: true,
          viewportFraction: 0.45,
        ),
        items: books.map((bookItem) {
          final book = bookItem.book;
          final imageUrl = bookItem.imageUrl?.toString();

          return SizedBox(
            width: 160,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(2, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    imageUrl != null
                        ? Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            color: Colors.grey[300],
                            child: const Icon(Icons.image, size: 60),
                          ),
                    // Overlay oscuro para el texto
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.7),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                    // Título sobre la imagen
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 12,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          book.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Colors.black54,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
