import 'package:flutter/material.dart';
import 'package:bookyo_flutter/models/Listing.dart';
import 'package:intl/intl.dart';

class CartView extends StatelessWidget {
  final List<Listing> cartItems;
  final void Function(Listing) onRemove;

  const CartView({
    Key? key,
    required this.cartItems,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Cart"),
        backgroundColor: Colors.green.shade300,
      ),
      body: cartItems.isEmpty
          ? const Center(child: Text("🛒 Your cart is empty"))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      itemCount: cartItems.length,
                      separatorBuilder: (_, __) => const Divider(),
                      itemBuilder: (context, index) {
                        final listing = cartItems[index];
                        final book = listing.book!;
                        return ListTile(
                          leading: const Icon(Icons.book),
                          title: Text(book.title),
                          subtitle: Text("by ${book.author?.name ?? 'Unknown'}"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "\$ ${NumberFormat('#,##0', 'es_CO').format(listing.price)}",
                                style: const TextStyle(color: Colors.green),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => onRemove(listing),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("🚀 Proceeding to checkout...")),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      "Continue to Checkout",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
