import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_api/amplify_api.dart';
import '../models/Notification.dart' as model;

class NotificationsViewModel extends ChangeNotifier {
  List<model.Notification> _notifications = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<model.Notification> get notifications => _notifications;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  NotificationsViewModel() {
    debugPrint("📦 ViewModel de notificaciones inicializado.");
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    debugPrint("🔄 Cargando notificaciones desde la API...");

    try {
      final result = await Amplify.API.query(
        request: ModelQueries.list(model.Notification.classType),
      ).response;

      final items = result.data?.items ?? [];
      _notifications = items.whereType<model.Notification>().toList()
        ..sort((a, b) => b.read == false ? -1 : 1);

      debugPrint("✅ ${_notifications.length} notificaciones recibidas.");
    } catch (e) {
      _errorMessage = "Error al cargar notificaciones: $e";
      debugPrint("❌ $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> markAsRead(model.Notification notification) async {
    debugPrint("📩 Marcando como leída: ${notification.id}");

    try {
      final updated = notification.copyWith(read: true);
      await Amplify.API.mutate(
        request: ModelMutations.update(updated),
      ).response;

      final index = _notifications.indexWhere((n) => n.id == notification.id);
      if (index != -1) {
        _notifications[index] = updated;
        debugPrint("✅ Notificación actualizada como leída: ${notification.id}");
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = "Error al actualizar notificación: $e";
      debugPrint("❌ Error al marcar como leída: $e");
      notifyListeners();
    }
  }

  int getUnreadCount() => _notifications.where((n) => !n.read).length;
}
