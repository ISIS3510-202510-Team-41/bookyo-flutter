import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/books_vm.dart';
import 'listings_tab.dart';
import 'books_tab.dart';

class SearchView extends StatefulWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final booksVM = context.watch<BooksViewModel>();

    if (booksVM.isLoading) return const Center(child: CircularProgressIndicator());
    if (booksVM.errorMessage != null) {
      return Center(
        child: Text(booksVM.errorMessage!, style: const TextStyle(color: Colors.red)),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: DefaultTabController(
        length: 1,
        child: Column(
          children: [
            TabBar(
              tabs: [
                // Tab(text: 'Books'), // ← Comentado provisionalmente
                Tab(text: 'Listings'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // BooksTab(books: allBooks), // ← Comentado provisionalmente
                  ListingsTab(listingsWithImages: booksVM.publishedListingsWithImages),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
