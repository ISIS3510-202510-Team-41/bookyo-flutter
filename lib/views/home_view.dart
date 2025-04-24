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
            onPressed: () => _onItemTapped(1), // Navega a SearchView
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _HomeScreen(onTabSelected: _onItemTapped), // 0
          const SearchView(),                        // 1
          const PublishScreen(),                     // 2
          const NotificationsScreen(),               // 3
          const UserLibraryView(),                   // 4
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
    final List<Map<String, String>> publishedBooks = [
      {"title": "The Great Gatsby", "author": "F. Scott Fitzgerald"},
      {"title": "1984", "author": "George Orwell"},
      {"title": "To Kill a Mockingbird", "author": "Harper Lee"},
    ];

    final List<Map<String, String>> books = publishedBooks.isNotEmpty
        ? publishedBooks
        : const [
            {"title": "The Great Gatsby", "author": "F. Scott Fitzgerald"},
            {"title": "1984", "author": "George Orwell"},
            {"title": "To Kill a Mockingbird", "author": "Harper Lee"},
          ];

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
                onTap: () => onTabSelected(1), // Navega a búsqueda
                imageContent: _BookCarousel(books: books),
              ),
              const SizedBox(height: 20),
              _OptionCard(
                title: "Publish Book",
                onTap: () => onTabSelected(2), // Navega a publicación
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
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 1,
        child: Column(
          children: [
            Container(
              height: 150,
              width: double.infinity,
              color: Colors.grey[300],
              child: imageContent ??
                  const Icon(Icons.image, size: 80, color: Colors.black26),
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
// 🔹 Carrusel de libros
class _BookCarousel extends StatelessWidget {
  final List<Map<String, String>> books;

  const _BookCarousel({Key? key, required this.books}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 200,
        autoPlay: true,
        enlargeCenterPage: true,
        viewportFraction: 0.45,
      ),
      items: books.map((book) {
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
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  width: 12,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.brown,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomLeft: Radius.circular(12),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 12, 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        book["title"]!,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        book["author"]!,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
