import 'package:flutter/material.dart';
import 'user_profile_view.dart';
import 'package:carousel_slider/carousel_slider.dart';


class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    //final authViewModel = Provider.of<AuthViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.person),
          onPressed: () {
            Navigator.push(
              context, MaterialPageRoute(builder: (_) => UserProfileView()));
          },
        ),
        title: Text("Bookyo"),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              setState(() {
          _selectedIndex = 1; // Assuming the cart should navigate to the SearchScreen
              });
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          HomeScreen(onTabSelected: _onItemTapped), // 🔥 Pasa la función aquí
          const SearchScreen(),
          const PublishScreen(),
          const NotificationsScreen(),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Divider(color: Colors.grey),
          BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.add_box), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFFDB995A),
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedFontSize: 0,
        unselectedFontSize: 0,
          ),
        ],
      ),
    );
  }
}

// Pantallas de cada pestaña
//class HomeScreen extends StatelessWidget {
  //const HomeScreen({Key? key}) : super(key: key);
  //@override
  //Widget build(BuildContext context) {
    //return Center(child: Text('Home Screennn'));
  //}
//}

class HomeScreen extends StatelessWidget {
  final Function(int) onTabSelected;

  const HomeScreen({Key? key, required this.onTabSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> books = [
      {"title": "The Great Gatsby", "author": "F. Scott Fitzgerald"},
      {"title": "1984", "author": "George Orwell"},
      {"title": "To Kill a Mockingbird", "author": "Harper Lee"},
    ];

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 10),

              // 📚 Browse Books con el carrusel
              OptionCard(
                title: "Browse Books",
                onTap: () => onTabSelected(1),
                imageContent: BookCarousel(books: books), // 🔥 Pasamos el carrusel
              ),

              const SizedBox(height: 20),

              // 📚 Publish Book con la imagen estática
              OptionCard(
                title: "Publish Book",
                onTap: () => onTabSelected(2),
              ),

              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}


class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Search Screen'));
  }
}

class PublishScreen extends StatefulWidget {
  const PublishScreen({Key? key}) : super(key: key);

  @override
  _PublishScreenState createState() => _PublishScreenState();
}

class _PublishScreenState extends State<PublishScreen> {
  final TextEditingController _isbnController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Publish"),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              // Acción del carrito
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Imagen Placeholder
            Container(
              height: 150,
              width: double.infinity,
              color: Colors.grey[300],
              child: const Icon(Icons.image, size: 80, color: Colors.black26),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                // Función para subir imágenes
              },
              child: const Text("Upload your images"),
            ),
            const SizedBox(height: 20),

            // Campos de texto
            TextField(
              controller: _isbnController,
              decoration: const InputDecoration(
                labelText: "ISBN",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: "Title",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _authorController,
              decoration: const InputDecoration(
                labelText: "Author",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Botón Publicar
            ElevatedButton(
              onPressed: () {
                // Función para publicar el libro
                print("ISBN: ${_isbnController.text}");
                print("Title: ${_titleController.text}");
                print("Author: ${_authorController.text}");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 50),
              ),
              child: const Text("Publish"),
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Notifications Screen'));
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Profile Screen'));
  }
}


// Widget Reutilizable para las Opciones
class OptionCard extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final Widget? imageContent; // 🔥 Ahora permite un widget como contenido superior

  const OptionCard({Key? key, required this.title, required this.onTap, this.imageContent})
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
              child: imageContent ?? // 🔥 Usa el widget si se proporciona, sino usa la imagen
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

// 📚 Carrusel de Libros
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