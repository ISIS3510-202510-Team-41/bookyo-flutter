import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import '../models/Listing.dart';

class ListingsViewModel extends ChangeNotifier {
  List<Listing> _listings = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Listing> get listings => _listings;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  ListingsViewModel() {
    fetchListings(); // Automáticamente hace fetch al inicializarse
  }

  Future<void> fetchListings() async {
    _setLoading(true);

    try {
      final result = await Amplify.DataStore.query(Listing.classType);
      _listings = result;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Error fetching listings: $e';
      _listings = [];
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
