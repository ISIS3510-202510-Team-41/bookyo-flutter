import 'package:flutter/material.dart';
import 'package:bookyo_flutter/models/Notification.dart' as model;
import 'package:bookyo_flutter/views/Book/book_detail_view.dart';
import 'package:bookyo_flutter/models/Listing.dart';
import 'package:bookyo_flutter/services/connectivity_service.dart';  

class NotificationCard extends StatelessWidget {
  final model.Notification notification;
  final VoidCallback onDismiss;
  final Listing? listing;

  const NotificationCard({
    super.key,
    required this.notification,
    required this.onDismiss,
    this.listing,
  });

  Future<void> _handleViewDetail(BuildContext context) async {
    final hasConnection = await ConnectivityService.hasInternet(); 

    if (!hasConnection) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("🔌 No internet connection. Please try again later."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (listing == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("📚 No book linked to this notification."),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BookDetailView(listing: listing!),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.info_outline, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: onDismiss,
                      ),
                    ],
                  ),
                  Text(notification.body),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => _handleViewDetail(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB8E986),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    child: const Text("Ver detalle"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
