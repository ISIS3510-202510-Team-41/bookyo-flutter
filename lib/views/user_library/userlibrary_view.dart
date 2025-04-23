import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/Book.dart';
import '../../viewmodels/user_library_vm.dart';

class UserLibraryView extends StatefulWidget {
  const UserLibraryView({Key? key}) : super(key: key);

  @override
  State<UserLibraryView> createState() => _UserLibraryViewState();
}

class _UserLibraryViewState extends State<UserLibraryView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<UserLibraryViewModel>().loadUserLibrary());
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<UserLibraryViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text("My Library")),
      body: vm.isLoading
          ? const Center(child: CircularProgressIndicator())
          : vm.errorMessage != null
              ? Center(child: Text(vm.errorMessage!, style: const TextStyle(color: Colors.red)))
              : vm.userBooks.isEmpty
                  ? const Center(child: Text("Your library is empty."))
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: vm.userBooks.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        return _BookCard(book: vm.userBooks[index]);
                      },
                    ),
    );
  }
}

class _BookCard extends StatelessWidget {
  final Book book;

  const _BookCard({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: _buildThumbnail(book.thumbnail),
        title: Text(book.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(book.author?.name ?? 'Unknown author'),
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
