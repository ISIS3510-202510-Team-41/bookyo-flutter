import 'package:bookyo_flutter/viewmodels/books_vm.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import 'publish_screen.dart';
import 'notifications_screen.dart';
import 'user_profile_view.dart'; // 👈 Importación correcta
import 'search_view.dart'; // 🔁 Asegúrate de que la ruta es correcta


List<Map<String, String>> publishedBooks = [];

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
  if (index == 1) {
    // 🔥 Si toca el ícono de búsqueda, hacer fetch de libros
    final booksVM = Provider.of<BooksViewModel>(context, listen: false);
    booksVM.fetchBooks();
  }
  
  setState(() {
    _selectedIndex = index;
  });
}

  void _goToProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => UserProfileView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.person), // 🔥 Cambio: ícono de persona
          onPressed: _goToProfile, // 🔥 Cambio: abre perfil
        ),
        title: const Text("Bookyo"),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              _onItemTapped(1); // Ir a la pestaña de búsqueda/carrito
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          HomeScreen(onTabSelected: _onItemTapped),
          const SearchView(), // 🔁 Reemplazamos SearchScreen por SearchView con VM real
          const PublishScreen(),
          const NotificationsScreen(),
          Container(), // menú
        ],
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Divider(color: Colors.grey),
          BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
              BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),
              BottomNavigationBarItem(icon: Icon(Icons.add_box), label: ''),
              BottomNavigationBarItem(icon: Icon(Icons.notifications), label: ''),
              BottomNavigationBarItem(icon: Icon(Icons.menu), label: ''), // 🔥 Cambio: menú
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Color(0xFFDB995A),
            unselectedItemColor: Colors.grey,
            onTap: _onItemTapped,
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: false,
            showUnselectedLabels: false,
          ),
        ],
      ),
    );
  }
}

// ----------------------------------------------
// 🔹 HomeScreen principal (explorar libros / publicar)
class HomeScreen extends StatelessWidget {
  final Function(int) onTabSelected;

  const HomeScreen({Key? key, required this.onTabSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> books = publishedBooks.isNotEmpty
        ? publishedBooks
        : [
            {"title": "The Great Gatsby", "author": "F. Scott Fitzgerald"},
            {"title": "1984", "author": "George Orwell"},
            {"title": "To Kill a Mockingbird", "author": "Harper Lee"},
          ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const SizedBox(height: 10),
          OptionCard(
            title: "Browse Books",
            onTap: () => onTabSelected(1),
            imageContent: BookCarousel(books: books),
          ),
          const SizedBox(height: 20),
          OptionCard(
            title: "Publish Book",
            onTap: () => onTabSelected(2),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}

// ----------------------------------------------
// 🔹 Pantalla de búsqueda (placeholder)
class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Search Screen'));
  }
}

// ----------------------------------------------
// 🔹 Pantalla vacía de Perfil (no usada aquí directamente)
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Profile Screen'));
  }
}

// ----------------------------------------------
// 🔹 Tarjeta de opciones
class OptionCard extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final Widget? imageContent;

  const OptionCard({Key? key, required this.title, required this.onTap, this.imageContent}) : super(key: key);

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
// 🔹 Carrusel de libros
class BookCarousel extends StatelessWidget {
  final List<Map<String, String>> books;

  const BookCarousel({Key? key, required this.books}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 100,
        autoPlay: true,
        enlargeCenterPage: true,
      ),
      items: books.map((book) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 5.0),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  book["title"]!,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 5),
                Text(
                  book["author"]!,
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
