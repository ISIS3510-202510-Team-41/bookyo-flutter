import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/notifications_view_model.dart';
import 'notification_card.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NotificationsViewModel(),
      child: const NotificationsBody(),
    );
  }
}

class NotificationsBody extends StatelessWidget {
  const NotificationsBody({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<NotificationsViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Notifications")),
      body: Builder(
        builder: (context) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.errorMessage != null) {
            return Center(child: Text(viewModel.errorMessage!));
          }

          if (viewModel.notifications.isEmpty) {
            return const Center(child: Text("There are no notifications."));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: viewModel.notifications.length,
            itemBuilder: (context, index) {
              final notification = viewModel.notifications[index];
              return NotificationCard(
                notification: notification,
                onDismiss: () => viewModel.markAsRead(notification),
              );
            },
          );
        },
      ),
    );
  }
}