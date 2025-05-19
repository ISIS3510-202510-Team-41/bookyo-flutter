import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  static final Connectivity _connectivity = Connectivity();

  /// Verifica si hay conexión a internet (WiFi o datos móviles)
  static Future<bool> hasInternet() async {
    final results = await _connectivity.checkConnectivity();
    return results.contains(ConnectivityResult.mobile) ||
           results.contains(ConnectivityResult.wifi);
  }

  /// Escucha los cambios de conectividad en tiempo real
  static Stream<ConnectivityResult> get onConnectivityChanged =>
      _connectivity.onConnectivityChanged.map((results) => results.first);
}
